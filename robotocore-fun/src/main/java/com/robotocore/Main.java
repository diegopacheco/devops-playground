package com.robotocore;

import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.core.SdkBytes;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.lambda.LambdaClient;
import software.amazon.awssdk.services.lambda.model.InvokeRequest;
import software.amazon.awssdk.services.lambda.model.InvokeResponse;
import software.amazon.awssdk.services.opensearch.OpenSearchClient;
import software.amazon.awssdk.services.opensearch.model.DescribeDomainRequest;
import software.amazon.awssdk.services.opensearch.model.DescribeDomainResponse;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.S3Configuration;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.ListBucketsResponse;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.secretsmanager.SecretsManagerClient;
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueRequest;
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueResponse;
import software.amazon.awssdk.services.sns.SnsClient;
import software.amazon.awssdk.services.sns.model.ListTopicsResponse;
import software.amazon.awssdk.services.sns.model.PublishRequest;
import software.amazon.awssdk.services.sns.model.PublishResponse;
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.GetQueueUrlRequest;
import software.amazon.awssdk.services.sqs.model.ReceiveMessageRequest;
import software.amazon.awssdk.services.sqs.model.ReceiveMessageResponse;
import software.amazon.awssdk.services.sqs.model.SendMessageRequest;

import java.net.URI;
import java.nio.charset.StandardCharsets;

public class Main {

    private static final URI ENDPOINT = URI.create("http://localhost:4566");
    private static final Region REGION = Region.US_EAST_1;
    private static final StaticCredentialsProvider CREDS = StaticCredentialsProvider.create(
            AwsBasicCredentials.create("123456789012", "test")
    );

    public static void main(String[] args) {
        System.out.println("=== Robotocore Java 25 POC ===\n");

        int passed = 0;
        int failed = 0;

        if (runTest("S3", Main::testS3)) passed++; else failed++;
        if (runTest("SQS", Main::testSQS)) passed++; else failed++;
        if (runTest("SNS", Main::testSNS)) passed++; else failed++;
        if (runTest("Lambda", Main::testLambda)) passed++; else failed++;
        if (runTest("OpenSearch", Main::testOpenSearch)) passed++; else failed++;
        if (runTest("Secrets Manager", Main::testSecretsManager)) passed++; else failed++;

        System.out.println("\n=== Results: " + passed + " passed, " + failed + " failed ===");
    }

    private static boolean runTest(String name, Runnable test) {
        System.out.println("--- " + name + " ---");
        try {
            test.run();
            System.out.println("PASS\n");
            return true;
        } catch (Exception e) {
            System.out.println("FAIL: " + e.getMessage() + "\n");
            return false;
        }
    }

    private static void testS3() {
        try (S3Client s3 = S3Client.builder()
                .endpointOverride(ENDPOINT)
                .region(REGION)
                .credentialsProvider(CREDS)
                .serviceConfiguration(S3Configuration.builder().pathStyleAccessEnabled(true).build())
                .build()) {

            ListBucketsResponse buckets = s3.listBuckets();
            System.out.println("Buckets: " + buckets.buckets().stream().map(b -> b.name()).toList());

            s3.putObject(
                    PutObjectRequest.builder().bucket("my-data-bucket").key("hello.txt").build(),
                    RequestBody.fromString("Hello from Java 25!")
            );
            System.out.println("PUT object: hello.txt");

            byte[] data = s3.getObjectAsBytes(
                    GetObjectRequest.builder().bucket("my-data-bucket").key("hello.txt").build()
            ).asByteArray();
            System.out.println("GET object: " + new String(data, StandardCharsets.UTF_8));
        }
    }

    private static void testSQS() {
        try (SqsClient sqs = SqsClient.builder()
                .endpointOverride(ENDPOINT)
                .region(REGION)
                .credentialsProvider(CREDS)
                .build()) {

            String queueUrl = sqs.getQueueUrl(
                    GetQueueUrlRequest.builder().queueName("my-queue").build()
            ).queueUrl();
            System.out.println("Queue URL: " + queueUrl);

            sqs.sendMessage(SendMessageRequest.builder()
                    .queueUrl(queueUrl)
                    .messageBody("Hello from Java 25 via SQS!")
                    .build());
            System.out.println("Sent message to queue");

            ReceiveMessageResponse response = sqs.receiveMessage(
                    ReceiveMessageRequest.builder().queueUrl(queueUrl).maxNumberOfMessages(1).build()
            );
            response.messages().forEach(m -> System.out.println("Received: " + m.body()));
        }
    }

    private static void testSNS() {
        try (SnsClient sns = SnsClient.builder()
                .endpointOverride(ENDPOINT)
                .region(REGION)
                .credentialsProvider(CREDS)
                .build()) {

            ListTopicsResponse topics = sns.listTopics();
            String topicArn = topics.topics().stream()
                    .filter(t -> t.topicArn().contains("my-topic"))
                    .findFirst()
                    .orElseThrow()
                    .topicArn();
            System.out.println("Topic ARN: " + topicArn);

            PublishResponse pub = sns.publish(PublishRequest.builder()
                    .topicArn(topicArn)
                    .message("Hello from Java 25 via SNS!")
                    .build());
            System.out.println("Published message ID: " + pub.messageId());
        }
    }

    private static void testLambda() {
        try (LambdaClient lambda = LambdaClient.builder()
                .endpointOverride(ENDPOINT)
                .region(REGION)
                .credentialsProvider(CREDS)
                .build()) {

            InvokeResponse response = lambda.invoke(InvokeRequest.builder()
                    .functionName("my-function")
                    .payload(SdkBytes.fromUtf8String("{\"key\":\"value\"}"))
                    .build());
            System.out.println("Lambda response: " + response.payload().asUtf8String());
        }
    }

    private static void testOpenSearch() {
        try (OpenSearchClient opensearch = OpenSearchClient.builder()
                .endpointOverride(ENDPOINT)
                .region(REGION)
                .credentialsProvider(CREDS)
                .build()) {

            DescribeDomainResponse domain = opensearch.describeDomain(
                    DescribeDomainRequest.builder().domainName("my-search-domain").build()
            );
            System.out.println("Domain: " + domain.domainStatus().domainName());
            System.out.println("Engine: " + domain.domainStatus().engineVersion());
            System.out.println("Endpoint: " + domain.domainStatus().endpoint());
        }
    }

    private static void testSecretsManager() {
        try (SecretsManagerClient sm = SecretsManagerClient.builder()
                .endpointOverride(ENDPOINT)
                .region(REGION)
                .credentialsProvider(CREDS)
                .build()) {

            GetSecretValueResponse secret = sm.getSecretValue(
                    GetSecretValueRequest.builder().secretId("my-secret").build()
            );
            System.out.println("Secret name: " + secret.name());
            System.out.println("Secret value: " + secret.secretString());
        }
    }
}
