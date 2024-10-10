### Native Partitioning

Request: siege -c10 -r1 -b 'http://0.0.0.0:3000/products/100000 POST' -H "Content-Type: text/plain"
Result: 
```bash
Transactions:                     10 hits
Availability:                 100.00 %
Elapsed time:                  79.22 secs
Data transferred:               0.00 MB
Response time:                 78.36 secs
Transaction rate:               0.13 trans/sec
Throughput:                     0.00 MB/sec
Concurrency:                    9.89
Successful transactions:          10
Failed transactions:               0
Longest transaction:           79.22
Shortest transaction:          76.74
```