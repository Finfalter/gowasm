#!/bin/bash

clear

rm -rf gen
rm *.wasm

# generate bindings
wit-bindgen tiny-go ./read.wit --world discovery --out-dir=gen

# build for target 'wasi'
tinygo build -o reader.wasm -target=wasi read.go

# embed WIT
wasm-tools component embed --world discovery ./read.wit reader.wasm -o reader.embed.wasm

# create component
export COMPONENT_ADAPTER_REACTOR=binaries/wasi_snapshot_preview1.reactor.wasm
wasm-tools component new -o reader.component.wasm --adapt wasi_snapshot_preview1="$COMPONENT_ADAPTER_REACTOR" reader.embed.wasm

# virtualize component
# wasi-virt read.component.wasm --mount /=./ -o virt.wasm
wasi-virt reader.component.wasm --mount /=./ -o reader.wasm
# wasi-virt read.component.wasm --allow-fs -o virt.wasm
# wasi-virt read.component.wasm --allow-fs --allow-stdio --out virt.wasm

wasm-tools component wit reader.wasm

# cp ./reader.wasm /home/finnfalter/dev/rust/addgo/runner/virt.wasm

# pushd /home/finnfalter/dev/rust/addgo/runner
# cargo run --release
# popd