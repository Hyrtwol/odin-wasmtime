@pushd %~dp0
odin.exe build .\helloworld.odin -file -target:js_wasm32 -show-timings
@popd
