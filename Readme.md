# Posgresql sharding example
1. Setup  sharding with use of native postgresql option and with 3d party extensions;
1. Test insert/select perfomance configs on 1_000_000 size dataset;

## Insert
### Native Partitioning
Run container: docker compose --profile partition up -d
1. Request: siege -c10 -r1 -b 'http://0.0.0.0:3000/products/100000 POST' -H "Content-Type: text/plain"
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
2. Request: siege -c100 -r1 -b 'http://0.0.0.0:3000/products/10000 POST' -H "Content-Type: text/plain"
Result:
```bash
Transactions:                    100 hits
Availability:                 100.00 %
Elapsed time:                  66.14 secs
Data transferred:               0.00 MB
Response time:                 65.94 secs
Transaction rate:               1.51 trans/sec
Throughput:                     0.00 MB/sec
Concurrency:                   99.69
Successful transactions:         100
Failed transactions:               0
Longest transaction:           66.14
Shortest transaction:          65.48
```

### Native Sharding (FDW extension)
Run container: docker compose --profile sharding_fdw up -d
Run config fdw sharding script: npm run sharding:fdw:setup

1. Request: siege -c10 -r1 -b 'http://0.0.0.0:3000/products/100000 POST' -H "Content-Type: text/plain"
Result: 
```bash
Transactions:                     10 hits
Availability:                 100.00 %
Elapsed time:                 169.77 secs
Data transferred:               0.00 MB
Response time:                169.53 secs
Transaction rate:               0.06 trans/sec
Throughput:                     0.00 MB/sec
Concurrency:                    9.99
Successful transactions:          10
Failed transactions:               0
Longest transaction:          169.77
Shortest transaction:         169.02
```

2. Request: siege -c100 -r1 -b 'http://0.0.0.0:3000/products/10000 POST' -H "Content-Type: text/plain"
Result:
```bash
Transactions:                    100 hits
Availability:                 100.00 %
Elapsed time:                 108.96 secs
Data transferred:               0.00 MB
Response time:                107.91 secs
Transaction rate:               0.92 trans/sec
Throughput:                     0.00 MB/sec
Concurrency:                   99.04
Successful transactions:         100
Failed transactions:               0
Longest transaction:          108.95
Shortest transaction:         104.21
```

### Pl/Proxy sharding
Run container: docker compose --profile sharding_plproxy up -d
1. Request: siege -c10 -r1 -b 'http://0.0.0.0:3000/products/100000 POST' -H "Content-Type: text/plain"
Result: 
```bash
Transactions:                     10 hits
Availability:                 100.00 %
Elapsed time:                 222.78 secs
Data transferred:               0.00 MB
Response time:                222.03 secs
Transaction rate:               0.04 trans/sec
Throughput:                     0.00 MB/sec
Concurrency:                    9.97
Successful transactions:          10
Failed transactions:               0
Longest transaction:          222.78
Shortest transaction:         220.38
```
2. Request: siege -c100 -r1 -b 'http://0.0.0.0:3000/products/10000 POST' -H "Content-Type: text/plain"
Result:
```bash
Transactions:                    100 hits
Availability:                 100.00 %
Elapsed time:                 150.86 secs
Data transferred:               0.00 MB
Response time:                150.27 secs
Transaction rate:               0.66 trans/sec
Throughput:                     0.00 MB/sec
Concurrency:                   99.61
Successful transactions:         100
Failed transactions:               0
Longest transaction:          150.86
Shortest transaction:         147.55
```

## Select

### Native partitioning

1. Request: siege -c100 -r1 -b 'http://0.0.0.0:3000/products?type=3&amount_min=50&amount_max=60&price_min=300&price_max=350&limit_param=9000&offset_param=0'
Result:
```bash
Transactions:                    100 hits
Availability:                 100.00 %
Elapsed time:                   0.57 secs
Data transferred:              18.50 MB
Response time:                  0.45 secs
Transaction rate:             175.44 trans/sec
Throughput:                    32.45 MB/sec
Concurrency:                   78.30
Successful transactions:         100
Failed transactions:               0
Longest transaction:            0.57
Shortest transaction:           0.27
```

### Native Sharding (FDW extension)

1. Request: siege -c100 -r1 -b 'http://0.0.0.0:3000/products?type=3&amount_min=50&amount_max=60&price_min=300&price_max=350&limit_param=9000&offset_param=0'
Result:
```bash
Transactions:                    100 hits
Availability:                 100.00 %
Elapsed time:                   2.32 secs
Data transferred:              17.45 MB
Response time:                  1.78 secs
Transaction rate:              43.10 trans/sec
Throughput:                     7.52 MB/sec
Concurrency:                   76.84
Successful transactions:         100
Failed transactions:               0
Longest transaction:            2.32
Shortest transaction:           0.74
```

### Pl/Proxy sharding

1. Request: siege -c100 -r1 -b 'http://0.0.0.0:3000/products?type=3&amount_min=10&amount_max=100&price_min=300&price_max=10000&limit_param=9000&offset_param=0'
Result:
```bash
Transactions:                    100 hits
Availability:                 100.00 %
Elapsed time:                   1.89 secs
Data transferred:              76.68 MB
Response time:                  1.53 secs
Transaction rate:              52.91 trans/sec
Throughput:                    40.57 MB/sec
Concurrency:                   81.10
Successful transactions:         100
Failed transactions:               0
Longest transaction:            1.89
Shortest transaction:           0.36
```
