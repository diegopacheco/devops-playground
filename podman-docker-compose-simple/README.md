### Enble docker-compose with podman

0. Install podman-compose
```
/bin/pip install podman-compose
```
1. Enable podman socket
```
sudo systemctl stop docker
sudo systemctl start podman.socket
export DOCKER_HOST=unix:///run/user/$(id -u)/podman/podman.sock
```
2. Check if podman socket is enabled
```
sudo curl -H "Content-Type: application/json" --unix-socket /var/run/docker.sock http://localhost/_ping
```
3. Run
```
podman-compose up
```
4. Test - goto localhost:3000
5. Check
```
podman ps
```
6. shutdown
```
podman-compose down
```