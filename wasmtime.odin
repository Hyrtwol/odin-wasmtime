// +vet
package wasmtime

when #config(WASMTIME_MIN, false) {
	foreign import wasmtimelib "sources/lib/wasmtime-min.dll.lib"
} else {
	foreign import wasmtimelib "sources/lib/wasmtime.dll.lib"
}

size_t :: uint
wasmtime_v128 :: u128le
wasm_name_t :: wasm_byte_vec_t
//wasm_name :: ^ wasm_name_t
wasm_message_t :: wasm_name_t
wasm_message :: ^wasm_message_t

wasm_func_callback_t :: #type proc "c" (args: wasm_val_vec, results: wasm_val_vec) -> wasm_trap
wasm_func_callback_with_env_t :: #type proc "c" (env: rawptr, args: wasm_val_vec, results: wasm_val_vec) -> wasm_trap
wasmtime_memory_get_callback_t :: #type proc "c" (env: rawptr, byte_size: ^size_t, maximum_byte_size: ^size_t) -> ^u8
wasmtime_memory_grow_callback_t :: #type proc "c" (env: rawptr, new_size: size_t) -> wasmtime_error
wasmtime_new_memory_callback_t :: #type proc "c" (env: rawptr, ty: wasm_memorytype, minimum: size_t, maximum: size_t, reserved_size_in_bytes: size_t, guard_size_in_bytes: size_t, memory_ret: ^wasmtime_linear_memory_t) -> wasmtime_error
wasmtime_func_callback_t :: #type proc "c" (env: rawptr, caller: wasmtime_caller, args: wasmtime_val, nargs: size_t, results: wasmtime_val, nresults: size_t) -> wasm_trap
wasmtime_func_unchecked_callback_t :: #type proc "c" (env: rawptr, caller: wasmtime_caller, args_and_results: wasmtime_val_raw, num_args_and_results: size_t) -> wasm_trap
wasmtime_func_async_continuation_callback_t :: #type proc "c" (env: rawptr) -> bool
wasmtime_func_async_callback_t :: #type proc "c" (env: rawptr, caller: wasmtime_caller, args: wasmtime_val, nargs: size_t, results: wasmtime_val, nresults: size_t, trap_ret: ^wasm_trap, continuation_ret: ^wasmtime_async_continuation_t)
wasmtime_stack_memory_get_callback_t :: #type proc "c" (env: rawptr, out_len: ^size_t) -> ^u8
wasmtime_new_stack_memory_callback_t :: #type proc "c" (env: rawptr, size: size_t, stack_ret: wasmtime_stack_memory) -> wasmtime_error

wasm_mutability_enum :: enum i32 {
	WASM_CONST,
	WASM_VAR,
}

wasm_valkind_enum :: enum u8 {
	WASM_I32,
	WASM_I64,
	WASM_F32,
	WASM_F64,
	WASM_ANYREF = 128,
	WASM_FUNCREF,
}

wasm_externkind_enum :: enum u8 {
	WASM_EXTERN_FUNC,
	WASM_EXTERN_GLOBAL,
	WASM_EXTERN_TABLE,
	WASM_EXTERN_MEMORY,
}

wasmtime_strategy_enum :: enum i32 {
	WASMTIME_STRATEGY_AUTO,
	WASMTIME_STRATEGY_CRANELIFT,
}

wasmtime_opt_level_enum :: enum i32 {
	WASMTIME_OPT_LEVEL_NONE,
	WASMTIME_OPT_LEVEL_SPEED,
	WASMTIME_OPT_LEVEL_SPEED_AND_SIZE,
}

wasmtime_profiling_strategy_enum :: enum i32 {
	WASMTIME_PROFILING_STRATEGY_NONE,
	WASMTIME_PROFILING_STRATEGY_JITDUMP,
	WASMTIME_PROFILING_STRATEGY_VTUNE,
	WASMTIME_PROFILING_STRATEGY_PERFMAP,
}

wasmtime_trap_code_enum :: enum i32 {
	WASMTIME_TRAP_CODE_STACK_OVERFLOW,
	WASMTIME_TRAP_CODE_MEMORY_OUT_OF_BOUNDS,
	WASMTIME_TRAP_CODE_HEAP_MISALIGNED,
	WASMTIME_TRAP_CODE_TABLE_OUT_OF_BOUNDS,
	WASMTIME_TRAP_CODE_INDIRECT_CALL_TO_NULL,
	WASMTIME_TRAP_CODE_BAD_SIGNATURE,
	WASMTIME_TRAP_CODE_INTEGER_OVERFLOW,
	WASMTIME_TRAP_CODE_INTEGER_DIVISION_BY_ZERO,
	WASMTIME_TRAP_CODE_BAD_CONVERSION_TO_INTEGER,
	WASMTIME_TRAP_CODE_UNREACHABLE_CODE_REACHED,
	WASMTIME_TRAP_CODE_INTERRUPT,
	WASMTIME_TRAP_CODE_OUT_OF_FUEL,
}

wasm_byte_vec_t :: struct {
	size: size_t,
	data: cstring,
}
wasm_byte_vec :: ^wasm_byte_vec_t

wasm_config :: distinct rawptr

wasm_engine :: distinct rawptr

wasm_store :: distinct rawptr

wasm_limits_t :: struct {
	min: u32,
	max: u32,
}
wasm_limits :: ^wasm_limits_t

wasm_valtype :: distinct rawptr

wasm_valtype_vec_t :: struct {
	size: size_t,
	data: ^wasm_valtype,
}
wasm_valtype_vec :: ^wasm_valtype_vec_t

wasm_functype :: distinct rawptr

wasm_functype_vec_t :: struct {
	size: size_t,
	data: ^wasm_functype,
}
wasm_functype_vec :: ^wasm_functype_vec_t

wasm_globaltype :: distinct rawptr

wasm_globaltype_vec_t :: struct {
	size: size_t,
	data: ^wasm_globaltype,
}
wasm_globaltype_vec :: ^wasm_globaltype_vec_t

wasm_tabletype :: distinct rawptr

wasm_tabletype_vec_t :: struct {
	size: size_t,
	data: ^wasm_tabletype,
}
wasm_tabletype_vec :: ^wasm_tabletype_vec_t

wasm_memorytype :: distinct rawptr

wasm_memorytype_vec_t :: struct {
	size: size_t,
	data: ^wasm_memorytype,
}
wasm_memorytype_vec :: ^wasm_memorytype_vec_t

wasm_externtype :: distinct rawptr

wasm_externtype_vec_t :: struct {
	size: size_t,
	data: ^wasm_externtype,
}
wasm_externtype_vec :: ^wasm_externtype_vec_t

wasm_importtype :: distinct rawptr

wasm_importtype_vec_t :: struct {
	size: size_t,
	data: ^wasm_importtype,
}
wasm_importtype_vec :: ^wasm_importtype_vec_t

wasm_exporttype :: distinct rawptr

wasm_exporttype_vec_t :: struct {
	size: size_t,
	data: ^wasm_exporttype,
}
wasm_exporttype_vec :: ^wasm_exporttype_vec_t

wasm_ref :: distinct rawptr

wasm_val_t :: struct {
	kind: wasm_valkind_enum,
	of:   struct #raw_union {
		i32: i32,
		i64: i64,
		f32: f32,
		f64: f64,
		ref: wasm_ref,
	},
}
wasm_val :: ^wasm_val_t

wasm_val_vec_t :: struct {
	size: size_t,
	data: wasm_val,
}
wasm_val_vec :: ^wasm_val_vec_t

wasm_frame :: distinct rawptr

wasm_frame_vec_t :: struct {
	size: size_t,
	data: ^wasm_frame,
}
wasm_frame_vec :: ^wasm_frame_vec_t

wasm_instance :: distinct rawptr

wasm_trap :: distinct rawptr

wasm_foreign :: distinct rawptr

wasm_module :: distinct rawptr

wasm_shared_module :: distinct rawptr

wasm_func :: distinct rawptr

wasm_global :: distinct rawptr

wasm_table :: distinct rawptr

wasm_memory :: distinct rawptr

wasm_extern :: distinct rawptr

wasm_extern_vec_t :: struct {
	size: size_t,
	data: ^wasm_extern,
}
wasm_extern_vec :: ^wasm_extern_vec_t

wasmtime_error :: distinct rawptr

wasmtime_linear_memory_t :: struct {
	env:         rawptr,
	get_memory:  wasmtime_memory_get_callback_t,
	grow_memory: wasmtime_memory_grow_callback_t,
	finalizer:   #type proc(unamed0: rawptr),
}
wasmtime_linear_memory :: ^wasmtime_linear_memory_t

wasmtime_memory_creator_t :: struct {
	env:        rawptr,
	new_memory: wasmtime_new_memory_callback_t,
	finalizer:  #type proc(unamed0: rawptr),
}
wasmtime_memory_creator :: ^wasmtime_memory_creator_t

wasmtime_module :: distinct rawptr

wasmtime_store :: distinct rawptr

wasmtime_context :: distinct rawptr

