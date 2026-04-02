package com.ministack;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import software.amazon.awssdk.core.SdkBytes;
import software.amazon.awssdk.services.secretsmanager.SecretsManagerClient;
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueRequest;
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueResponse;
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.SendMessageRequest;
import software.amazon.awssdk.services.sqs.model.SendMessageResponse;
import software.amazon.awssdk.services.sqs.model.GetQueueUrlRequest;
import software.amazon.awssdk.services.sqs.model.GetQueueAttributesRequest;
import software.amazon.awssdk.services.sqs.model.QueueAttributeName;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.ListObjectsV2Request;
import software.amazon.awssdk.services.s3.model.ListObjectsV2Response;
import software.amazon.awssdk.services.s3.model.S3Object;
import software.amazon.awssdk.services.sts.StsClient;
import software.amazon.awssdk.services.sts.model.GetCallerIdentityResponse;
import software.amazon.awssdk.services.kinesis.KinesisClient;
import software.amazon.awssdk.services.kinesis.model.DescribeStreamRequest;
import software.amazon.awssdk.services.kinesis.model.DescribeStreamResponse;
import software.amazon.awssdk.services.kinesis.model.PutRecordRequest;
import software.amazon.awssdk.services.kinesis.model.PutRecordResponse;
import software.amazon.awssdk.services.rds.RdsClient;
import software.amazon.awssdk.services.rds.model.DescribeDbInstancesResponse;
import software.amazon.awssdk.services.rds.model.DBInstance;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
public class StatusController {

    private final SecretsManagerClient secretsManager;
    private final SqsClient sqs;
    private final S3Client s3;
    private final StsClient sts;
    private final KinesisClient kinesis;
    private final RdsClient rds;

    public StatusController(SecretsManagerClient secretsManager,
                            SqsClient sqs,
                            S3Client s3,
                            StsClient sts,
                            KinesisClient kinesis,
                            RdsClient rds) {
        this.secretsManager = secretsManager;
        this.sqs = sqs;
        this.s3 = s3;
        this.sts = sts;
        this.kinesis = kinesis;
        this.rds = rds;
    }

    @GetMapping("/status")
    public Map<String, Object> status() {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("sts", getSts());
        result.put("secretsManager", getSecrets());
        result.put("sqs", getSqs());
        result.put("s3", getS3());
        result.put("kinesis", getKinesis());
        result.put("rds", getRds());
        return result;
    }

    private Map<String, Object> getSts() {
        Map<String, Object> info = new LinkedHashMap<>();
        try {
            GetCallerIdentityResponse resp = sts.getCallerIdentity();
            info.put("status", "OK");
            info.put("account", resp.account());
            info.put("arn", resp.arn());
            info.put("userId", resp.userId());
        } catch (Exception e) {
            info.put("status", "ERROR");
            info.put("error", e.getMessage());
        }
        return info;
    }

    private Map<String, Object> getSecrets() {
        Map<String, Object> info = new LinkedHashMap<>();
        try {
            GetSecretValueResponse resp = secretsManager.getSecretValue(
                    GetSecretValueRequest.builder()
                            .secretId("ministack/app-config")
                            .build()
            );
            info.put("status", "OK");
            info.put("configName", resp.name());
            info.put("configValue", resp.secretString());
        } catch (Exception e) {
            info.put("status", "ERROR");
            info.put("error", e.getMessage());
        }
        return info;
    }

    private Map<String, Object> getSqs() {
        Map<String, Object> info = new LinkedHashMap<>();
        try {
            String queueUrl = sqs.getQueueUrl(
                    GetQueueUrlRequest.builder()
                            .queueName("ministack-app-queue")
                            .build()
            ).queueUrl();
            SendMessageResponse sendResp = sqs.sendMessage(
                    SendMessageRequest.builder()
                            .queueUrl(queueUrl)
                            .messageBody("{\"event\":\"status-check\",\"timestamp\":\"" + System.currentTimeMillis() + "\"}")
                            .build()
            );
            Map<String, String> attrs = sqs.getQueueAttributes(
                    GetQueueAttributesRequest.builder()
                            .queueUrl(queueUrl)
                            .attributeNames(QueueAttributeName.APPROXIMATE_NUMBER_OF_MESSAGES)
                            .build()
            ).attributesAsStrings();
            info.put("status", "OK");
            info.put("queueUrl", queueUrl);
            info.put("messageId", sendResp.messageId());
            info.put("approximateMessages", attrs.get("ApproximateNumberOfMessages"));
        } catch (Exception e) {
            info.put("status", "ERROR");
            info.put("error", e.getMessage());
        }
        return info;
    }

    private Map<String, Object> getS3() {
        Map<String, Object> info = new LinkedHashMap<>();
        try {
            ListObjectsV2Response listResp = s3.listObjectsV2(
                    ListObjectsV2Request.builder()
                            .bucket("ministack-app-bucket")
                            .build()
            );
            List<String> keys = listResp.contents().stream()
                    .map(S3Object::key)
                    .toList();
            String content = s3.getObjectAsBytes(
                    GetObjectRequest.builder()
                            .bucket("ministack-app-bucket")
                            .key("data/sample.json")
                            .build()
            ).asString(StandardCharsets.UTF_8);
            info.put("status", "OK");
            info.put("bucket", "ministack-app-bucket");
            info.put("objectCount", listResp.keyCount());
            info.put("keys", keys);
            info.put("sampleContent", content);
        } catch (Exception e) {
            info.put("status", "ERROR");
            info.put("error", e.getMessage());
        }
        return info;
    }

    private Map<String, Object> getKinesis() {
        Map<String, Object> info = new LinkedHashMap<>();
        try {
            DescribeStreamResponse desc = kinesis.describeStream(
                    DescribeStreamRequest.builder()
                            .streamName("ministack-app-stream")
                            .build()
            );
            PutRecordResponse putResp = kinesis.putRecord(
                    PutRecordRequest.builder()
                            .streamName("ministack-app-stream")
                            .partitionKey("test-key")
                            .data(SdkBytes.fromString("hello-ministack", StandardCharsets.UTF_8))
                            .build()
            );
            info.put("status", "OK");
            info.put("streamName", desc.streamDescription().streamName());
            info.put("streamStatus", desc.streamDescription().streamStatusAsString());
            info.put("shardCount", desc.streamDescription().shards().size());
            info.put("putRecordSequence", putResp.sequenceNumber());
        } catch (Exception e) {
            info.put("status", "ERROR");
            info.put("error", e.getMessage());
        }
        return info;
    }

    private Map<String, Object> getRds() {
        Map<String, Object> info = new LinkedHashMap<>();
        try {
            DescribeDbInstancesResponse resp = rds.describeDBInstances();
            List<DBInstance> instances = resp.dbInstances();
            info.put("status", "OK");
            info.put("instanceCount", instances.size());
            if (!instances.isEmpty()) {
                DBInstance db = instances.getFirst();
                info.put("instanceId", db.dbInstanceIdentifier());
                info.put("engine", db.engine());
                info.put("dbName", db.dbName());
                info.put("instanceStatus", db.dbInstanceStatus());
                info.put("endpoint", db.endpoint() != null ? db.endpoint().address() + ":" + db.endpoint().port() : "pending");
            }
        } catch (Exception e) {
            info.put("status", "ERROR");
            info.put("error", e.getMessage());
        }
        return info;
    }

}
