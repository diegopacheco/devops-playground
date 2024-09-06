### Result

```
❯ ./build-docker.sh
[+] Building 5.9s (9/9) FINISHED                                                                                                                               docker:default
 => [internal] load build definition from Dockerfile                                                                                                                     0.0s
 => => transferring dockerfile: 594B                                                                                                                                     0.0s
 => [internal] load metadata for docker.io/library/python:3.9-slim                                                                                                       0.4s
 => [internal] load .dockerignore                                                                                                                                        0.0s
 => => transferring context: 2B                                                                                                                                          0.0s
 => [1/4] FROM docker.io/library/python:3.9-slim@sha256:69e712dbe4c4a166527cbf69374533125cfb6ee93a5e39031a0191c741d386d7                                                 0.0s
 => [internal] load build context                                                                                                                                        0.0s
 => => transferring context: 1.00kB                                                                                                                                      0.0s
 => CACHED [2/4] WORKDIR /app                                                                                                                                            0.0s
 => [3/4] COPY . /app                                                                                                                                                    0.0s
 => [4/4] RUN pip install Flask                                                                                                                                          5.2s
 => exporting to image                                                                                                                                                   0.2s 
 => => exporting layers                                                                                                                                                  0.2s 
 => => writing image sha256:360e5578667bad9221851f1fb306c9fc91c510ac585fd1fa2404ebbcddd4e75e                                                                             0.0s 
 => => naming to docker.io/library/python-app-hostname:latest                                                                                                            0.0s 
❯ ./run-docker-app.sh
 * Serving Flask app 'app'
 * Debug mode: off
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:80
 * Running on http://172.17.0.2:80
Press CTRL+C to quit
172.17.0.1 - - [06/Sep/2024 08:39:03] "GET / HTTP/1.1" 200 -
172.17.0.1 - - [06/Sep/2024 08:39:03] "GET /favicon.ico HTTP/1.1" 404 -
172.17.0.1 - - [06/Sep/2024 08:39:03] "GET /favicon.ico HTTP/1.1" 404 -

```
```
❯ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Server: Werkzeug/3.0.4 Python/3.9.19
Date: Fri, 06 Sep 2024 08:39:41 GMT
Content-Type: application/json
Content-Length: 46
Connection: close

{"hostname":"4winds","pod_name":"pod-4winds"}
```

```
❯ ./port-forward-app.sh
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080
Handling connection for 8080
```
```
curl -i http://localhost:8080/
```
```
❯ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Server: Werkzeug/3.0.4 Python/3.9.19
Date: Fri, 06 Sep 2024 09:04:41 GMT
Content-Type: application/json
Content-Length: 97
Connection: close

{"hostname":"kind-worker","pod_name":"app-deployment-968c6fb95-gljqq","pod_namespace":"default"}
```