wasmtime_func_t :: struct {
	store_id: u64,
	index:    size_t,
}
wasmtime_func :: ^wasmtime_func_t

wasmtime_table_t :: struct {
	store_id: u64,
	index:    size_t,
}
wasmtime_table :: ^wasmtime_table_t

wasmtime_memory_t :: struct {
	store_id: u64,
	index:    size_t,
}
wasmtime_memory :: ^wasmtime_memory_t

wasmtime_global_t :: struct {
	store_id: u64,
	index:    size_t,
}
wasmtime_global :: ^wasmtime_global_t

wasmtime_extern_t :: struct {
	kind: wasm_externkind_enum, //u8,
	of:   wasmtime_extern_union_t,
}
wasmtime_extern :: ^wasmtime_extern_t

wasmtime_externref :: distinct rawptr

wasmtime_val_t :: struct {
	kind: wasm_valkind_enum, //u8,
	of:   wasmtime_valunion_t,
}
wasmtime_val :: ^wasmtime_val_t

wasmtime_caller :: distinct rawptr

wasmtime_instance_t :: struct {
	store_id: u64,
	index:    size_t,
}
wasmtime_instance :: ^wasmtime_instance_t

wasmtime_instance_pre :: distinct rawptr

wasmtime_linker :: distinct rawptr

wasmtime_guestprofiler :: distinct rawptr

wasmtime_guestprofiler_modules_t :: struct {
	name: ^wasm_name_t,
	mod:  wasmtime_module,
}
wasmtime_guestprofiler_modules :: ^wasmtime_guestprofiler_modules_t

wasmtime_async_continuation_t :: struct {
	callback:  wasmtime_func_async_continuation_callback_t,
	env:       rawptr,
	finalizer: #type proc(unamed0: rawptr),
}
wasmtime_async_continuation :: ^wasmtime_async_continuation_t

wasmtime_call_future :: distinct rawptr

wasmtime_stack_memory_t :: struct {
	env:              rawptr,
	get_stack_memory: wasmtime_stack_memory_get_callback_t,
	finalizer:        #type proc(unamed0: rawptr),
}
wasmtime_stack_memory :: ^wasmtime_stack_memory_t

wasmtime_stack_creator_t :: struct {
	env:       rawptr,
	new_stack: wasmtime_new_stack_memory_callback_t,
	finalizer: #type proc(unamed0: rawptr),
}
wasmtime_stack_creator :: ^wasmtime_stack_creator_t

wasmtime_extern_union_t :: struct #raw_union {
	func:   wasmtime_func_t,
	global: wasmtime_global_t,
	table:  wasmtime_table_t,
	memory: wasmtime_memory_t,
}

wasmtime_valunion_t :: struct #raw_union {
	i32:       i32,
	i64:       i64,
	f32:       f32,
	f64:       f64,
	funcref:   wasmtime_func_t,
	externref: wasmtime_externref,
	v128:      wasmtime_v128,
}

wasmtime_val_raw_t :: struct #raw_union {
	i32:       i32,
	i64:       i64,
	f32:       f32,
	f64:       f64,
	v128:      wasmtime_v128,
	funcref:   rawptr,
	externref: rawptr,
}
wasmtime_val_raw :: ^wasmtime_val_raw_t

