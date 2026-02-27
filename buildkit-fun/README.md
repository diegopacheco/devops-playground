# buildkit

https://github.com/moby/buildkit

## Install

```bash
brew install buildkit
```

## Run

```
./build.sh
./run.sh
```

## Result

```
❯ ./build.sh
Building with BuildKit (oci image tar.gz)...
[+] Building 0.3s (7/7) FINISHED
 => [internal] load build definition from Containerfile                                                                       0.0s
 => => transferring dockerfile: 190B                                                                                          0.0s
 => [internal] load metadata for docker.io/library/alpine:3.21                                                                0.2s
 => [internal] load .dockerignore                                                                                             0.0s
 => => transferring context: 2B                                                                                               0.0s
 => [1/3] FROM docker.io/library/alpine:3.21@sha256:c3f8e73fdb79deaebaa2037150150191b9dcbfba68b4a46d70103204c53f4709          0.0s
 => => resolve docker.io/library/alpine:3.21@sha256:c3f8e73fdb79deaebaa2037150150191b9dcbfba68b4a46d70103204c53f4709          0.0s
 => CACHED [2/3] RUN apk add --no-cache curl bash                                                                             0.0s
 => CACHED [3/3] RUN echo "Hello from BuildKit POC!" > /hello.txt                                                             0.0s
 => exporting to oci image format                                                                                             0.1s
 => => exporting layers                                                                                                       0.0s
 => => exporting manifest sha256:9766938d8b04ed44698e972f5f5f4ce1d0e33c41c99d37d88a005dd8b7fc0b59                             0.0s
 => => exporting config sha256:5345d7cfa97d9b9134e51f33154136debb760c64880826c833adf1ae7214c016                               0.0s
 => => sending tarball                                                                                                        0.1s
rBuild complete: buildkit-output.tar.gz
-rw-rw-rw-@ 1 diegopacheco  staff   6.8M Feb 26 19:57 buildkit-output.tar.gz
❯ ./run.sh
Loading tar.gz into podman...
Loaded image: sha256:5345d7cfa97d9b9134e51f33154136debb760c64880826c833adf1ae7214c016
Running container with podman...
Hello from BuildKit POC!
```