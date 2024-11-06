### Install Colima

```bash
brew install colima
```

### Start Colima

```bash
colima start
```
```
❯ colima start
INFO[0000] starting colima                              
INFO[0000] runtime: docker                              
INFO[0000] starting ...                                  context=vm
> Starting the instance "colima" with VM driver "qemu"
> [hostagent] hostagent socket created at /home/diego/.colima/_lima/colima/ha.sock
> [hostagent] Using system firmware ("/home/linuxbrew/.linuxbrew/share/qemu/edk2-x86_64-code.fd")
> [hostagent] Starting QEMU (hint: to watch the boot progress, see "/home/diego/.colima/_lima/colima/serial*.log")
> SSH Local Port: 44185
> [hostagent] Waiting for the essential requirement 1 of 4: "ssh"
INFO[0000] starting ...                                  context=vm
INFO[0021] provisioning ...                              context=docker
INFO[0021] starting ...                                  context=docker
INFO[0024] done                                         
```

```bash
colima status
```
```
INFO[0000] colima is running using QEMU                 
INFO[0000] arch: x86_64                                 
INFO[0000] runtime: docker                              
INFO[0000] mountType: sshfs                             
INFO[0000] socket: unix:///home/diego/.colima/default/docker.sock 
```

### Use with docker

List docker contexts
```bash
docker context list
```

```
❯ docker context list

NAME       DESCRIPTION                               DOCKER ENDPOINT                                  ERROR
colima *   colima                                    unix:///home/diego/.colima/default/docker.sock   
default    Current DOCKER_HOST based configuration   unix:///var/run/docker.sock   
```

Switch to Colima
```bash
docker context use colima
```
```
❯ docker context use colima
colima
Current context is now "colima"
```

Run with docker
```bash
docker run --rm grycap/cowsay
```

```
❯ docker run --rm grycap/cowsay
 _______________________________________
/ Last night the power went out. Good   \
| thing my camera had a flash.... The   |
| neighbors thought it was lightning in |
| my house, so they called the cops.    |
|                                       |
\ -- Steven Wright                      /
 ---------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

```

### Stop Colima

```bash
colima stop
```
```
❯ colima stop
INFO[0000] stopping colima                              
INFO[0000] stopping ...                                  context=docker
INFO[0001] stopping ...                                  context=vm
INFO[0002] done                                         
```