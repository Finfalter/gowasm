# Go Wasm!

## Pre-requisites

* __tinygo__: `https://tinygo.org/`, build from `dev` branch in case you want to target `wasip2`
* __wasm-tools__: from [wasm-tools](https://github.com/bytecodealliance/wasm-tools), install via `cargo install wasm-tools`
* __wit-bindgen-go__: from [wasm-tools-go](https://github.com/ydnar/wasm-tools-go/tree/main), build from source
* __wasi-virt__: from [WASI-Virt](https://github.com/bytecodealliance/WASI-Virt), install via `cargo install --git https://github.com/bytecodealliance/wasi-virt`

## Build & Run

Each of the examples may be built and run by __*"scripts/build.sh"*__.

## First Component

Creates a simple WASM component based on some Go code and a WIT. 
It exports one simple function which accepts a `string` and returns a `string`.

## Second Component

Demonstrates how to use target `wasip2` and how to access the filesystem with __wasmtime-cli__.
The component exposes a `main()` function which is called by __wasmtime-cli__.

## Third Component

Tries to create a WASM component which accesses the filesystem in order to read out a file.
Meant to be run by a host like [componenthost](https://github.com/Finfalter/componenthost).

It is recommended to clone __componenthost__ first, e.g. to *"/home/you/componenthost"*, 
and then build and run __third-component__ like *"./third-component/scripts/build.sh /home/you/componenthost"*.

## Fourth Component

Tries to create a WASM component from Go code targeting `wasip2`.
The design goal is to expose an arbitrary function which may access the filesystem. 
So far, it does not work.