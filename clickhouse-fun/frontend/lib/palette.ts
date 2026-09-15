const SERVICES = ["checkout", "payments", "catalog", "search", "auth"];
const COLORS = ["#2a78d6", "#eb6834", "#1baf7a", "#eda100", "#e87ba4"];

export function serviceColor(service: string): string {
  const i = SERVICES.indexOf(service);
  return i >= 0 ? COLORS[i] : "#8a8984";
}

export const METRIC_UNITS: Record<string, string> = {
  cpu_percent: "%",
  memory_mb: "MB",
  latency_ms: "ms",
  requests_per_sec: "req/s",
  errors_per_sec: "err/s",
};

export const WINDOWS = [
  { minutes: 15, label: "15m" },
  { minutes: 60, label: "1h" },
  { minutes: 360, label: "6h" },
  { minutes: 1440, label: "24h" },
];
