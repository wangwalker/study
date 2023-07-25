package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"strconv"
	"strings"
)

var infile string
var outfile string

func init() {
	flag.StringVar(&infile, "i", "infile", "File contains values for sorting")
	flag.StringVar(&outfile, "o", "outfile", "File to receive sorted values")
}
func main() {
	flag.Parse()
	err := amend(infile, outfile)
	if err != nil {
		fmt.Println(err)
	}
}

// Amend amends yaml file that has duplicate keys, and returns the amended yaml
// For the new keys, append the key with a number, starting from 1 (e.g. key1, key2, key3, ...)
// For example, the following yaml file:
// key:
//	subkey1: value
// key:
//	subkey1: value
// key:
//	subkey1: value
// will be amended to:
// key1:
//	subkey1: value
// key2:
//	subkey1: value
// key3:
//	subkey1: value

func amend(inPath string, outPath string) error {
	infile, err := os.Open(inPath)
	if err != nil {
		return err
	}
	defer infile.Close()
	keys := make(map[string]int)
	// read the file line by line and append it into keys if it doesn't has prefix " "
	scanner := bufio.NewScanner(infile)
	for scanner.Scan() {
		line := scanner.Text()
		fmt.Printf("line: %v\n", line)
		if !strings.HasSuffix(line, ":") {
			continue
		}
		if _, ok := keys[line]; ok {
			keys[line]++
		} else {
			keys[line] = 1
		}
	}
	for k, v := range keys {
		if v > 1 {
			fmt.Println(k, v)
		}
	}
	if err := scanner.Err(); err != nil {
		return err
	}
	// write the amended file
	outfile, err := os.Create(outPath)
	if err != nil {
		return err
	}
	defer outfile.Close()
	// open input file again and write the amended file
	infile2, _ := os.Open(inPath)
	defer infile2.Close()
	scanner2 := bufio.NewScanner(infile2)
	for scanner2.Scan() {
		line := scanner2.Text()
		if !strings.HasSuffix(line, ":") {
			outfile.WriteString(line + "\n")
			continue
		}
		if keys[line] > 1 {
			l := len(line)
			outfile.WriteString(line[:l-1] + strconv.Itoa(keys[line]) + ":\n")
			keys[line]--
		} else {
			outfile.WriteString(line + "\n")
		}
	}
	return nil
}
