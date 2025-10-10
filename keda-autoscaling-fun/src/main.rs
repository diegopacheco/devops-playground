use actix_web::{web, App, HttpResponse, HttpServer};
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::Arc;
use std::time::Duration;
use tokio::time::sleep;

struct AppState {
    counter: AtomicU64,
}

async fn health() -> HttpResponse {
    HttpResponse::Ok().body("OK")
}

async fn stress(data: web::Data<Arc<AppState>>) -> HttpResponse {
    let count = data.counter.fetch_add(1, Ordering::SeqCst);
    sleep(Duration::from_secs(2)).await;
    let mut result = 0u64;
    for i in 0..5000000 {
        result = result.wrapping_add(i).wrapping_mul(i);
    }
    HttpResponse::Ok().body(format!("Request {} processed: {}", count, result))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let state = Arc::new(AppState {
        counter: AtomicU64::new(0),
    });

    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(state.clone()))
            .route("/health", web::get().to(health))
            .route("/stress", web::get().to(stress))
    })
    .bind("0.0.0.0:8080")?
    .run()
    .await
}