@(default_calling_convention = "c")
foreign wasmtimelib {

	wasm_byte_vec_new_empty :: proc(out: wasm_byte_vec) ---

	wasm_byte_vec_new_uninitialized :: proc(out: wasm_byte_vec, size: size_t) ---

	wasm_byte_vec_new :: proc(out: wasm_byte_vec, size: size_t, value: cstring) ---

	wasm_byte_vec_copy :: proc(out: wasm_byte_vec, size: wasm_byte_vec) ---

	wasm_byte_vec_delete :: proc(vec: wasm_byte_vec) ---

	wasm_config_delete :: proc(config: wasm_config) ---

	wasm_config_new :: proc() -> wasm_config ---

	wasm_engine_delete :: proc(engine: wasm_engine) ---

	wasm_engine_new :: proc() -> wasm_engine ---

	wasm_engine_new_with_config :: proc(config: wasm_config) -> wasm_engine ---

	wasm_store_delete :: proc(store: wasm_store) ---

	wasm_store_new :: proc(engine: wasm_engine) -> wasm_store ---

	wasm_valtype_delete :: proc(valtype: wasm_valtype) ---

	wasm_valtype_vec_new_empty :: proc(out: wasm_valtype_vec) ---

	wasm_valtype_vec_new_uninitialized :: proc(out: wasm_valtype_vec, size: size_t) ---

	wasm_valtype_vec_new :: proc(out: wasm_valtype_vec, size: size_t, valtype: ^wasm_valtype) ---

	wasm_valtype_vec_copy :: proc(out: wasm_valtype_vec, valtype: wasm_valtype_vec) ---

	wasm_valtype_vec_delete :: proc(valtype: wasm_valtype_vec) ---

	wasm_valtype_copy :: proc(valtype: wasm_valtype) -> wasm_valtype ---

	wasm_valtype_new :: proc(valkind: wasm_valkind_enum) -> wasm_valtype ---

	wasm_valtype_kind :: proc(valtype: wasm_valtype) -> wasm_valkind_enum ---

	wasm_functype_delete :: proc(functype: wasm_functype) ---

	wasm_functype_vec_new_empty :: proc(out: wasm_functype_vec) ---

	wasm_functype_vec_new_uninitialized :: proc(out: wasm_functype_vec, size: size_t) ---

	wasm_functype_vec_new :: proc(out: wasm_functype_vec, size: size_t, functype: ^wasm_functype) ---

	wasm_functype_vec_copy :: proc(out: wasm_functype_vec, functype: wasm_functype_vec) ---

	wasm_functype_vec_delete :: proc(functype: wasm_functype_vec) ---

	wasm_functype_copy :: proc(functype: wasm_functype) -> wasm_functype ---

	wasm_functype_new :: proc(params: wasm_valtype_vec, results: wasm_valtype_vec) -> wasm_functype ---

	wasm_functype_params :: proc(functype: wasm_functype) -> wasm_valtype_vec ---

	wasm_functype_results :: proc(functype: wasm_functype) -> wasm_valtype_vec ---

	wasm_globaltype_delete :: proc(globaltype: wasm_globaltype) ---

	wasm_globaltype_vec_new_empty :: proc(out: wasm_globaltype_vec) ---

	wasm_globaltype_vec_new_uninitialized :: proc(out: wasm_globaltype_vec, size: size_t) ---

	wasm_globaltype_vec_new :: proc(out: wasm_globaltype_vec, size: size_t, globaltype: ^wasm_globaltype) ---

	wasm_globaltype_vec_copy :: proc(out: wasm_globaltype_vec, globaltype: wasm_globaltype_vec) ---

	wasm_globaltype_vec_delete :: proc(globaltype: wasm_globaltype_vec) ---

	wasm_globaltype_copy :: proc(globaltype: wasm_globaltype) -> wasm_globaltype ---

	wasm_globaltype_new :: proc(valtype: wasm_valtype, unamed1: u8) -> wasm_globaltype ---

	wasm_globaltype_content :: proc(globaltype: wasm_globaltype) -> wasm_valtype ---

	wasm_globaltype_mutability :: proc(globaltype: wasm_globaltype) -> u8 ---

	wasm_tabletype_delete :: proc(tabletype: wasm_tabletype) ---

	wasm_tabletype_vec_new_empty :: proc(out: wasm_tabletype_vec) ---

	wasm_tabletype_vec_new_uninitialized :: proc(out: wasm_tabletype_vec, size: size_t) ---

	wasm_tabletype_vec_new :: proc(out: wasm_tabletype_vec, size: size_t, tabletype: ^wasm_tabletype) ---

	wasm_tabletype_vec_copy :: proc(out: wasm_tabletype_vec, tabletype: wasm_tabletype_vec) ---

	wasm_tabletype_vec_delete :: proc(tabletype: wasm_tabletype_vec) ---

	wasm_tabletype_copy :: proc(tabletype: wasm_tabletype) -> wasm_tabletype ---

	wasm_tabletype_new :: proc(valtype: wasm_valtype, limits: wasm_limits) -> wasm_tabletype ---

	wasm_tabletype_element :: proc(tabletype: wasm_tabletype) -> wasm_valtype ---

	wasm_tabletype_limits :: proc(tabletype: wasm_tabletype) -> wasm_limits ---

	wasm_memorytype_delete :: proc(memorytype: wasm_memorytype) ---

	wasm_memorytype_vec_new_empty :: proc(out: wasm_memorytype_vec) ---

	wasm_memorytype_vec_new_uninitialized :: proc(out: wasm_memorytype_vec, size: size_t) ---

	wasm_memorytype_vec_new :: proc(out: wasm_memorytype_vec, size: size_t, memorytype: ^wasm_memorytype) ---

	wasm_memorytype_vec_copy :: proc(out: wasm_memorytype_vec, memorytype_vec: wasm_memorytype_vec) ---

	wasm_memorytype_vec_delete :: proc(memorytype_vec: wasm_memorytype_vec) ---

	wasm_memorytype_copy :: proc(memorytype: wasm_memorytype) -> wasm_memorytype ---

	wasm_memorytype_new :: proc(limits: wasm_limits) -> wasm_memorytype ---

	wasm_memorytype_limits :: proc(memorytype: wasm_memorytype) -> wasm_limits ---

	wasm_externtype_delete :: proc(externtype: wasm_externtype) ---

	wasm_externtype_vec_new_empty :: proc(out: wasm_externtype_vec) ---

	wasm_externtype_vec_new_uninitialized :: proc(out: wasm_externtype_vec, size: size_t) ---

	wasm_externtype_vec_new :: proc(out: wasm_externtype_vec, size: size_t, externtype: ^wasm_externtype) ---

	wasm_externtype_vec_copy :: proc(out: wasm_externtype_vec, externtype: wasm_externtype_vec) ---

	wasm_externtype_vec_delete :: proc(externtype: wasm_externtype_vec) ---

	wasm_externtype_copy :: proc(externtype: wasm_externtype) -> wasm_externtype ---

	wasm_externtype_kind :: proc(externtype: wasm_externtype) -> wasm_externkind_enum ---

	wasm_functype_as_externtype :: proc(functype: wasm_functype) -> wasm_externtype ---

	wasm_globaltype_as_externtype :: proc(globaltype: wasm_globaltype) -> wasm_externtype ---

	wasm_tabletype_as_externtype :: proc(tabletype: wasm_tabletype) -> wasm_externtype ---

	wasm_memorytype_as_externtype :: proc(memorytype: wasm_memorytype) -> wasm_externtype ---

	wasm_externtype_as_functype :: proc(externtype: wasm_externtype) -> wasm_functype ---

	wasm_externtype_as_globaltype :: proc(externtype: wasm_externtype) -> wasm_globaltype ---

	wasm_externtype_as_tabletype :: proc(externtype: wasm_externtype) -> wasm_tabletype ---

	wasm_externtype_as_memorytype :: proc(externtype: wasm_externtype) -> wasm_memorytype ---

	wasm_functype_as_externtype_const :: proc(functype: wasm_functype) -> wasm_externtype ---

	wasm_globaltype_as_externtype_const :: proc(globaltype: wasm_globaltype) -> wasm_externtype ---

	wasm_tabletype_as_externtype_const :: proc(tabletype: wasm_tabletype) -> wasm_externtype ---

	wasm_memorytype_as_externtype_const :: proc(memorytype: wasm_memorytype) -> wasm_externtype ---

	wasm_externtype_as_functype_const :: proc(externtype: wasm_externtype) -> wasm_functype ---

	wasm_externtype_as_globaltype_const :: proc(externtype: wasm_externtype) -> wasm_globaltype ---

	wasm_externtype_as_tabletype_const :: proc(externtype: wasm_externtype) -> wasm_tabletype ---

	wasm_externtype_as_memorytype_const :: proc(externtype: wasm_externtype) -> wasm_memorytype ---

	wasm_importtype_delete :: proc(importtype: wasm_importtype) ---

	wasm_importtype_vec_new_empty :: proc(out: wasm_importtype_vec) ---

	wasm_importtype_vec_new_uninitialized :: proc(out: wasm_importtype_vec, size: size_t) ---

	wasm_importtype_vec_new :: proc(out: wasm_importtype_vec, size: size_t, importtype: ^wasm_importtype) ---

	wasm_importtype_vec_copy :: proc(out: wasm_importtype_vec, importtype_vec: wasm_importtype_vec) ---

	wasm_importtype_vec_delete :: proc(importtype_vec: wasm_importtype_vec) ---

	wasm_importtype_copy :: proc(importtype: wasm_importtype) -> wasm_importtype ---

	wasm_importtype_new :: proc(module: ^wasm_name_t, name: ^wasm_name_t, externtype: wasm_externtype) -> wasm_importtype ---

	wasm_importtype_module :: proc(importtype: wasm_importtype) -> ^wasm_name_t ---

	wasm_importtype_name :: proc(importtype: wasm_importtype) -> ^wasm_name_t ---

	wasm_importtype_type :: proc(importtype: wasm_importtype) -> wasm_externtype ---

	wasm_exporttype_delete :: proc(exporttype: wasm_exporttype) ---

	wasm_exporttype_vec_new_empty :: proc(out: wasm_exporttype_vec) ---

	wasm_exporttype_vec_new_uninitialized :: proc(out: wasm_exporttype_vec, size: size_t) ---

	wasm_exporttype_vec_new :: proc(out: wasm_exporttype_vec, size: size_t, exporttype: ^wasm_exporttype) ---

	wasm_exporttype_vec_copy :: proc(out: wasm_exporttype_vec, exporttype_vec: wasm_exporttype_vec) ---

	wasm_exporttype_vec_delete :: proc(exporttype_vec: wasm_exporttype_vec) ---

	wasm_exporttype_copy :: proc(exporttype: wasm_exporttype) -> wasm_exporttype ---

	wasm_exporttype_new :: proc(unamed0: ^wasm_name_t, externtype: wasm_externtype) -> wasm_exporttype ---

	wasm_exporttype_name :: proc(exporttype: wasm_exporttype) -> ^wasm_name_t ---

	wasm_exporttype_type :: proc(exporttype: wasm_exporttype) -> wasm_externtype ---

	wasm_val_delete :: proc(v: wasm_val) ---

	wasm_val_copy :: proc(out: wasm_val, val: wasm_val) ---

	wasm_val_vec_new_empty :: proc(out: wasm_val_vec) ---

	wasm_val_vec_new_uninitialized :: proc(out: wasm_val_vec, size: size_t) ---

	wasm_val_vec_new :: proc(out: wasm_val_vec, size: size_t, val: wasm_val) ---

	wasm_val_vec_copy :: proc(out: wasm_val_vec, wasm_val_vec: wasm_val_vec) ---

	wasm_val_vec_delete :: proc(wasm_val_vec: wasm_val_vec) ---

	wasm_ref_delete :: proc(ref: wasm_ref) ---

	wasm_ref_copy :: proc(ref: wasm_ref) -> wasm_ref ---

	wasm_ref_same :: proc(ref: wasm_ref, other: wasm_ref) -> bool ---

	wasm_ref_get_host_info :: proc(ref: wasm_ref) -> rawptr ---

	wasm_ref_set_host_info :: proc(ref: wasm_ref, info: rawptr) ---

	wasm_ref_set_host_info_with_finalizer :: proc(ref: wasm_ref, unamed1: rawptr, unamed2: #type proc(unamed0: rawptr)) ---

	wasm_frame_delete :: proc(frame: wasm_frame) ---

	wasm_frame_vec_new_empty :: proc(out: wasm_frame_vec) ---

	wasm_frame_vec_new_uninitialized :: proc(out: wasm_frame_vec, size: size_t) ---

	wasm_frame_vec_new :: proc(out: wasm_frame_vec, size: size_t, frame: ^wasm_frame) ---

	wasm_frame_vec_copy :: proc(out: wasm_frame_vec, unamed0: wasm_frame_vec) ---

	wasm_frame_vec_delete :: proc(unamed0: wasm_frame_vec) ---

	wasm_frame_copy :: proc(frame: wasm_frame) -> wasm_frame ---

	wasm_frame_instance :: proc(frame: wasm_frame) -> wasm_instance ---

	wasm_frame_func_index :: proc(frame: wasm_frame) -> u32 ---

	wasm_frame_func_offset :: proc(frame: wasm_frame) -> size_t ---

	wasm_frame_module_offset :: proc(frame: wasm_frame) -> size_t ---

	wasm_trap_delete :: proc(trap: wasm_trap) ---

	wasm_trap_copy :: proc(trap: wasm_trap) -> wasm_trap ---

	wasm_trap_same :: proc(trap: wasm_trap, other: wasm_trap) -> bool ---

	wasm_trap_get_host_info :: proc(trap: wasm_trap) -> rawptr ---

	wasm_trap_set_host_info :: proc(trap: wasm_trap, info: rawptr) ---

	wasm_trap_set_host_info_with_finalizer :: proc(trap: wasm_trap, info: rawptr, unamed2: #type proc(unamed0: rawptr)) ---

	wasm_trap_as_ref :: proc(trap: wasm_trap) -> wasm_ref ---

	wasm_ref_as_trap :: proc(ref: wasm_ref) -> wasm_trap ---

	wasm_trap_as_ref_const :: proc(trap: wasm_trap) -> wasm_ref ---

	wasm_ref_as_trap_const :: proc(ref: wasm_ref) -> wasm_trap ---

	wasm_trap_new :: proc(store: wasm_store, unamed0: wasm_message) -> wasm_trap ---

	wasm_trap_message :: proc(trap: wasm_trap, out: wasm_message) ---

	wasm_trap_origin :: proc(trap: wasm_trap) -> wasm_frame ---

	wasm_trap_trace :: proc(trap: wasm_trap, out: wasm_frame_vec) ---

	wasm_foreign_delete :: proc(unamed0: wasm_foreign) ---

	wasm_foreign_copy :: proc(unamed0: wasm_foreign) -> wasm_foreign ---

	wasm_foreign_same :: proc(unamed0: wasm_foreign, unamed1: wasm_foreign) -> bool ---

	wasm_foreign_get_host_info :: proc(unamed0: wasm_foreign) -> rawptr ---

	wasm_foreign_set_host_info :: proc(unamed0: wasm_foreign, unamed1: rawptr) ---

	wasm_foreign_set_host_info_with_finalizer :: proc(unamed0: wasm_foreign, unamed1: rawptr, unamed2: #type proc(unamed0: rawptr)) ---

	wasm_foreign_as_ref :: proc(unamed0: wasm_foreign) -> wasm_ref ---

	wasm_ref_as_foreign :: proc(ref: wasm_ref) -> wasm_foreign ---

	wasm_foreign_as_ref_const :: proc(unamed0: wasm_foreign) -> wasm_ref ---

	wasm_ref_as_foreign_const :: proc(ref: wasm_ref) -> wasm_foreign ---

	wasm_foreign_new :: proc(store: wasm_store) -> wasm_foreign ---

	wasm_module_delete :: proc(unamed0: wasm_module) ---

	wasm_module_copy :: proc(unamed0: wasm_module) -> wasm_module ---

	wasm_module_same :: proc(unamed0: wasm_module, unamed1: wasm_module) -> bool ---

	wasm_module_get_host_info :: proc(unamed0: wasm_module) -> rawptr ---

	wasm_module_set_host_info :: proc(unamed0: wasm_module, unamed1: rawptr) ---

	wasm_module_set_host_info_with_finalizer :: proc(unamed0: wasm_module, unamed1: rawptr, unamed2: #type proc(unamed0: rawptr)) ---

	wasm_module_as_ref :: proc(unamed0: wasm_module) -> wasm_ref ---

	wasm_ref_as_module :: proc(ref: wasm_ref) -> wasm_module ---

	wasm_module_as_ref_const :: proc(unamed0: wasm_module) -> wasm_ref ---

	wasm_ref_as_module_const :: proc(ref: wasm_ref) -> wasm_module ---

	wasm_shared_module_delete :: proc(unamed0: wasm_shared_module) ---

	wasm_module_share :: proc(unamed0: wasm_module) -> wasm_shared_module ---

	wasm_module_obtain :: proc(store: wasm_store, unamed1: wasm_shared_module) -> wasm_module ---

	wasm_module_new :: proc(store: wasm_store, binary: wasm_byte_vec) -> wasm_module ---

	wasm_module_validate :: proc(store: wasm_store, binary: wasm_byte_vec) -> bool ---

	wasm_module_imports :: proc(unamed0: wasm_module, out: wasm_importtype_vec) ---

	wasm_module_exports :: proc(unamed0: wasm_module, out: wasm_exporttype_vec) ---

	wasm_module_serialize :: proc(unamed0: wasm_module, out: wasm_byte_vec) ---

	wasm_module_deserialize :: proc(store: wasm_store, unamed1: wasm_byte_vec) -> wasm_module ---

	wasm_func_delete :: proc(unamed0: wasm_func) ---

	wasm_func_copy :: proc(unamed0: wasm_func) -> wasm_func ---

	wasm_func_same :: proc(unamed0: wasm_func, unamed1: wasm_func) -> bool ---

	wasm_func_get_host_info :: proc(unamed0: wasm_func) -> rawptr ---

	wasm_func_set_host_info :: proc(unamed0: wasm_func, unamed1: rawptr) ---

	wasm_func_set_host_info_with_finalizer :: proc(unamed0: wasm_func, unamed1: rawptr, unamed2: #type proc(unamed0: rawptr)) ---

	wasm_func_as_ref :: proc(unamed0: wasm_func) -> wasm_ref ---

	wasm_ref_as_func :: proc(ref: wasm_ref) -> wasm_func ---

	wasm_func_as_ref_const :: proc(unamed0: wasm_func) -> wasm_ref ---

	wasm_ref_as_func_const :: proc(ref: wasm_ref) -> wasm_func ---

	wasm_func_new :: proc(store: wasm_store, unamed1: wasm_functype, unamed2: wasm_func_callback_t) -> wasm_func ---

	wasm_func_new_with_env :: proc(store: wasm_store, type: wasm_functype, unamed1: wasm_func_callback_with_env_t, env: rawptr, unamed2: #type proc(unamed0: rawptr)) -> wasm_func ---

	wasm_func_type :: proc(unamed0: wasm_func) -> wasm_functype ---

	wasm_func_param_arity :: proc(unamed0: wasm_func) -> size_t ---

	wasm_func_result_arity :: proc(unamed0: wasm_func) -> size_t ---

	wasm_func_call :: proc(unamed0: wasm_func, args: wasm_val_vec, results: wasm_val_vec) -> wasm_trap ---

	wasm_global_delete :: proc(unamed0: wasm_global) ---

	wasm_global_copy :: proc(unamed0: wasm_global) -> wasm_global ---

	wasm_global_same :: proc(unamed0: wasm_global, unamed1: wasm_global) -> bool ---

	wasm_global_get_host_info :: proc(unamed0: wasm_global) -> rawptr ---

	wasm_global_set_host_info :: proc(unamed0: wasm_global, unamed1: rawptr) ---

	wasm_global_set_host_info_with_finalizer :: proc(unamed0: wasm_global, unamed1: rawptr, unamed2: #type proc(unamed0: rawptr)) ---

	wasm_global_as_ref :: proc(unamed0: wasm_global) -> wasm_ref ---

	wasm_ref_as_global :: proc(ref: wasm_ref) -> wasm_global ---

	wasm_global_as_ref_const :: proc(unamed0: wasm_global) -> wasm_ref ---

	wasm_ref_as_global_const :: proc(ref: wasm_ref) -> wasm_global ---

	wasm_global_new :: proc(store: wasm_store, unamed1: wasm_globaltype, unamed2: wasm_val) -> wasm_global ---

	wasm_global_type :: proc(unamed0: wasm_global) -> wasm_globaltype ---

	wasm_global_get :: proc(unamed0: wasm_global, out: wasm_val) ---

	wasm_global_set :: proc(unamed0: wasm_global, unamed1: wasm_val) ---

	wasm_table_delete :: proc(unamed0: wasm_table) ---

	wasm_table_copy :: proc(unamed0: wasm_table) -> wasm_table ---

	wasm_table_same :: proc(unamed0: wasm_table, unamed1: wasm_table) -> bool ---

	wasm_table_get_host_info :: proc(unamed0: wasm_table) -> rawptr ---

	wasm_table_set_host_info :: proc(unamed0: wasm_table, unamed1: rawptr) ---

	wasm_table_set_host_info_with_finalizer :: proc(unamed0: wasm_table, unamed1: rawptr, unamed2: #type proc(unamed0: rawptr)) ---

	wasm_table_as_ref :: proc(unamed0: wasm_table) -> wasm_ref ---

	wasm_ref_as_table :: proc(ref: wasm_ref) -> wasm_table ---

	wasm_table_as_ref_const :: proc(unamed0: wasm_table) -> wasm_ref ---

	wasm_ref_as_table_const :: proc(ref: wasm_ref) -> wasm_table ---

	wasm_table_new :: proc(store: wasm_store, unamed1: wasm_tabletype, init: wasm_ref) -> wasm_table ---

	wasm_table_type :: proc(unamed0: wasm_table) -> wasm_tabletype ---

	wasm_table_get :: proc(unamed0: wasm_table, index: u32) -> wasm_ref ---

	wasm_table_set :: proc(unamed0: wasm_table, index: u32, unamed1: wasm_ref) -> bool ---

	wasm_table_size :: proc(unamed0: wasm_table) -> u32 ---

	wasm_table_grow :: proc(unamed0: wasm_table, delta: u32, init: wasm_ref) -> bool ---

	wasm_memory_delete :: proc(memory: wasm_memory) ---

	wasm_memory_copy :: proc(memory: wasm_memory) -> wasm_memory ---

	wasm_memory_same :: proc(memory: wasm_memory, unamed1: wasm_memory) -> bool ---

	wasm_memory_get_host_info :: proc(memory: wasm_memory) -> rawptr ---

	wasm_memory_set_host_info :: proc(memory: wasm_memory, unamed1: rawptr) ---

	wasm_memory_set_host_info_with_finalizer :: proc(memory: wasm_memory, unamed1: rawptr, unamed2: #type proc(unamed0: rawptr)) ---

	wasm_memory_as_ref :: proc(memory: wasm_memory) -> wasm_ref ---

	wasm_ref_as_memory :: proc(ref: wasm_ref) -> wasm_memory ---

	wasm_memory_as_ref_const :: proc(memory: wasm_memory) -> wasm_ref ---

	wasm_ref_as_memory_const :: proc(ref: wasm_ref) -> wasm_memory ---

	wasm_memory_new :: proc(store: wasm_store, unamed1: wasm_memorytype) -> wasm_memory ---

	wasm_memory_type :: proc(memory: wasm_memory) -> wasm_memorytype ---

	wasm_memory_data :: proc(memory: wasm_memory) -> cstring ---

	wasm_memory_data_size :: proc(memory: wasm_memory) -> size_t ---

	wasm_memory_size :: proc(memory: wasm_memory) -> u32 ---

	wasm_memory_grow :: proc(memory: wasm_memory, delta: u32) -> bool ---

	wasm_extern_delete :: proc(extern: wasm_extern) ---

	wasm_extern_copy :: proc(extern: wasm_extern) -> wasm_extern ---

	wasm_extern_same :: proc(extern: wasm_extern, unamed1: wasm_extern) -> bool ---

	wasm_extern_get_host_info :: proc(extern: wasm_extern) -> rawptr ---

	wasm_extern_set_host_info :: proc(extern: wasm_extern, unamed1: rawptr) ---

	wasm_extern_set_host_info_with_finalizer :: proc(extern: wasm_extern, unamed1: rawptr, unamed2: #type proc(unamed0: rawptr)) ---

	wasm_extern_as_ref :: proc(extern: wasm_extern) -> wasm_ref ---

	wasm_ref_as_extern :: proc(ref: wasm_ref) -> wasm_extern ---

	wasm_extern_as_ref_const :: proc(extern: wasm_extern) -> wasm_ref ---

	wasm_ref_as_extern_const :: proc(ref: wasm_ref) -> wasm_extern ---

	wasm_extern_vec_new_empty :: proc(out: wasm_extern_vec) ---

	wasm_extern_vec_new_uninitialized :: proc(out: wasm_extern_vec, size: size_t) ---

	wasm_extern_vec_new :: proc(out: wasm_extern_vec, size: size_t, unamed1: ^wasm_extern) ---

	wasm_extern_vec_copy :: proc(out: wasm_extern_vec, extern: wasm_extern_vec) ---

	wasm_extern_vec_delete :: proc(extern: wasm_extern_vec) ---

	wasm_extern_kind :: proc(extern: wasm_extern) -> u8 ---

	wasm_extern_type :: proc(extern: wasm_extern) -> wasm_externtype ---

	wasm_func_as_extern :: proc(unamed0: wasm_func) -> wasm_extern ---

	wasm_global_as_extern :: proc(unamed0: wasm_global) -> wasm_extern ---

	wasm_table_as_extern :: proc(unamed0: wasm_table) -> wasm_extern ---

	wasm_memory_as_extern :: proc(memory: wasm_memory) -> wasm_extern ---

	wasm_extern_as_func :: proc(extern: wasm_extern) -> wasm_func ---

	wasm_extern_as_global :: proc(extern: wasm_extern) -> wasm_global ---

	wasm_extern_as_table :: proc(extern: wasm_extern) -> wasm_table ---

	wasm_extern_as_memory :: proc(extern: wasm_extern) -> wasm_memory ---

	wasm_func_as_extern_const :: proc(unamed0: wasm_func) -> wasm_extern ---

	wasm_global_as_extern_const :: proc(unamed0: wasm_global) -> wasm_extern ---

	wasm_table_as_extern_const :: proc(unamed0: wasm_table) -> wasm_extern ---

	wasm_memory_as_extern_const :: proc(memory: wasm_memory) -> wasm_extern ---

	wasm_extern_as_func_const :: proc(extern: wasm_extern) -> wasm_func ---

	wasm_extern_as_global_const :: proc(extern: wasm_extern) -> wasm_global ---

	wasm_extern_as_table_const :: proc(extern: wasm_extern) -> wasm_table ---

	wasm_extern_as_memory_const :: proc(extern: wasm_extern) -> wasm_memory ---

	wasm_instance_delete :: proc(instance: wasm_instance) ---

	wasm_instance_copy :: proc(instance: wasm_instance) -> wasm_instance ---

	wasm_instance_same :: proc(instance: wasm_instance, unamed1: wasm_instance) -> bool ---

	wasm_instance_get_host_info :: proc(instance: wasm_instance) -> rawptr ---

	wasm_instance_set_host_info :: proc(instance: wasm_instance, unamed1: rawptr) ---

	wasm_instance_set_host_info_with_finalizer :: proc(instance: wasm_instance, unamed1: rawptr, unamed2: #type proc(unamed0: rawptr)) ---

	wasm_instance_as_ref :: proc(instance: wasm_instance) -> wasm_ref ---

	wasm_ref_as_instance :: proc(ref: wasm_ref) -> wasm_instance ---

	wasm_instance_as_ref_const :: proc(instance: wasm_instance) -> wasm_ref ---

	wasm_ref_as_instance_const :: proc(ref: wasm_ref) -> wasm_instance ---

	wasm_instance_new :: proc(store: wasm_store, unamed1: wasm_module, imports: wasm_extern_vec, unamed2: ^wasm_trap) -> wasm_instance ---

	wasm_instance_exports :: proc(instance: wasm_instance, out: wasm_extern_vec) ---

	wasmtime_error_new :: proc(unamed0: cstring) -> wasmtime_error ---

	wasmtime_error_delete :: proc(error: wasmtime_error) ---

	wasmtime_error_message :: proc(error: wasmtime_error, message: ^wasm_name_t) ---

	wasmtime_error_exit_status :: proc(error: wasmtime_error, status: ^i32) -> bool ---

	wasmtime_error_wasm_trace :: proc(error: wasmtime_error, out: wasm_frame_vec) ---

	wasmtime_config_debug_info_set :: proc(config: wasm_config, unamed1: bool) ---

	wasmtime_config_consume_fuel_set :: proc(config: wasm_config, unamed1: bool) ---

	wasmtime_config_epoch_interruption_set :: proc(config: wasm_config, unamed1: bool) ---

	wasmtime_config_max_wasm_stack_set :: proc(config: wasm_config, unamed1: size_t) ---

	wasmtime_config_wasm_threads_set :: proc(config: wasm_config, unamed1: bool) ---

	wasmtime_config_wasm_tail_call_set :: proc(config: wasm_config, unamed1: bool) ---

	wasmtime_config_wasm_reference_types_set :: proc(config: wasm_config, unamed1: bool) ---

	wasmtime_config_wasm_simd_set :: proc(config: wasm_config, unamed1: bool) ---

	wasmtime_config_wasm_relaxed_simd_set :: proc(config: wasm_config, unamed1: bool) ---

	wasmtime_config_wasm_relaxed_simd_deterministic_set :: proc(config: wasm_config, unamed1: bool) ---

	wasmtime_config_wasm_bulk_memory_set :: proc(config: wasm_config, unamed1: bool) ---

	wasmtime_config_wasm_multi_value_set :: proc(config: wasm_config, unamed1: bool) ---

	wasmtime_config_wasm_multi_memory_set :: proc(config: wasm_config, unamed1: bool) ---

	wasmtime_config_wasm_memory64_set :: proc(config: wasm_config, unamed1: bool) ---

	wasmtime_config_strategy_set :: proc(config: wasm_config, unamed1: u8) ---

	wasmtime_config_parallel_compilation_set :: proc(config: wasm_config, unamed1: bool) ---

	wasmtime_config_cranelift_debug_verifier_set :: proc(config: wasm_config, unamed1: bool) ---

	wasmtime_config_cranelift_nan_canonicalization_set :: proc(config: wasm_config, unamed1: bool) ---

	wasmtime_config_cranelift_opt_level_set :: proc(config: wasm_config, unamed1: u8) ---

	wasmtime_config_profiler_set :: proc(config: wasm_config, unamed1: u8) ---

	wasmtime_config_static_memory_forced_set :: proc(config: wasm_config, unamed1: bool) ---

	wasmtime_config_static_memory_maximum_size_set :: proc(config: wasm_config, maximum_size: u64) ---

	wasmtime_config_static_memory_guard_size_set :: proc(config: wasm_config, guard_size: u64) ---

	wasmtime_config_dynamic_memory_guard_size_set :: proc(config: wasm_config, guard_siz: u64) ---

	wasmtime_config_dynamic_memory_reserved_for_growth_set :: proc(config: wasm_config, reserved_for_growth: u64) ---

	wasmtime_config_native_unwind_info_set :: proc(config: wasm_config, unwind_info: bool) ---

	wasmtime_config_cache_config_load :: proc(config: wasm_config, unamed1: cstring) -> wasmtime_error ---

	wasmtime_config_target_set :: proc(config: wasm_config, target: cstring) -> wasmtime_error ---

	wasmtime_config_cranelift_flag_enable :: proc(config: wasm_config, value: cstring) ---

	wasmtime_config_cranelift_flag_set :: proc(config: wasm_config, key: cstring, value: cstring) ---

	wasmtime_config_macos_use_mach_ports_set :: proc(config: wasm_config, ports: bool) ---

	wasmtime_config_host_memory_creator_set :: proc(config: wasm_config, creator: wasmtime_memory_creator) ---

	wasmtime_config_memory_init_cow_set :: proc(config: wasm_config, memory_init_cow: bool) ---

	wasmtime_engine_increment_epoch :: proc(engine: wasm_engine) ---

	wasmtime_module_new :: proc(engine: wasm_engine, wasm: cstring, wasm_len: size_t, ret: ^wasmtime_module) -> wasmtime_error ---

	wasmtime_module_delete :: proc(m: wasmtime_module) ---

	wasmtime_module_clone :: proc(m: wasmtime_module) -> wasmtime_module ---

	wasmtime_module_imports :: proc(module: wasmtime_module, out: wasm_importtype_vec) ---

	wasmtime_module_exports :: proc(module: wasmtime_module, out: wasm_exporttype_vec) ---

	wasmtime_module_validate :: proc(engine: wasm_engine, wasm: cstring, wasm_len: size_t) -> wasmtime_error ---

	wasmtime_module_serialize :: proc(module: wasmtime_module, ret: wasm_byte_vec) -> wasmtime_error ---

	wasmtime_module_deserialize :: proc(engine: wasm_engine, bytes: ^u8, bytes_len: size_t, ret: ^wasmtime_module) -> wasmtime_error ---

	wasmtime_module_deserialize_file :: proc(engine: wasm_engine, path: cstring, ret: ^wasmtime_module) -> wasmtime_error ---

	wasmtime_module_image_range :: proc(module: wasmtime_module, start: ^rawptr, end: ^rawptr) ---

	wasmtime_store_new :: proc(engine: wasm_engine, data: rawptr = nil, unamed0: #type proc(unamed0: rawptr) = nil) -> wasmtime_store ---

	wasmtime_store_context :: proc(store: wasmtime_store) -> wasmtime_context ---

	wasmtime_store_limiter :: proc(store: wasmtime_store, memory_size: i64, table_elements: i64, instances: i64, tables: i64, memories: i64) ---

	wasmtime_store_delete :: proc(store: wasmtime_store) ---

	wasmtime_context_get_data :: proc(_context: wasmtime_context) -> rawptr ---

	wasmtime_context_set_data :: proc(_context: wasmtime_context, data: rawptr) ---

	wasmtime_context_gc :: proc(_context: wasmtime_context) ---

	wasmtime_context_set_fuel :: proc(store: wasmtime_context, fuel: u64) -> wasmtime_error ---

	wasmtime_context_get_fuel :: proc(_context: wasmtime_context, fuel: ^u64) -> wasmtime_error ---

	wasmtime_context_set_epoch_deadline :: proc(_context: wasmtime_context, ticks_beyond_current: u64) ---

	wasmtime_store_epoch_deadline_callback :: proc(store: wasmtime_store, unamed0: #type proc(_context: wasmtime_context, data: rawptr, epoch_deadline_delta: ^u64, update_kind: ^u8) -> wasmtime_error, data: rawptr, unamed1: #type proc(unamed0: rawptr)) ---

	wasmtime_extern_delete :: proc(val: wasmtime_extern) ---

	wasmtime_extern_type :: proc(_context: wasmtime_context, val: wasmtime_extern) -> wasm_externtype ---

	wasmtime_externref_new :: proc(data: rawptr, unamed0: #type proc(unamed0: rawptr)) -> wasmtime_externref ---

	wasmtime_externref_data :: proc(data: wasmtime_externref) -> rawptr ---

	wasmtime_externref_clone :: proc(ref: wasmtime_externref) -> wasmtime_externref ---

	wasmtime_externref_delete :: proc(ref: wasmtime_externref) ---

	wasmtime_externref_from_raw :: proc(_context: wasmtime_context, raw: rawptr) -> wasmtime_externref ---

	wasmtime_externref_to_raw :: proc(_context: wasmtime_context, ref: wasmtime_externref) -> rawptr ---

	wasmtime_val_delete :: proc(val: wasmtime_val) ---

	wasmtime_val_copy :: proc(dst: wasmtime_val, src: wasmtime_val) ---

	wasmtime_func_new :: proc(store: wasmtime_context, type: wasm_functype, callback: wasmtime_func_callback_t, env: rawptr, unamed0: #type proc(unamed0: rawptr), ret: wasmtime_func) ---

	wasmtime_func_new_unchecked :: proc(store: wasmtime_context, type: wasm_functype, callback: wasmtime_func_unchecked_callback_t, env: rawptr, unamed0: #type proc(unamed0: rawptr), ret: wasmtime_func) ---

	wasmtime_func_type :: proc(store: wasmtime_context, func: wasmtime_func) -> wasm_functype ---

	wasmtime_func_call :: proc(store: wasmtime_context, func: wasmtime_func, args: wasmtime_val, nargs: size_t, results: wasmtime_val, nresults: size_t, trap: ^wasm_trap) -> wasmtime_error ---

	wasmtime_func_call_unchecked :: proc(store: wasmtime_context, func: wasmtime_func, args_and_results: wasmtime_val_raw, args_and_results_len: size_t, trap: ^wasm_trap) -> wasmtime_error ---

	wasmtime_caller_export_get :: proc(caller: wasmtime_caller, name: cstring, name_len: size_t, item: wasmtime_extern) -> bool ---

	wasmtime_caller_context :: proc(caller: wasmtime_caller) -> wasmtime_context ---

	wasmtime_func_from_raw :: proc(_context: wasmtime_context, raw: rawptr, ret: wasmtime_func) ---

	wasmtime_func_to_raw :: proc(_context: wasmtime_context, func: wasmtime_func) -> rawptr ---

	wasmtime_global_new :: proc(store: wasmtime_context, type: wasm_globaltype, val: wasmtime_val, ret: wasmtime_global) -> wasmtime_error ---

	wasmtime_global_type :: proc(store: wasmtime_context, global: wasmtime_global) -> wasm_globaltype ---

	wasmtime_global_get :: proc(store: wasmtime_context, global: wasmtime_global, out: wasmtime_val) ---

	wasmtime_global_set :: proc(store: wasmtime_context, global: wasmtime_global, val: wasmtime_val) -> wasmtime_error ---

	wasmtime_instance_new :: proc(store: wasmtime_context, module: wasmtime_module, imports: wasmtime_extern, nimports: size_t, instance: wasmtime_instance, trap: ^wasm_trap) -> wasmtime_error ---

	wasmtime_instance_export_get :: proc(store: wasmtime_context, instance: wasmtime_instance, name: cstring, name_len: size_t, item: wasmtime_extern) -> bool ---

	wasmtime_instance_export_nth :: proc(store: wasmtime_context, instance: wasmtime_instance, index: size_t, name: ^cstring, name_len: ^size_t, item: wasmtime_extern) -> bool ---

	wasmtime_instance_pre_delete :: proc(instance_pre: wasmtime_instance_pre) ---

	wasmtime_instance_pre_instantiate :: proc(instance_pre: wasmtime_instance_pre, store: wasmtime_store, instance: wasmtime_instance, trap_ptr: ^wasm_trap) -> wasmtime_error ---

	wasmtime_instance_pre_module :: proc(instance_pre: wasmtime_instance_pre) -> wasmtime_module ---

	wasmtime_linker_new :: proc(engine: wasm_engine) -> wasmtime_linker ---

	wasmtime_linker_delete :: proc(linker: wasmtime_linker) ---

	wasmtime_linker_allow_shadowing :: proc(linker: wasmtime_linker, allow_shadowing: bool) ---

	wasmtime_linker_define :: proc(linker: wasmtime_linker, store: wasmtime_context, module: cstring, module_len: size_t, name: cstring, name_len: size_t, item: wasmtime_extern) -> wasmtime_error ---

	wasmtime_linker_define_func :: proc(linker: wasmtime_linker, module: cstring, module_len: size_t, name: cstring, name_len: size_t, ty: wasm_functype, cb: wasmtime_func_callback_t, data: rawptr = nil, unamed0: #type proc(unamed0: rawptr) = nil) -> wasmtime_error ---

	wasmtime_linker_define_func_unchecked :: proc(linker: wasmtime_linker, module: cstring, module_len: size_t, name: cstring, name_len: size_t, ty: wasm_functype, cb: wasmtime_func_unchecked_callback_t, data: rawptr, unamed0: #type proc(unamed0: rawptr)) -> wasmtime_error ---

	wasmtime_linker_define_instance :: proc(linker: wasmtime_linker, store: wasmtime_context, name: cstring, name_len: size_t, instance: wasmtime_instance) -> wasmtime_error ---

	wasmtime_linker_instantiate :: proc(linker: wasmtime_linker, store: wasmtime_context, module: wasmtime_module, instance: wasmtime_instance, trap: ^wasm_trap) -> wasmtime_error ---

	wasmtime_linker_module :: proc(linker: wasmtime_linker, store: wasmtime_context, name: cstring, name_len: size_t, module: wasmtime_module) -> wasmtime_error ---

	wasmtime_linker_get_default :: proc(linker: wasmtime_linker, store: wasmtime_context, name: cstring, name_len: size_t, func: wasmtime_func) -> wasmtime_error ---

	wasmtime_linker_get :: proc(linker: wasmtime_linker, store: wasmtime_context, module: cstring, module_len: size_t, name: cstring, name_len: size_t, item: wasmtime_extern) -> bool ---

	wasmtime_linker_instantiate_pre :: proc(linker: wasmtime_linker, module: wasmtime_module, instance_pre: ^wasmtime_instance_pre) -> wasmtime_error ---

	wasmtime_memorytype_new :: proc(min: u64, max_present: bool, max: u64, is_64: bool) -> wasm_memorytype ---

	wasmtime_memorytype_minimum :: proc(ty: wasm_memorytype) -> u64 ---

	wasmtime_memorytype_maximum :: proc(ty: wasm_memorytype, max: ^u64) -> bool ---

	wasmtime_memorytype_is64 :: proc(ty: wasm_memorytype) -> bool ---

	wasmtime_memory_new :: proc(store: wasmtime_context, ty: wasm_memorytype, ret: wasmtime_memory) -> wasmtime_error ---

	wasmtime_memory_type :: proc(store: wasmtime_context, memory: wasmtime_memory) -> wasm_memorytype ---

	wasmtime_memory_data :: proc(store: wasmtime_context, memory: wasmtime_memory) -> ^u8 ---

	wasmtime_memory_data_size :: proc(store: wasmtime_context, memory: wasmtime_memory) -> size_t ---

	wasmtime_memory_size :: proc(store: wasmtime_context, memory: wasmtime_memory) -> u64 ---

	wasmtime_memory_grow :: proc(store: wasmtime_context, memory: wasmtime_memory, delta: u64, prev_size: ^u64) -> wasmtime_error ---

	wasmtime_guestprofiler_delete :: proc(guestprofiler: wasmtime_guestprofiler) ---

	wasmtime_guestprofiler_new :: proc(module_name: ^wasm_name_t, interval_nanos: u64, modules: ^wasmtime_guestprofiler_modules_t, modules_len: size_t) -> wasmtime_guestprofiler ---

	wasmtime_guestprofiler_sample :: proc(guestprofiler: wasmtime_guestprofiler, store: wasmtime_store, delta_nanos: u64) ---

	wasmtime_guestprofiler_finish :: proc(guestprofiler: wasmtime_guestprofiler, out: wasm_byte_vec) -> wasmtime_error ---

	wasmtime_table_new :: proc(store: wasmtime_context, ty: wasm_tabletype, init: wasmtime_val, table: wasmtime_table) -> wasmtime_error ---

	wasmtime_table_type :: proc(store: wasmtime_context, table: wasmtime_table) -> wasm_tabletype ---

	wasmtime_table_get :: proc(store: wasmtime_context, table: wasmtime_table, index: u32, val: wasmtime_val) -> bool ---

	wasmtime_table_set :: proc(store: wasmtime_context, table: wasmtime_table, index: u32, value: wasmtime_val) -> wasmtime_error ---

	wasmtime_table_size :: proc(store: wasmtime_context, table: wasmtime_table) -> u32 ---

	wasmtime_table_grow :: proc(store: wasmtime_context, table: wasmtime_table, delta: u32, init: wasmtime_val, prev_size: ^u32) -> wasmtime_error ---

	wasmtime_trap_new :: proc(msg: cstring, msg_len: size_t) -> wasm_trap ---

	wasmtime_trap_code :: proc(trap: wasm_trap, code: ^u8) -> bool ---

	wasmtime_frame_func_name :: proc(frame: wasm_frame) -> ^wasm_name_t ---

	wasmtime_frame_module_name :: proc(frame: wasm_frame) -> ^wasm_name_t ---

	wasmtime_config_async_support_set :: proc(config: wasm_config, unamed1: bool) ---

	wasmtime_config_async_stack_size_set :: proc(config: wasm_config, unamed1: u64) ---

	wasmtime_context_fuel_async_yield_interval :: proc(_context: wasmtime_context, interval: u64) -> wasmtime_error ---

	wasmtime_context_epoch_deadline_async_yield_and_update :: proc(_context: wasmtime_context, delta: u64) -> wasmtime_error ---

	wasmtime_call_future_poll :: proc(future: wasmtime_call_future) -> bool ---

	wasmtime_call_future_delete :: proc(future: wasmtime_call_future) ---

	wasmtime_func_call_async :: proc(_context: wasmtime_context, func: wasmtime_func, args: wasmtime_val, nargs: size_t, results: wasmtime_val, nresults: size_t, trap_ret: ^wasm_trap, error_ret: ^wasmtime_error) -> wasmtime_call_future ---

	wasmtime_linker_define_async_func :: proc(linker: wasmtime_linker, module: cstring, module_len: size_t, name: cstring, name_len: size_t, ty: wasm_functype, cb: wasmtime_func_async_callback_t, data: rawptr, unamed0: #type proc(unamed0: rawptr)) -> wasmtime_error ---

	wasmtime_linker_instantiate_async :: proc(linker: wasmtime_linker, store: wasmtime_context, module: wasmtime_module, instance: wasmtime_instance, trap_ret: ^wasm_trap, error_ret: ^wasmtime_error) -> wasmtime_call_future ---

	wasmtime_instance_pre_instantiate_async :: proc(instance_pre: wasmtime_instance_pre, store: wasmtime_context, instance: wasmtime_instance, trap_ret: ^wasm_trap, error_ret: ^wasmtime_error) -> wasmtime_call_future ---

	wasmtime_config_host_stack_creator_set :: proc(config: wasm_config, unamed1: wasmtime_stack_creator) ---

	wasmtime_wat2wasm :: proc(wat: cstring, wat_len: size_t, ret: wasm_byte_vec) -> wasmtime_error ---
}

when !#config(WASMTIME_MIN, false) {

	wasi_config_t :: struct {}

	@(default_calling_convention = "c")
	foreign wasmtimelib {
		wasmtime_linker_define_wasi :: proc(linker: wasmtime_linker) -> wasmtime_error ---

		wasmtime_context_set_wasi :: proc(_context: wasmtime_context, wasi: ^wasi_config_t) -> wasmtime_error ---

		wasi_config_delete :: proc(unamed0: ^wasi_config_t) ---

		wasi_config_new :: proc() -> ^wasi_config_t ---

		wasi_config_set_argv :: proc(config: ^wasi_config_t, argc: i32, argv: ^cstring) ---

		wasi_config_inherit_argv :: proc(config: ^wasi_config_t) ---

		wasi_config_set_env :: proc(config: ^wasi_config_t, envc: i32, names: ^cstring, values: ^cstring) ---

		wasi_config_inherit_env :: proc(config: ^wasi_config_t) ---

		wasi_config_set_stdin_file :: proc(config: ^wasi_config_t, path: cstring) -> bool ---

		wasi_config_set_stdin_bytes :: proc(config: ^wasi_config_t, binary: wasm_byte_vec) ---

		wasi_config_inherit_stdin :: proc(config: ^wasi_config_t) ---

		wasi_config_set_stdout_file :: proc(config: ^wasi_config_t, path: cstring) -> bool ---

		wasi_config_inherit_stdout :: proc(config: ^wasi_config_t) ---

		wasi_config_set_stderr_file :: proc(config: ^wasi_config_t, path: cstring) -> bool ---

		wasi_config_inherit_stderr :: proc(config: ^wasi_config_t) ---

		wasi_config_preopen_dir :: proc(config: ^wasi_config_t, path: cstring, guest_path: cstring) -> bool ---

		wasi_config_preopen_socket :: proc(config: ^wasi_config_t, fd_num: u32, host_port: cstring) -> bool ---
	}
}

// Byte vectors

//wasm_name :: wasm_byte_vec_t
wasm_name_new :: wasm_byte_vec_new
wasm_name_new_empty :: wasm_byte_vec_new_empty
wasm_name_new_new_uninitialized :: wasm_byte_vec_new_uninitialized
wasm_name_copy :: wasm_byte_vec_copy
wasm_name_delete :: wasm_byte_vec_delete

wasm_name_new_from_string :: #force_inline proc "contextless" (out: ^wasm_name_t, s: cstring) {
	wasm_name_new(out, len(s), s)
}

wasm_name_new_from_string_nt :: #force_inline proc "contextless" (out: ^wasm_name_t, s: cstring) {
	wasm_name_new(out, len(s) + 1, s)
}

wasm_valkind_is_num :: #force_inline proc "contextless" (k: wasm_valkind_enum) -> bool {
	return k < wasm_valkind_enum.WASM_ANYREF
}
wasm_valkind_is_ref :: #force_inline proc "contextless" (k: wasm_valkind_enum) -> bool {
	return k >= wasm_valkind_enum.WASM_ANYREF
}
wasm_valtype_is_num :: #force_inline proc "contextless" (t: wasm_valtype) -> bool {
	return wasm_valkind_is_num(wasm_valtype_kind(t))
}
wasm_valtype_is_ref :: #force_inline proc "contextless" (t: wasm_valtype) -> bool {
	return wasm_valkind_is_ref(wasm_valtype_kind(t))
}

// Value Type construction short-hands

wasm_valtype_new_i32 :: #force_inline proc "contextless" () -> wasm_valtype {
	return wasm_valtype_new(.WASM_I32)
}
wasm_valtype_new_i64 :: #force_inline proc "contextless" () -> wasm_valtype {
	return wasm_valtype_new(.WASM_I64)
}
wasm_valtype_new_f32 :: #force_inline proc "contextless" () -> wasm_valtype {
	return wasm_valtype_new(.WASM_F32)
}
wasm_valtype_new_f64 :: #force_inline proc "contextless" () -> wasm_valtype {
	return wasm_valtype_new(.WASM_F64)
}

wasm_valtype_new_anyref :: #force_inline proc "contextless" () -> wasm_valtype {
	return wasm_valtype_new(.WASM_ANYREF)
}
wasm_valtype_new_funcref :: #force_inline proc "contextless" () -> wasm_valtype {
	return wasm_valtype_new(.WASM_FUNCREF)
}

// Function Types construction short-hands

wasm_functype_new_0_0 :: #force_inline proc "contextless" () -> wasm_functype {
	params, results: wasm_valtype_vec_t
	wasm_valtype_vec_new_empty(&params)
	wasm_valtype_vec_new_empty(&results)
	return wasm_functype_new(&params, &results)
}

wasm_functype_new_1_0 :: #force_inline proc "contextless" (p: wasm_valtype) -> wasm_functype {
	ps: [1]wasm_valtype = {p}
	params, results: wasm_valtype_vec_t
	wasm_valtype_vec_new(&params, 1, &ps[0])
	wasm_valtype_vec_new_empty(&results)
	return wasm_functype_new(&params, &results)
}

wasm_functype_new_2_0 :: #force_inline proc "contextless" (p1, p2: wasm_valtype) -> wasm_functype {
	ps: [2]wasm_valtype = {p1, p2}
	params, results: wasm_valtype_vec_t
	wasm_valtype_vec_new(&params, 2, &ps[0])
	wasm_valtype_vec_new_empty(&results)
	return wasm_functype_new(&params, &results)
}

wasm_functype_new_3_0 :: #force_inline proc "contextless" (p1, p2, p3: wasm_valtype) -> wasm_functype {
	ps: [3]wasm_valtype = {p1, p2, p3}
	params, results: wasm_valtype_vec_t
	wasm_valtype_vec_new(&params, 3, &ps[0])
	wasm_valtype_vec_new_empty(&results)
	return wasm_functype_new(&params, &results)
}

wasm_functype_new_0_1 :: #force_inline proc "contextless" (r: wasm_valtype) -> wasm_functype {
	rs: [1]wasm_valtype = {r}
	params, results: wasm_valtype_vec_t
	wasm_valtype_vec_new_empty(&params)
	wasm_valtype_vec_new(&results, 1, &rs[0])
	return wasm_functype_new(&params, &results)
}

wasm_functype_new_1_1 :: #force_inline proc "contextless" (p, r: wasm_valtype) -> wasm_functype {
	ps: [1]wasm_valtype = {p}
	rs: [1]wasm_valtype = {r}
	params, results: wasm_valtype_vec_t
	wasm_valtype_vec_new(&params, 1, &ps[0])
	wasm_valtype_vec_new(&results, 1, &rs[0])
	return wasm_functype_new(&params, &results)
}

