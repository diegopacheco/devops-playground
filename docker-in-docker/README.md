### Result

```bash

  1. Can you run docker inside docker?
  Yes, absolutely. That's exactly what this POC demonstrates.

  2. Does this prove docker is running inside docker?
  Yes, it definitively proves it. Here's the evidence:

  The flow is:
  Host (podman)
    └─> dind-poc container (Docker daemon running)
         └─> hello-world container (runs inside the Docker daemon)

  Key proof points from your output:

  1. run.sh output shows Docker daemon running inside a container:
    - Operating System: Alpine Linux v3.22 (containerized) - confirms it's in a container
    - Name: bd325d095344 - the container hostname
    - The command podman exec dind-poc docker info executes docker info INSIDE the dind-poc container
  2. test.sh output shows a container running inside that Docker daemon:
    - podman exec dind-poc docker run --rm hello-world pulls and runs hello-world
    - The Docker daemon inside dind-poc pulled the image from Docker Hub
    - The Docker daemon inside dind-poc created and ran the hello-world container
    - You got the "Hello from Docker!" message from a container running in the nested Docker

  This is a working three-layer nested containerization proving Docker-in-Docker works perfectly.
```