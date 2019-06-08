import csv
import json

lines_per_tld = 2
dns_types = ["DNS", "DNSSec", "DoT", "DoH"]
measurements = ["min", "average", "max"]

with open("allResults.csv") as resultsCSV:
    json_data = {}
    csv_reader = csv.reader(resultsCSV, delimiter=',')
    for n, row in enumerate(csv_reader):
        if not n%(lines_per_tld+1): # Line contains tld
            tld = row[0] # Only one value on line, which is the tld
            json_data[tld] = []
        else:
            resolver_data = {dns : {} for dns in dns_types}
            resolver_data["resolver"] = row[0]
            for i, dns in enumerate(dns_types):
                for j, measurement_type in enumerate(measurements):
                    resolver_data[dns][measurement_type] = row[1+i*4+j]
            json_data[tld].append(resolver_data)

print(json.dumps(json_data, indent=4, sort_keys=True))

with open('allResults.json', 'w') as outfile:  
    json.dump(json_data, outfile)