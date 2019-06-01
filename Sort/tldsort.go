package main 

import (
	"fmt"
	"os"
	"log"
	"bufio"
	"io"
	"strings"
)


// The top level-domains to filter for (order important!)
var tlds [][]byte = [][]byte{
	{'a','u'},
	{'c','a'},
	{'n','l'},
	{'n','e','t'},
};


// Matches a two-byte tld
func matchLen2TLD (tld []byte) (bool, int) {
	switch tld[0] {
		case 'a': return (tld[1] == 'u'), 0;
		case 'c': return (tld[1] == 'a'), 1;
		case 'n': return (tld[1] == 'l'), 2;
		default:
			break;
	}
	return false, -1;
}


// Matches a three-byte tld
func matchLen3TLD (tld []byte) (bool, int) {
	switch tld[0] {
		case 'n': return (tld[1] == 'e' && tld[2] == 't'), 3;
		default:
			break;
	}
	return false, -1;
}


// If accepted domain, boolean returned + index of tld + end of tld
func isValidTLD (line []byte) (bool, int, int) {
	var i, j, n int;

	// Get line length
	n = len(line);

	// Start from the back, scan until the first '.', 
	for i = (n - 1); i >= 0 && line[i] != '.'; i-- {}

	// Check: enough bytes remain
	if i < 3 {
		return false, -1, -1;
	}

	// Find start of tld
	for j = i - 1; j >= 0 && line[j] != '.'; j-- {}

	// Check: found start marker
	if (j < 0) || (line[j] != '.') {
		return false, -1, -1;
	}

	// Compute length
	length := (i - j - 1);

	// Take action on length
	switch length {
		case 2: {
			match, idx := matchLen2TLD(line[j+1:]);
			return match, idx, i;
		}
		case 3: {
			match, idx := matchLen3TLD(line[j+1:]);
			return match, idx, i;
		}
		default:
			break;
	}

	return false, -1, -1;
}



func main () {
	var err error;
	var reader *bufio.Reader;
	var i, valid int;
	var line []byte;
	var filenames []string;
	var files []*os.File;
	var file *os.File;
	var clean bool = false;

	// Check args
	if (len(os.Args) == 2) {
		arg := os.Args[1];
		if strings.Compare(arg, "-clean") != 0 {
			log.Fatalf("Err: Unrecognized argument: \"%s\"\n", arg);
		}
		clean = true;
	}

	// Open/Create the files for output. If existing, they are truncated
	for _, tld := range tlds {
		filename := fmt.Sprintf("tld.%s.txt", string(tld));
		filenames = append(filenames, filename);
		file, err = os.Create(filename);
		if err != nil {
			log.Fatalf("Err: Couldn't create file \"%s\": %s\n", filename, err.Error());
		}
		files = append(files, file);
		defer file.Close();
	}

	// Create a buffered-reader from STDIN
	reader = bufio.NewReader(os.Stdin);

	// Read all lines
	for i = 0; ; i++ {
		
		// Read next line
		line, err = reader.ReadBytes('\n');

		// Exit on error
		if err != nil {
			break;
		}

		// Check for matches in domains
		match, idx, end := isValidTLD(line);

		// If no match, move on
		if match == false {
			continue;
		} else {
			valid++;
			file = files[idx];
		}

		// Prepare line to write
		if clean {
			line = append(line[:end], '\n');
		}

		// Otherwise, append it to the appropriate file
		_, err = file.Write(line);

		// Check for error
		if err != nil {
			break;
		}
	}

	// Report anomalies
	if err != io.EOF {
		log.Fatalf("Err: Couldn't read bytes: %s\n", err.Error());
	}

	// Signal end
	fmt.Printf("Done (%d/%d domains extracted)\n", valid, i);
}