wasm_functype_new_2_1 :: #force_inline proc "contextless" (p1, p2, r: wasm_valtype) -> wasm_functype {
	ps: [2]wasm_valtype = {p1, p2}
	rs: [1]wasm_valtype = {r}
	params, results: wasm_valtype_vec_t
	wasm_valtype_vec_new(&params, 2, &ps[0])
	wasm_valtype_vec_new(&results, 1, &rs[0])
	return wasm_functype_new(&params, &results)
}

wasm_functype_new_3_1 :: #force_inline proc "contextless" (p1, p2, p3, r: wasm_valtype) -> wasm_functype {
	ps: [3]wasm_valtype = {p1, p2, p3}
	rs: [1]wasm_valtype = {r}
	params, results: wasm_valtype_vec_t
	wasm_valtype_vec_new(&params, 3, &ps[0])
	wasm_valtype_vec_new(&results, 1, &rs[0])
	return wasm_functype_new(&params, &results)
}

wasm_functype_new_0_2 :: #force_inline proc "contextless" (r1, r2: wasm_valtype) -> wasm_functype {
	rs: [2]wasm_valtype = {r1, r2}
	params, results: wasm_valtype_vec_t
	wasm_valtype_vec_new_empty(&params)
	wasm_valtype_vec_new(&results, 2, &rs[0])
	return wasm_functype_new(&params, &results)
}

