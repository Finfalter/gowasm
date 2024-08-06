package main

import (
	"fmt"
	"io"
	"log"
	"os"
)

func main() {
	// Check if the filename is provided as an argument
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <filename>", os.Args[0])
	}

	// Get the filename from the command-line arguments
	filename := os.Args[1]

	// Open the file
	file, err := os.Open(filename)
	if err != nil {
		log.Fatalf("failed to open file: %s", err)
	}
	defer file.Close()

	// Read the file's contents
	content, err := io.ReadAll(file)
	if err != nil {
		log.Fatalf("failed to read file: %s", err)
	}

	// Print the file's contents
	fmt.Println(string(content))
}

// func main() {
// 	// // Open the current directory
// 	dir, err := os.Open("/")
// 	if err != nil {
// 		fmt.Println("Could not open fs: %v", err)
// 	}
// 	defer dir.Close()

// 	// List files in the current directory
// 	files, err := dir.Readdir(-1)
// 	if err != nil {
// 		fmt.Println("Could not read out fs!")
// 	}

// 	var fileNames []string
// 	for _, file := range files {
// 		fileNames = append(fileNames, file.Name())
// 	}

// 	// Aggregate filenames into a single string
// 	aggregatedFileNames := strings.Join(fileNames, ", ")
// 	fmt.Println(aggregatedFileNames)
// }
