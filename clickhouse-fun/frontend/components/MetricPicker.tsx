"use client";

import { useApi, type MetricInfo } from "../lib/api";

export default function MetricPicker({ value, onChange }: { value: string; onChange: (metric: string) => void }) {
  const { data } = useApi<MetricInfo[]>("/api/metrics");
  const metrics = data?.map((m) => m.metric) ?? [value];
  return (
    <label className="picker">
      Metric
      <select value={value} onChange={(e) => onChange(e.target.value)}>
        {metrics.map((m) => (
          <option key={m} value={m}>
            {m}
          </option>
        ))}
      </select>
    </label>
  );
}
