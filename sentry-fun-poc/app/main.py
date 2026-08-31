import os
import random
import time

import sentry_sdk
from sentry_sdk import logger, metrics

SKUS = ["SKU-CAFE", "SKU-MATE", "SKU-CHIMARRAO"]


def init():
    dsn = os.environ.get("SENTRY_DSN", "").strip()
    if not dsn:
        raise SystemExit("SENTRY_DSN is empty, run ./start.sh first")

    sentry_sdk.init(
        dsn=dsn,
        environment=os.environ.get("SENTRY_ENVIRONMENT", "poc"),
        release=os.environ.get("SENTRY_RELEASE", "sentry-fun-poc@1.0.0"),
        traces_sample_rate=1.0,
        enable_logs=True,
        enable_metrics=True,
        send_default_pii=True,
        shutdown_timeout=30,
    )
    print("sentry initialized against " + dsn.split("@")[-1])


def emit_logs(order_id, sku):
    logger.info("checkout started for order {order_id}", order_id=order_id)
    logger.warning("stock is low for {sku}", sku=sku)
    logger.error("payment gateway rejected order {order_id}", order_id=order_id)


def emit_metrics(sku, latency_ms, cart_size):
    metrics.count("checkout.attempt", 1, attributes={"sku": sku})
    metrics.gauge("checkout.cart_size", cart_size, unit="item", attributes={"sku": sku})
    metrics.distribution(
        "checkout.latency", latency_ms, unit="millisecond", attributes={"sku": sku}
    )


def charge(order_id, amount):
    if amount > 100:
        raise ValueError("card declined for order %s at amount %.2f" % (order_id, amount))
    return "charged"


def checkout(order_id):
    sku = random.choice(SKUS)
    cart_size = random.randint(1, 8)
    amount = round(random.uniform(50, 150), 2)

    with sentry_sdk.start_transaction(op="task", name="checkout") as tx:
        tx.set_tag("sku", sku)
        sentry_sdk.set_context("order", {"id": order_id, "sku": sku, "amount": amount})

        started = time.monotonic()
        emit_logs(order_id, sku)

        with sentry_sdk.start_span(op="db.query", name="load-cart"):
            time.sleep(random.uniform(0.01, 0.05))

        with sentry_sdk.start_span(op="http.client", name="charge-card"):
            try:
                charge(order_id, amount)
                logger.info("order {order_id} paid", order_id=order_id)
            except ValueError as error:
                sentry_sdk.capture_exception(error)
                print("captured exception for order %s" % order_id)

        latency_ms = (time.monotonic() - started) * 1000
        emit_metrics(sku, latency_ms, cart_size)

    return latency_ms


def main():
    init()
    sentry_sdk.capture_message("sentry-fun-poc run started", level="info")

    runs = int(os.environ.get("RUNS", "5"))
    for index in range(runs):
        order_id = "ORD-%04d" % (index + 1)
        latency_ms = checkout(order_id)
        print("order %s done in %.1fms" % (order_id, latency_ms))

    sentry_sdk.flush(timeout=30)
    print("flushed %d checkouts to sentry" % runs)


if __name__ == "__main__":
    main()
