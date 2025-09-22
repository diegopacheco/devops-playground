# K6

Stress testing with [K6](https://k6.io/).

## Install

```bash
brew install k6
```

### Results

```bash
❯ ./run-stress-test.sh

         /\      Grafana   /‾‾/
    /\  /  \     |\  __   /  /
   /  \/    \    | |/ /  /   ‾‾\
  /          \   |   (  |  (‾)  |
 / __________ \  |_|\_\  \_____/

     execution: local
        script: test.js
        output: -

     scenarios: (100.00%) 1 scenario, 1 max VUs, 10m30s max duration (incl. graceful stop):
              * default: 10 iterations shared among 1 VUs (maxDuration: 10m0s, gracefulStop: 30s)



  █ TOTAL RESULTS

    HTTP
    http_req_duration..............: avg=87.99ms min=76.73ms med=85.92ms max=111.09ms p(90)=100.24ms p(95)=105.67ms
      { expected_response:true }...: avg=87.99ms min=76.73ms med=85.92ms max=111.09ms p(90)=100.24ms p(95)=105.67ms
    http_req_failed................: 0.00%  0 out of 10
    http_reqs......................: 10     0.900298/s

    EXECUTION
    iteration_duration.............: avg=1.11s   min=1.07s   med=1.08s   max=1.3s     p(90)=1.13s    p(95)=1.21s
    iterations.....................: 10     0.900298/s
    vus............................: 1      min=1       max=1
    vus_max........................: 1      min=1       max=1

    NETWORK
    data_received..................: 33 kB  2.9 kB/s
    data_sent......................: 1.1 kB 96 B/s




running (00m11.1s), 0/1 VUs, 10 complete and 0 interrupted iterations
default ✓ [======================================] 1 VUs  00m11.1s/10m0s  10/10 shared iters
```