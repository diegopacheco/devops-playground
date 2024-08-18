### Step by Step commands

0. Install localstack cli

```
brew install localstack/tap/localstack-cli
```

1. Install AWS CLI wrapper for localstack

```
pip install awscli-local
```

2. Run localstack

option A: Run localstack with localstack cli

```
DNS_ADDRESS=0 localstack start
```

option B: Run localstack with docker
```
docker run \
  --rm -it \
  -p 127.0.0.1:4566:4566 \
  -p 127.0.0.1:4510-4559:4510-4559 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  localstack/localstack
```

3. Create SQS Queue

```
awslocal sqs create-queue --queue-name localstack-queue
```
```
❯ awslocal sqs create-queue --queue-name localstack-queue
{
    "QueueUrl": "http://localhost:4566/000000000000/localstack-queue"
}
```

4. List Queues

```
awslocal sqs list-queues
```

```
❯ awslocal sqs list-queues
{
    "QueueUrls": [
        "http://localhost:4566/000000000000/localstack-queue"
    ]
}
```

5. Send message to SQS Queue

```
awslocal sqs send-message --queue-url http://localhost:4566/000000000000/localstack-queue --message-body "Hello World"

```
```
❯ awslocal sqs send-message --queue-url http://localhost:4566/000000000000/localstack-queue --message-body "Hello World"
{
    "MD5OfMessageBody": "b10a8db164e0754105b7a99be72e3fe5", 
    "MessageId": "ba234d2a-5c1b-2dd4-141a-c76094920f73"
}
```

6. Receive message from SQS Queue

```
awslocal sqs receive-message --queue-url http://localhost:4566/000000000000/localstack-queue
```

```
❯ awslocal sqs receive-message --queue-url http://localhost:4566/000000000000/localstack-queue
{
    "Messages": [
        {
            "Body": "Hello World", 
            "ReceiptHandle": "xxjpkcsuvmwwlcuwjohrngkifjwrhvusxqnqzjknzeyedejbbuheikimiblxsqgmhislrlpgpbhftxdxwiwcalghpsfglnwfefnwepatjajwzesnztywoyzdvbinepmgfslcqyimxqulzxkpqjiqpwjntaarxzwuifhoucszxjljeltyhfjtylmuw", 
            "MD5OfBody": "b10a8db164e0754105b7a99be72e3fe5", 
            "MessageId": "ba234d2a-5c1b-2dd4-141a-c76094920f73"
        }
    ]
}
```

7. Query API

```
curl "http://localhost:4566/000000000000/localstack-queue?Action=SendMessage&MessageBody=hello%2Fworld"
```

```
❯ curl "http://localhost:4566/000000000000/localstack-queue?Action=SendMessage&MessageBody=hello%2Fworld"


<SendMessageResponse><SendMessageResult><MD5OfMessageBody>c6be4e95a26409675447367b3e79f663</MD5OfMessageBody><MessageId>3f3a31a5-8381-c511-00e7-40d45fc1cd5e</MessageId></SendMessageResult><ResponseMetadata><RequestId>S7Y824U0JITG5EEEG7DG6JUDAMTSNUEQ6TG4EM0ZNXYDAG578Z6S</RequestId></ResponseMetadata></SendMessageResponse>%
```