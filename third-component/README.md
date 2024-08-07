# Third Component

## Third Component

Tries to create a __WASM component__ which accesses the filesystem in order to read out a file.
Meant to be run by a host like [componenthost](https://github.com/Finfalter/componenthost).

It is recommended to clone __componenthost__ first, e.g. to *"/home/you/componenthost"*,
and then build and run __third-component__ like *"./third-component/scripts/build.sh /home/you/componenthost"*.

Essential parts of *"scripts/build.sh"* are
```bash
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
```