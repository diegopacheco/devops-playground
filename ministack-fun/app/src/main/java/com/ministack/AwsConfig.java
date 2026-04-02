package com.ministack;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.secretsmanager.SecretsManagerClient;
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.S3Configuration;
import software.amazon.awssdk.services.sts.StsClient;
import software.amazon.awssdk.services.kinesis.KinesisClient;
import software.amazon.awssdk.services.rds.RdsClient;
import java.net.URI;

@Configuration
public class AwsConfig {

    private static final URI ENDPOINT = URI.create("http://localhost:4566");
    private static final Region REGION = Region.US_EAST_1;

    private StaticCredentialsProvider credentials() {
        return StaticCredentialsProvider.create(
                AwsBasicCredentials.create("test", "test")
        );
    }

    @Bean
    public SecretsManagerClient secretsManagerClient() {
        return SecretsManagerClient.builder()
                .endpointOverride(ENDPOINT)
                .region(REGION)
                .credentialsProvider(credentials())
                .build();
    }

    @Bean
    public SqsClient sqsClient() {
        return SqsClient.builder()
                .endpointOverride(ENDPOINT)
                .region(REGION)
                .credentialsProvider(credentials())
                .build();
    }

    @Bean
    public S3Client s3Client() {
        return S3Client.builder()
                .endpointOverride(ENDPOINT)
                .region(REGION)
                .credentialsProvider(credentials())
                .serviceConfiguration(S3Configuration.builder()
                        .pathStyleAccessEnabled(true)
                        .build())
                .build();
    }

    @Bean
    public StsClient stsClient() {
        return StsClient.builder()
                .endpointOverride(ENDPOINT)
                .region(REGION)
                .credentialsProvider(credentials())
                .build();
    }

    @Bean
    public KinesisClient kinesisClient() {
        return KinesisClient.builder()
                .endpointOverride(ENDPOINT)
                .region(REGION)
                .credentialsProvider(credentials())
                .build();
    }

    @Bean
    public RdsClient rdsClient() {
        return RdsClient.builder()
                .endpointOverride(ENDPOINT)
                .region(REGION)
                .credentialsProvider(credentials())
                .build();
    }

}
