# TLDSort

Sorts domains from `dnsperf_test_queries.tsv` into the following TLDs:

 * `.au`
 * `.ca`
 * `.nl`
 * `.net`

 The program takes the file as standard input, so the usage process is as follows:

  1. Build the program with `go build tldsort.go`
  2. Invoke the program with: `./tldsort < dnsperf_test_queries.tsv`

  If you don't want `A`, `PRT`, and other record types appended to the end of the domain, then run it with the `-clean` flag. e.g: `./tldsort -clean < ...`