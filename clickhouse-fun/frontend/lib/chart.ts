export type Point = { t: number; v: number };

export function niceMax(value: number): number {
  if (!(value > 0)) return 1;
  const magnitude = Math.pow(10, Math.floor(Math.log10(value)));
  const steps = [1, 2, 2.5, 5, 10];
  const step = steps.find((s) => s * magnitude >= value) ?? 10;
  return step * magnitude;
}

export function scale(d0: number, d1: number, r0: number, r1: number): (x: number) => number {
  if (d1 === d0) return () => (r0 + r1) / 2;
  return (x) => r0 + ((x - d0) / (d1 - d0)) * (r1 - r0);
}

export function linePath(points: Point[], x: (t: number) => number, y: (v: number) => number): string {
  return points.map((p, i) => `${i === 0 ? "M" : "L"}${x(p.t).toFixed(1)},${y(p.v).toFixed(1)}`).join("");
}

export function ticks(max: number, count: number): number[] {
  return Array.from({ length: count + 1 }, (_, i) => (max / count) * i);
}

export function nearestIndex(points: Point[], t: number): number {
  if (points.length === 0) return -1;
  let lo = 0;
  let hi = points.length - 1;
  while (hi - lo > 1) {
    const mid = (lo + hi) >> 1;
    if (points[mid].t <= t) lo = mid;
    else hi = mid;
  }
  return Math.abs(points[hi].t - t) < Math.abs(points[lo].t - t) ? hi : lo;
}
