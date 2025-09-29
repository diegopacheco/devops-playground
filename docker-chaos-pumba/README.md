# Pumba

```
❯ ./chaos-pumba.sh
Starting chaos engineering with Pumba...
Current container status:
NAME         IMAGE                            COMMAND                  SERVICE   CREATED          STATUS          PORTS
api-server   docker.io/library/httpd:alpine   "httpd-foreground"       api       33 seconds ago   Up 33 seconds   0.0.0.0:8082->80/tcp
web-server   docker.io/library/nginx:alpine   "nginx -g daemon off;"   web       33 seconds ago   Up 33 seconds   0.0.0.0:8081->80/tcp

Downloading Pumba binary...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100 13.8M  100 13.8M    0     0  2509k      0  0:00:05  0:00:05 --:--:-- 2776k

Killing web-server container with Pumba...
Container status after kill:
NAME         IMAGE                            COMMAND              SERVICE   CREATED          STATUS          PORTS
api-server   docker.io/library/httpd:alpine   "httpd-foreground"   api       42 seconds ago   Up 42 seconds   0.0.0.0:8082->80/tcp

Manually restarting killed service (simulating orchestrator recovery)...
[+] Running 1/1
 ✔ Container web-server  Started                                                                                        0.0s
Container status after recovery:
NAME         IMAGE                            COMMAND                  SERVICE   CREATED          STATUS          PORTS
api-server   docker.io/library/httpd:alpine   "httpd-foreground"       api       48 seconds ago   Up 47 seconds   0.0.0.0:8082->80/tcp
web-server   docker.io/library/nginx:alpine   "nginx -g daemon off;"   web       48 seconds ago   Up 5 seconds    0.0.0.0:8081->80/tcp

Pausing api-server container with Pumba...
Testing connectivity during pause:
curl: (28) Operation timed out after 5005 milliseconds with 0 bytes received
Connection failed - container paused

Stopping web-server container with Pumba...
Container status after stop:
NAME         IMAGE                            COMMAND              SERVICE   CREATED              STATUS              PORTS
api-server   docker.io/library/httpd:alpine   "httpd-foreground"   api       About a minute ago   Up About a minute   0.0.0.0:8082->80/tcp
Testing connectivity after stop:
curl: (7) Failed to connect to localhost port 8081 after 0 ms: Couldn't connect to server
Connection failed - container stopped

Waiting for auto-restart...

Final container status:
NAME         IMAGE                            COMMAND              SERVICE   CREATED              STATUS              PORTS
api-server   docker.io/library/httpd:alpine   "httpd-foreground"   api       About a minute ago   Up About a minute   0.0.0.0:8082->80/tcp

Chaos engineering with Pumba completed. Recovery verified.
removing pumba binary...
```