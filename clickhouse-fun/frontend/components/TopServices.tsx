"use client";

import { useState } from "react";
import { useApi, type TopService } from "../lib/api";
import { niceMax } from "../lib/chart";
import { formatNumber } from "../lib/format";
import { METRIC_UNITS, serviceColor } from "../lib/palette";
import MetricPicker from "./MetricPicker";

export default function TopServices({ minutes }: { minutes: number }) {
  const [metric, setMetric] = useState("latency_ms");
  const [hover, setHover] = useState<string | null>(null);
  const { data, error } = useApi<TopService[]>(`/api/top?metric=${metric}&minutes=${minutes}&limit=5`);
  const unit = METRIC_UNITS[metric] ?? "";
  const ceiling = niceMax(Math.max(0, ...(data ?? []).map((d) => d.p95)));

  return (
    <section>
      <div className="toolbar">
        <MetricPicker value={metric} onChange={setMetric} />
        <span className="muted">Services ranked by p95</span>
      </div>
      {error && <p className="error">{error}</p>}
      {data && data.length === 0 && <p className="empty">No samples in this window. Run ./generate-data.sh</p>}
      <div className="bars">
        {data?.map((d) => (
          <div key={d.service} className="bar-row" onMouseEnter={() => setHover(d.service)} onMouseLeave={() => setHover(null)}>
            <span className="bar-label">{d.service}</span>
            <div className="bar-track">
              <div className="bar" style={{ width: `${(d.p95 / ceiling) * 100}%`, background: serviceColor(d.service) }} />
              {hover === d.service && (
                <div className="tooltip bar-tooltip">
                  <strong>{d.service}</strong>
                  <div className="tooltip-row"><span>avg</span><span className="num">{formatNumber(d.avg)} {unit}</span></div>
                  <div className="tooltip-row"><span>p95</span><span className="num">{formatNumber(d.p95)} {unit}</span></div>
                  <div className="tooltip-row"><span>max</span><span className="num">{formatNumber(d.max)} {unit}</span></div>
                </div>
              )}
            </div>
            <span className="bar-value num">{formatNumber(d.p95)} {unit}</span>
          </div>
        ))}
      </div>
      {data && data.length > 0 && (
        <div className="table-wrap">
          <table>
            <thead>
              <tr>
                <th>#</th>
                <th>Service</th>
                <th className="num">Avg</th>
                <th className="num">p95</th>
                <th className="num">Max</th>
                <th className="num">Samples</th>
              </tr>
            </thead>
            <tbody>
              {data.map((d, i) => (
                <tr key={d.service}>
                  <td>{i + 1}</td>
                  <td>{d.service}</td>
                  <td className="num">{formatNumber(d.avg)}</td>
                  <td className="num">{formatNumber(d.p95)}</td>
                  <td className="num">{formatNumber(d.max)}</td>
                  <td className="num">{formatNumber(d.samples)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </section>
  );
}
