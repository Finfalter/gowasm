#!/bin/bash

clear

rm -rf gen
rm *.wasm

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <folder_path>"
    echo "Please provide the folder path to a (Rust) component host"
    exit 1
fi

# Check if the argument is a valid directory
if [ ! -d "$1" ]; then
    echo "Error: '$1' is not a valid directory."
    exit 1
fi

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
wasi-virt reader.component.wasm --mount /=./ -o reader.wasm
# wasi-virt reader.component.wasm --preopen /=./ -o reader.wasm

wasm-tools component wit reader.wasm

cp ./reader.wasm $1/reader.wasm

pushd $1
echo
export WASMTIME_DEBUG=wasmtime_wasi=trace
cargo run 
echo
popd