wasm_functype_new_1_2 :: #force_inline proc "contextless" (p, r1, r2: wasm_valtype) -> wasm_functype {
	ps: [1]wasm_valtype = {p}
	rs: [2]wasm_valtype = {r1, r2}
	params, results: wasm_valtype_vec_t
	wasm_valtype_vec_new(&params, 1, &ps[0])
	wasm_valtype_vec_new(&results, 2, &rs[0])
	return wasm_functype_new(&params, &results)
}

wasm_functype_new_2_2 :: #force_inline proc "contextless" (p1, p2, r1, r2: wasm_valtype) -> wasm_functype {
	ps: [2]wasm_valtype = {p1, p2}
	rs: [2]wasm_valtype = {r1, r2}
	params, results: wasm_valtype_vec_t
	wasm_valtype_vec_new(&params, 2, &ps[0])
	wasm_valtype_vec_new(&results, 2, &rs[0])
	return wasm_functype_new(&params, &results)
}

wasm_functype_new_3_2 :: #force_inline proc "contextless" (p1, p2, p3, r1, r2: wasm_valtype) -> wasm_functype {
	ps: [3]wasm_valtype = {p1, p2, p3}
	rs: [2]wasm_valtype = {r1, r2}
	params, results: wasm_valtype_vec_t
	wasm_valtype_vec_new(&params, 3, &ps[0])
	wasm_valtype_vec_new(&results, 2, &rs[0])
	return wasm_functype_new(&params, &results)
}

