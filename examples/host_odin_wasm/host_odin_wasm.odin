#+vet
package main

import wt "../.."
import "core:fmt"
import "core:mem"
import "core:os"
import "base:runtime"

write_callback :: proc "c" (env: rawptr, caller: wt.wasmtime_caller, pargs: wt.wasmtime_val, nargs: wt.size_t, results: wt.wasmtime_val, nresults: wt.size_t) -> wt.wasm_trap {
	context = runtime.default_context()

	args := wt.get_args(pargs, nargs)

	if nargs == 3 && args[0].kind == .WASM_I32 && args[1].kind == .WASM_I32 && args[2].kind == .WASM_I32 {
		fd, ptr, len: i32 = args[0].of.i32, args[1].of.i32, args[2].of.i32

		wtctx := wt.wasmtime_caller_context(caller)
		assert(wtctx != nil)
		memory_buffer := wt.get_memory_from_caller(caller, wtctx, "memory")
		str := string(memory_buffer[ptr:][:len])

		switch fd {
		case wt.stdin: // todo
		case wt.stdout:
			fmt.print(str)
		case:
			// stderr
			fmt.eprint(str)
		}
	}

	return nil
}

imports :: proc(module: wt.wasmtime_module, linker: wt.wasmtime_linker) {
	importtype_vec: wt.wasm_importtype_vec_t
	wt.wasmtime_module_imports(module, &importtype_vec)
	imports := ([^]wt.wasm_importtype)(importtype_vec.data)[:importtype_vec.size]
	fmt.printfln("imports: %d", len(imports))
	for import_type in imports {
		m_name, f_name := wt.wasm_importtype_module(import_type), wt.wasm_importtype_name(import_type)
		extern_type := wt.wasm_importtype_type(import_type)
		extern_type_kind := wt.wasm_externtype_kind(extern_type)

		fmt.printfln("  %-20v %s::%s", extern_type_kind, wt.to_string(m_name), wt.to_string(f_name))

		#partial switch extern_type_kind {
		case .WASM_EXTERN_FUNC:
			extern_func_ty := wt.wasm_externtype_as_functype(extern_type)
			error := wt.wasmtime_linker_define_func(linker, m_name.data, m_name.size, f_name.data, f_name.size, extern_func_ty, write_callback)
			if error != nil {exit_with_error("failed to linker define func", error, nil)}
		}
	}
}

exports :: proc(module: wt.wasmtime_module) {
	exporttype_vec: wt.wasm_exporttype_vec_t
	wt.wasmtime_module_exports(module, &exporttype_vec)
	exports := ([^]wt.wasm_exporttype)(exporttype_vec.data)[:exporttype_vec.size]
	fmt.printfln("exports: %d", len(exports))
	for export_type in exports {
		f_name := wt.wasm_exporttype_name(export_type)
		extern_type := wt.wasm_exporttype_type(export_type)
		extern_type_kind := wt.wasm_externtype_kind(extern_type)
		fmt.printfln("  %-20v %s", extern_type_kind, wt.to_string(f_name))
		/*
		#partial switch extern_type_kind {
		case .WASM_EXTERN_MEMORY:
			extern_mem_ty := wt.wasm_externtype_as_memorytype(extern_type)
			fmt.printfln("extern_mem_ty: %v", extern_mem_ty)
		}
		*/
	}
}

main :: proc() {
	defer fmt.println("Done done.")

	engine := wt.wasm_engine_new()
	assert(engine != nil)
	defer wt.wasm_engine_delete(engine)

	store := wt.wasmtime_store_new(engine)
	assert(store != nil)
	defer wt.wasmtime_store_delete(store)

	// Set up our context
	wtctx := wt.wasmtime_store_context(store)

	// Create a linker with WASI functions defined
	linker := wt.wasmtime_linker_new(engine)
	defer wt.wasmtime_linker_delete(linker)

	error := wt.wasmtime_linker_define_wasi(linker)
	if error != nil {exit_with_error("failed to link wasi", error, nil)}

	wasm: wt.wasm_byte_vec_t

	gcd := #load("wasm/helloworld.wasm")
	file_size := len(gcd)
	if file_size == 0 {fmt.printf("> Error loading module!\n");os.exit(1)}
	wt.wasm_byte_vec_new_uninitialized(&wasm, uint(file_size))
	mem.copy(rawptr(wasm.data), &gcd[0], file_size)
	assert(wasm.size > 0)

	// Compile our modules
	module: wt.wasmtime_module = nil
	error = wt.wasmtime_module_new(engine, wasm.data, wasm.size, &module)
	if module == nil {exit_with_error("failed to compile module", error, nil)}
	defer wt.wasmtime_module_delete(module)

	wt.wasm_byte_vec_delete(&wasm)

	imports(module, linker)
	exports(module)

	// Instantiate wasi
	wasi_config := wt.wasi_config_new()
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

	// Run it.
	fmt.println("Run default")
	func: wt.wasmtime_func_t
	error = wt.wasmtime_linker_get_default(linker, wtctx, "", 0, &func)
	if error != nil {exit_with_error("failed to locate default export for module", error, nil)}
	trap: wt.wasm_trap = nil
	error = wt.wasmtime_func_call(wtctx, &func, nil, 0, nil, 0, &trap)
	if error != nil || trap != nil {exit_with_error("error calling default export", error, trap)}

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
