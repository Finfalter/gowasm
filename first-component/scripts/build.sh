#!/bin/bash

clear

rm *.wasm
rm -rf gen

# genereate bindings
wit-bindgen tiny-go ./greet.wit --world courtesy --out-dir=gen

# build
tinygo build -o greeter.wasm -target=wasi greet.go

# embed WIT
wasm-tools component embed --world courtesy ./greet.wit greeter.wasm -o greet.embed.wasm

# create component, for the reactor, see https://github.com/bytecodealliance/wit-bindgen?tab=readme-ov-file#creating-components-wasi
wasm-tools component new -o greet.component.wasm --adapt wasi_snapshot_preview1=binaries/wasi_snapshot_preview1.reactor.wasm greet.embed.wasm

# virtualize WASI, see https://github.com/bytecodealliance/WASI-Virt
wasi-virt greet.component.wasm -o greeter.wasm

# inspect component, see https://github.com/bytecodealliance/wasm-tools
wasm-tools component wit greeter.wasm