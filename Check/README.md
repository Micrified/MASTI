# Check

Takes a list of domains on standard input (no extra markers) such as: 

```
www.google.com
www.hentaiheaven.com
rug.nl
```

And outputs domains on stdout that seem to exist using the result of a command-execution invocation of `host -t ns <domain>`. 
A timer of 250ms is set to space out calls in order to avoid getting blocked. You can mess with the timer by changing the nanosecond count in the C file and then recompiling it. 

### Usage

`./check < domains.in > domains.out`