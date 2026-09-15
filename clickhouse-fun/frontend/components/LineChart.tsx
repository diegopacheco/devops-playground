"use client";

import { useState } from "react";
import type { Series } from "../lib/api";
import { linePath, nearestIndex, niceMax, scale, ticks } from "../lib/chart";
import { formatNumber, formatTime } from "../lib/format";
import { serviceColor } from "../lib/palette";

const W = 900;
const H = 320;
const PAD = { top: 12, right: 16, bottom: 28, left: 56 };

export default function LineChart({ series, unit }: { series: Series[]; unit: string }) {
  const [hoverT, setHoverT] = useState<number | null>(null);
  const all = series.flatMap((s) => s.points);
  if (all.length === 0) return <p className="empty">No samples in this window. Run ./generate-data.sh</p>;

  const tMin = Math.min(...all.map((p) => p.t));
  const tMax = Math.max(...all.map((p) => p.t));
  const vMax = niceMax(Math.max(...all.map((p) => p.v)));
  const x = scale(tMin, tMax, PAD.left, W - PAD.right);
  const y = scale(0, vMax, H - PAD.bottom, PAD.top);
  const t = scale(PAD.left, W - PAD.right, tMin, tMax);

  const onMove = (e: React.MouseEvent<SVGRectElement>) => {
    const rect = e.currentTarget.ownerSVGElement!.getBoundingClientRect();
    setHoverT(t(((e.clientX - rect.left) / rect.width) * W));
  };

  const reference = series[0].points;
  const idx = hoverT === null ? -1 : nearestIndex(reference, hoverT);
  const snapped = idx >= 0 ? reference[idx].t : null;
  const hovered =
    snapped === null
      ? []
      : series
          .map((s) => ({ service: s.service, point: s.points[nearestIndex(s.points, snapped)] }))
          .sort((a, b) => b.point.v - a.point.v);

  return (
    <div className="chart">
      <ul className="legend">
        {series.map((s) => (
          <li key={s.service}>
            <span className="swatch" style={{ background: serviceColor(s.service) }} />
            {s.service}
          </li>
        ))}
      </ul>
      <div className="plot">
        <svg viewBox={`0 0 ${W} ${H}`} role="img" aria-label={`line chart in ${unit}`}>
          {ticks(vMax, 4).map((v) => (
            <g key={v}>
              <line className="grid" x1={PAD.left} x2={W - PAD.right} y1={y(v)} y2={y(v)} />
              <text className="axis" x={PAD.left - 8} y={y(v) + 4} textAnchor="end">
                {formatNumber(v)}
              </text>
            </g>
          ))}
          {[tMin, (tMin + tMax) / 2, tMax].map((v, i) => (
            <text key={i} className="axis" x={x(v)} y={H - 8} textAnchor={i === 0 ? "start" : i === 2 ? "end" : "middle"}>
              {formatTime(v)}
            </text>
          ))}
          {series.map((s) => (
            <path key={s.service} d={linePath(s.points, x, y)} fill="none" stroke={serviceColor(s.service)} strokeWidth={2} strokeLinejoin="round" />
          ))}
          {snapped !== null && (
            <g>
              <line className="crosshair" x1={x(snapped)} x2={x(snapped)} y1={PAD.top} y2={H - PAD.bottom} />
              {hovered.map((h) => (
                <circle key={h.service} cx={x(h.point.t)} cy={y(h.point.v)} r={4} fill={serviceColor(h.service)} stroke="var(--surface)" strokeWidth={2} />
              ))}
            </g>
          )}
          <rect x={PAD.left} y={PAD.top} width={W - PAD.left - PAD.right} height={H - PAD.top - PAD.bottom} fill="transparent" onMouseMove={onMove} onMouseLeave={() => setHoverT(null)} />
        </svg>
        {snapped !== null && (
          <div className="tooltip" style={{ left: `${(x(snapped) / W) * 100}%` }}>
            <strong>{formatTime(snapped)}</strong>
            {hovered.map((h) => (
              <div key={h.service} className="tooltip-row">
                <span className="swatch" style={{ background: serviceColor(h.service) }} />
                <span>{h.service}</span>
                <span className="num">
                  {formatNumber(h.point.v)} {unit}
                </span>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
