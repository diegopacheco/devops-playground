#!/bin/bash
podman stop ministack 2>/dev/null
podman rm -f ministack 2>/dev/null
podman run -d --name ministack -p 4566:4566 \
  -e SERVICES=secretsmanager,sqs,s3,sts,kinesis,rds \
  -v /var/run/docker.sock:/var/run/docker.sock \
  nahuelnucera/ministack
while ! curl -s http://localhost:4566/_localstack/health > /dev/null 2>&1; do
  sleep 1
done
echo "Ministack is ready"
./provision.sh
