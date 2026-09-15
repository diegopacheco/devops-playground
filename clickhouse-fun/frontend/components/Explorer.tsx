"use client";

import { useState } from "react";
import { useApi, type Timeseries } from "../lib/api";
import { formatNumber } from "../lib/format";
import { METRIC_UNITS, serviceColor } from "../lib/palette";
import LineChart from "./LineChart";
import MetricPicker from "./MetricPicker";

export default function Explorer({ minutes }: { minutes: number }) {
  const [metric, setMetric] = useState("latency_ms");
  const { data, error } = useApi<Timeseries>(`/api/timeseries?metric=${metric}&minutes=${minutes}`);
  const unit = METRIC_UNITS[metric] ?? "";

  return (
    <section>
      <div className="toolbar">
        <MetricPicker value={metric} onChange={setMetric} />
        {data && <span className="muted">Average per service, {data.step}s buckets</span>}
      </div>
      {error && <p className="error">{error}</p>}
      {data && <LineChart series={data.series} unit={unit} />}
      {data && data.series.length > 0 && (
        <div className="table-wrap">
          <table>
            <thead>
              <tr>
                <th>Service</th>
                <th className="num">Latest</th>
                <th className="num">Lowest bucket</th>
                <th className="num">Highest bucket</th>
              </tr>
            </thead>
            <tbody>
              {data.series.map((s) => {
                const values = s.points.map((p) => p.v);
                return (
                  <tr key={s.service}>
                    <td>
                      <span className="swatch" style={{ background: serviceColor(s.service) }} />
                      {s.service}
                    </td>
                    <td className="num">{formatNumber(values[values.length - 1])} {unit}</td>
                    <td className="num">{formatNumber(Math.min(...values))} {unit}</td>
                    <td className="num">{formatNumber(Math.max(...values))} {unit}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </section>
  );
}
