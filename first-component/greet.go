package main

import (
	. "first/gen"
)

type GreeterImpl struct {
}

func (i GreeterImpl) Greet(x string) string {
	greeting := "Hello"
	return greeting + " " + x
}

// To enable our component to be a library, implement the component in the
// `init` function which is always called first when a Go package is run.
func init() {
	example := GreeterImpl{}
	SetExportsFinfalterCourtesy0_1_0_Greeting(example)
}

// main is required for the `WASI` target, even if it isn't used.
func main() {}
