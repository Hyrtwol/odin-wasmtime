package test_wasmtime

import wt ".."
import "core:fmt"
import "core:testing"

expectf :: testing.expectf

@(private)
expect_size :: proc(t: ^testing.T, $act: typeid, exp: int, loc := #caller_location) {
	expectf(t, size_of(act) == exp, "size_of(%v) should be %d was %d", typeid_of(act), exp, size_of(act), loc = loc)
}

@(private)
expect_value :: proc(t: ^testing.T, #any_int act: u32, #any_int exp: u32, loc := #caller_location) {
	expectf(t, act == exp, "0x%8X (should be: 0x%8X)", act, exp, loc = loc)
}

@(private)
expect_value_64 :: proc(t: ^testing.T, #any_int act: u64, #any_int exp: u64, loc := #caller_location) {
	expectf(t, act == exp, "0x%8X (should be: 0x%8X)", act, exp, loc = loc)
}

@(test)
size_up :: proc(t: ^testing.T) {
	testing.expect(t, size_of(wt.size_t) == size_of(uint))
}

main :: proc() {
	fmt.println("wasmtime")

	{
		engine := wt.wasm_engine_new()
		assert(engine != nil)
		defer wt.wasm_engine_delete(engine)

		store := wt.wasmtime_store_new(engine, nil, nil)
		assert(store != nil)
		defer wt.wasmtime_store_delete(store)

		wtctx := wt.wasmtime_store_context(store)
		assert(wtctx != nil)

		wasm: wt.wasm_byte_vec_t
		fmt.printfln("wasm=%v", wasm)
		{
			wt.wasm_byte_vec_new_empty(&wasm)
			fmt.printfln("wasm_byte_vec_new_empty=%v", wasm)
			wt.wasm_byte_vec_new_uninitialized(&wasm, 10)
			fmt.printfln("wasm_byte_vec_new_uninitialized=%v", wasm)
			defer wt.wasm_byte_vec_delete(&wasm)
		}
		fmt.printfln("wasm=%v", wasm)
		{
			wt.wasm_byte_vec_new(&wasm, 10, "Hello")
			fmt.printfln("wasm_byte_vec_new=%v", wasm)
			defer wt.wasm_byte_vec_delete(&wasm)
		}
		fmt.printfln("wasm=%v", wasm)
	}

	fmt.println("Done.")
}
