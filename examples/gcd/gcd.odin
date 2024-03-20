// +vet
package main

import wt "../.."
import "core:fmt"
import "core:os"

main :: proc() {
	// Set up our context
	engine := wt.wasm_engine_new()
	assert(engine != nil)
	defer wt.wasm_engine_delete(engine)

	store := wt.wasmtime_store_new(engine, nil, nil)
	assert(store != nil)
	defer wt.wasmtime_store_delete(store)
	wtctx := wt.wasmtime_store_context(store)

	// Create a linker with WASI functions defined
	linker := wt.wasmtime_linker_new(engine)
	error := wt.wasmtime_linker_define_wasi(linker)
	if error != nil {exit_with_error("failed to link wasi", error, nil)}

	wasm: wt.wasm_byte_vec_t
	wat := #load("gcd.wat")
	err := wt.wasmtime_wat2wasm(cstring(&wat[0]), len(wat), &wasm)
	if err != nil {fmt.printf("> Error loading module!\n");os.exit(1)}
	assert(wasm.size > 0)

	// Compile our modules
	module: wt.wasmtime_module = nil
	error = wt.wasmtime_module_new(engine, wasm.data, wasm.size, &module)
	if module == nil {exit_with_error("failed to compile module", error, nil)}
	defer wt.wasmtime_module_delete(module)

	wt.wasm_byte_vec_delete(&wasm)

	// Instantiate wasi
	wasi_config := wt.wasi_config_new()
	defer wt.wasi_config_delete(wasi_config)
	wt.wasi_config_inherit_argv(wasi_config)
	wt.wasi_config_inherit_env(wasi_config)
	wt.wasi_config_inherit_stdin(wasi_config)
	wt.wasi_config_inherit_stdout(wasi_config)
	wt.wasi_config_inherit_stderr(wasi_config)
	error = wt.wasmtime_context_set_wasi(wtctx, wasi_config)
	if error != nil {exit_with_error("failed to instantiate WASI", error, nil)}

	// Instantiate the module
	error = wt.wasmtime_linker_module(linker, wtctx, "", 0, module)
	if error != nil {exit_with_error("failed to instantiate module", error, nil)}

	instance: wt.wasmtime_instance_t
	trap: wt.wasm_trap = nil
	error = wt.wasmtime_linker_instantiate(linker, wtctx, module, &instance, &trap)
	if error != nil || trap != nil {exit_with_error("error calling default export", error, trap)}

	item: wt.wasmtime_extern_t
	fname := cstring("gcd")
	ok := wt.wasmtime_instance_export_get(wtctx, &instance, fname, len(fname), &item)
	assert(ok)

	if item.kind == .WASM_EXTERN_FUNC {
		func: wt.wasmtime_func_t = item.of.func
		args := [2]wt.wasmtime_val_t{{kind = .WASM_I32, of = {i32 = 27}}, {kind = .WASM_I32, of = {i32 = 6}}}
		results := wt.wasmtime_val_t {kind = .WASM_I32,	of = {i32 = 0}}
		error = wt.wasmtime_func_call(wtctx, &func, &args[0], len(args), &results, 1, &trap)
		if error != nil || trap != nil {exit_with_error("error calling gcd export", error, trap)}
		fmt.printfln("results: %v", results.of.i32)
	} else {
		fmt.printfln("item.kind: %v", item.kind)
	}

	fmt.println("Done.")
}

exit_with_error :: proc(message: string, error: wt.wasmtime_error, trap: wt.wasm_trap) {
	fmt.eprintfln("error: %s", message)
	error_message: wt.wasm_byte_vec_t
	if error != nil {
		wt.wasmtime_error_message(error, &error_message)
		wt.wasmtime_error_delete(error)
	} else {
		wt.wasm_trap_message(trap, &error_message)
		wt.wasm_trap_delete(trap)
	}
	fmt.eprintln(wt.to_string(&error_message))
	wt.wasm_byte_vec_delete(&error_message)
	os.exit(1)
}
