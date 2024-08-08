// mypackage/read.go
package main

import (
	"fmt"
	"four/finfalter/reader/discover"
	"os"
	"strings"
)

//export Read
func Read(anything string) string {
	// Open the current directory
	dir, err := os.Open("/data")
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

func init() {
	// Assign your custom Read function to the exported function
	discover.Exports.Read = Read
}

func main() {}
