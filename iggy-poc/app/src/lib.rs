use std::env;

pub const STREAM: &str = "orders";
pub const TOPIC: &str = "placed";
pub const CONSUMER_GROUP: &str = "billing";
pub const PARTITIONS: u32 = 3;

pub fn connection_string() -> String {
    env::var("IGGY_CONNECTION_STRING").unwrap_or_else(|_| "iggy://iggy:iggy@localhost:8090".into())
}

pub fn message_count() -> u32 {
    env::var("IGGY_MESSAGE_COUNT")
        .ok()
        .and_then(|value| value.parse().ok())
        .unwrap_or(20)
}

pub fn order(id: u32) -> String {
    format!(
        r#"{{"order_id":{id},"customer":"customer-{customer}","amount":{amount}.99}}"#,
        customer = id % 5,
        amount = 10 + id
    )
}

#[cfg(test)]
mod tests {
    use super::order;

    #[test]
    fn order_payload_carries_the_fields_the_consumer_prints() {
        assert_eq!(
            order(7),
            r#"{"order_id":7,"customer":"customer-2","amount":17.99}"#
        );
    }
}
