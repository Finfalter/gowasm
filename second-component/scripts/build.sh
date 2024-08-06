#!/bin/bash

clear

rm -rf gen
rm *.wasm

echo -e "build for target 'wasip2'"
tinygo build -o reader.wasm -target=wasip2 read.go

echo -e "run with wasmtime:"
wasmtime run --dir=./::/ reader.wasm /file.txt