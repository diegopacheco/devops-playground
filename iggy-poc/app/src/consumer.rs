use futures_util::StreamExt;
use iggy::prelude::*;
use iggy_poc::{CONSUMER_GROUP, STREAM, TOPIC, connection_string, message_count};

#[tokio::main]
async fn main() -> Result<(), IggyError> {
    let client = IggyClient::from_connection_string(&connection_string())?;
    client.connect().await?;

    let mut consumer = client
        .consumer_group(CONSUMER_GROUP, STREAM, TOPIC)?
        .create_consumer_group_if_not_exists()
        .auto_join_consumer_group()
        .auto_commit(AutoCommit::When(AutoCommitWhen::ConsumingEachMessage))
        .polling_strategy(PollingStrategy::next())
        .init_retries(30, IggyDuration::ONE_SECOND)
        .batch_length(10)
        .build();
    consumer.init().await?;

    let expected = message_count();
    println!("consumer {CONSUMER_GROUP} waiting for {expected} messages on {STREAM}/{TOPIC}");

    let mut received = 0;
    while let Some(message) = consumer.next().await {
        let message = message?;
        received += 1;
        println!(
            "received partition={} offset={} {}",
            message.partition_id,
            message.message.header.offset,
            message.message.payload_as_string()?
        );
        if received == expected {
            break;
        }
    }

    consumer.shutdown().await?;
    println!("consumer received {received} messages");
    Ok(())
}
