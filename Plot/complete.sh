#!/bin/bash
url='https://discordapp.com/api/webhooks/535984301984972860/1VDCaTXcuN4e1LNmy7Km4M68ipbnxcqGGSXhQSsgkyprhwCBpgoPdn1rExwoXM3nlLss'
sleep 5
message="Your shit is done, go check on it."
msg_content=\"$message\"
curl -H "Content-Type: application/json" -X POST -d "{\"content\": $msg_content}" $url