// Value construction short-hands

wasm_val_init_ptr :: #force_inline proc "contextless" (out: wasm_val, p: rawptr) {
	when size_of(uintptr) == size_of(u64) {
		out.kind = .WASM_I64
		out.of.i64 = i64(uintptr(p))
	} else {
		out.kind = .WASM_I32
		out.of.i32 = i32(uintptr(p))
	}
}

wasm_val_ptr :: #force_inline proc "contextless" (val: wasm_val) -> rawptr {
	when size_of(uintptr) == size_of(u64) {
		return rawptr(uintptr(val.of.i64))
	} else {
		return rawptr(uintptr(val.of.i32))
	}
}

WASM_I32_VAL :: #force_inline proc "contextless" (i: i32) -> wasm_val_t {return wasm_val_t{kind = .WASM_I32, of = {i32 = i}}}
WASM_I64_VAL :: #force_inline proc "contextless" (i: i64) -> wasm_val_t {return wasm_val_t{kind = .WASM_I64, of = {i64 = i}}}
WASM_F32_VAL :: #force_inline proc "contextless" (z: f32) -> wasm_val_t {return wasm_val_t{kind = .WASM_F32, of = {f32 = z}}}
WASM_F64_VAL :: #force_inline proc "contextless" (z: f64) -> wasm_val_t {return wasm_val_t{kind = .WASM_F64, of = {f64 = z}}}
WASM_REF_VAL :: #force_inline proc "contextless" (r: wasm_ref) -> wasm_val_t {return wasm_val_t{kind = .WASM_ANYREF, of = {ref = r}}}
WASM_INIT_VAL :: #force_inline proc "contextless" () -> wasm_val_t {return wasm_val_t{kind = .WASM_ANYREF, of = {ref = nil}}}

// Odin utils

stdin :: 0
stdout :: 1
stderr :: 2

to_string :: #force_inline proc "contextless" (error_message: wasm_byte_vec) -> string {
	return string(([^]u8)(error_message.data)[:error_message.size])
}

get_args :: #force_inline proc "contextless" (pargs: wasmtime_val, nargs: size_t) -> []wasmtime_val_t {
	return ([^]wasmtime_val_t)(pargs)[:nargs]
}

get_memory_from_caller :: proc(caller: wasmtime_caller, wtctx: wasmtime_context, name: cstring) -> []u8 {
	item: wasmtime_extern_t
	ok := wasmtime_caller_export_get(caller, name, len(name), &item)
	assert(ok && item.kind == .WASM_EXTERN_MEMORY)
	memory: wasmtime_memory_t = item.of.memory
	memory_data_size := wasmtime_memory_data_size(wtctx, &memory)
	memory_data := wasmtime_memory_data(wtctx, &memory)
	assert(memory_data_size > 0 && memory_data != nil)
	return ([^]u8)(memory_data)[:memory_data_size]
}
