package main

import (
	"fmt"
	"os"
	"strings"
	. "third/gen"
)

type ReaderImpl struct {
}

func (i ReaderImpl) Read(anything string) string {
	// // Open the current directory
	dir, err := os.Open("/")
	if err != nil {
		return fmt.Sprintf("Could not open fs: %v", err)
	}
	defer dir.Close()

	// List files in the current directory
	files, err := dir.Readdir(-1)
	if err != nil {
		return fmt.Sprintf("Could not read out fs!")
	}

	var fileNames []string
	for _, file := range files {
		fileNames = append(fileNames, file.Name())
	}

	// Aggregate filenames into a single string
	aggregatedFileNames := strings.Join(fileNames, ", ")
	return aggregatedFileNames
}

// To enable our component to be a library, implement the component in the
// `init` function which is always called first when a Go package is run.
func init() {
	example := ReaderImpl{}
	SetExportsFinfalterReaderDiscover(example)
}

// main is required for the `WASI` target, even if it isn't used.
func main() {}
