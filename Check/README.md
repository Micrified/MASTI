# Check

Takes a list of domains on standard input (no extra markers) such as: 

```
www.google.com
www.hentaiheaven.com
rug.nl
```

or

```
ingdirect.com.au.	AAAA
www.humansciences.mq.edu.au.	A
ingdirect.com.au.	MX
```

And outputs domains on stdout that seem to exist using the result of a command-execution invocation of `host -t ns <domain>`. 
A timer of 250ms is set to space out calls in order to avoid getting blocked. You can mess with the timer by changing the nanosecond count in the C file and then recompiling it. 

### Usage

`./check [-clean] < domains.in > domains.out`

If the `-clean` flag is provided, it expects the domain with NO suffixes as shown in the first input example. It also outputs in that format. If no clean flag is set, then it outputs with the suffixes.
