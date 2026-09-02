use iggy::prelude::*;
use iggy_poc::{CONSUMER_GROUP, PARTITIONS, STREAM, TOPIC, connection_string, message_count, order};

#[tokio::main]
async fn main() -> Result<(), IggyError> {
    let client = IggyClient::from_connection_string(&connection_string())?;
    client.connect().await?;

    let producer = client
        .producer(STREAM, TOPIC)?
        .create_stream_if_not_exists()
        .create_topic_if_not_exists(
            PARTITIONS,
            None,
            IggyExpiry::NeverExpire,
            MaxTopicSize::ServerDefault,
        )
        .build();
    producer.init().await?;

    let total = message_count();
    println!("producer sending {total} messages to {STREAM}/{TOPIC} ({PARTITIONS} partitions)");

    for id in 1..=total {
        let payload = order(id);
        producer.send_one(IggyMessage::from(payload.as_str())).await?;
        println!("sent {payload}");
    }

    producer.shutdown().await;
    println!("producer sent {total} messages, consumer group {CONSUMER_GROUP} can read them");
    Ok(())
}
