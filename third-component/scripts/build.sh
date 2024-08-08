#!/bin/bash

clear

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

# validate preconditions
check_command() {
   if command -v "$1" >/dev/null 2>&1; then
      echo -e "\e\t[32m\u2714 $1 detected\e[0m"
   else
      echo -e "\e\t[31m\u2718 $1 is not installed or not in your PATH\e[0m"
      exit 1
   fi
}

echo -e "Evaluating pre-conditions .."
check_command wit-bindgen
check_command tinygo
check_command wasm-tools
check_command wasi-virt
check_command rustc
echo

# generate bindings
wit-bindgen tiny-go ./read.wit --world discovery --out-dir=gen

# build for target 'wasi'
tinygo build -o reader.wasm -target=wasi read.go

# # embed WIT
wasm-tools component embed --world discovery ./read.wit reader.wasm -o reader.embed.wasm

# # create component
export COMPONENT_ADAPTER_REACTOR=binaries/wasi_snapshot_preview1.reactor.wasm
wasm-tools component new -o reader.component.wasm --adapt wasi_snapshot_preview1="$COMPONENT_ADAPTER_REACTOR" reader.embed.wasm

# virtualize component
echo -e "Virtualizing .."
# wasi-virt reader.component.wasm --mount /data=./ -o reader.wasm
wasi-virt reader.component.wasm --preopen /data=./ -o reader.wasm

echo -e "\nResult .."
wasm-tools component wit reader.wasm

cp ./reader.wasm $1/reader.wasm

pushd $1
echo
export WASMTIME_DEBUG=wasmtime_wasi=trace
cargo run --release
echo
popd