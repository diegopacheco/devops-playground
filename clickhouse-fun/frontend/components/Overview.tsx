"use client";

import { useApi, type Stats, type Summary } from "../lib/api";
import { formatBytes, formatNumber, formatRatio } from "../lib/format";
import { METRIC_UNITS } from "../lib/palette";

export default function Overview({ minutes }: { minutes: number }) {
  const stats = useApi<Stats>("/api/stats");
  const summary = useApi<Summary[]>(`/api/summary?minutes=${minutes}`);
  const s = stats.data;

  return (
    <section>
      <div className="tiles">
        <Tile label="Rows stored" value={s ? formatNumber(s.rows) : "-"} />
        <Tile label="Compressed on disk" value={s ? formatBytes(s.compressed_bytes) : "-"} />
        <Tile label="Uncompressed" value={s ? formatBytes(s.uncompressed_bytes) : "-"} />
        <Tile label="Compression ratio" value={s ? formatRatio(s.uncompressed_bytes, s.compressed_bytes) : "-"} />
        <Tile label="Active parts" value={s ? String(s.parts) : "-"} />
      </div>
      {s && s.rows > 0 && (
        <p className="muted">
          Data from {s.first_ts} to {s.last_ts} UTC. Windows are anchored to the newest sample.
        </p>
      )}
      <h2>Metrics in the window</h2>
      {summary.error && <p className="error">{summary.error}</p>}
      <div className="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Metric</th>
              <th className="num">Samples</th>
              <th className="num">Avg</th>
              <th className="num">Min</th>
              <th className="num">Max</th>
              <th className="num">p95</th>
            </tr>
          </thead>
          <tbody>
            {summary.data?.map((m) => (
              <tr key={m.metric}>
                <td>
                  {m.metric} <span className="unit">{METRIC_UNITS[m.metric]}</span>
                </td>
                <td className="num">{formatNumber(m.samples)}</td>
                <td className="num">{formatNumber(m.avg)}</td>
                <td className="num">{formatNumber(m.min)}</td>
                <td className="num">{formatNumber(m.max)}</td>
                <td className="num">{formatNumber(m.p95)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </section>
  );
}

function Tile({ label, value }: { label: string; value: string }) {
  return (
    <div className="tile">
      <span className="tile-label">{label}</span>
      <span className="tile-value">{value}</span>
    </div>
  );
}
