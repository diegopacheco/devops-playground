"use client";

import { useEffect, useState } from "react";

export type Stats = {
  rows: number;
  first_ts: string;
  last_ts: string;
  compressed_bytes: number;
  uncompressed_bytes: number;
  parts: number;
};

export type MetricInfo = { metric: string; samples: number; services: number };

export type Summary = { metric: string; samples: number; avg: number; min: number; max: number; p95: number };

export type Series = { service: string; points: { t: number; v: number }[] };

export type Timeseries = { metric: string; minutes: number; step: number; series: Series[] };

export type TopService = { service: string; avg: number; p95: number; max: number; samples: number };

export type Loaded<T> = { data: T | null; error: string | null; loading: boolean };

export function useApi<T>(url: string | null): Loaded<T> {
  const [state, setState] = useState<Loaded<T>>({ data: null, error: null, loading: true });

  useEffect(() => {
    if (!url) return;
    let active = true;
    setState((s) => ({ ...s, loading: true }));
    fetch(url)
      .then(async (res) => {
        const body = await res.json();
        if (!res.ok) throw new Error(body.error ?? `request failed with ${res.status}`);
        return body as T;
      })
      .then((data) => active && setState({ data, error: null, loading: false }))
      .catch((err: Error) => active && setState({ data: null, error: err.message, loading: false }));
    return () => {
      active = false;
    };
  }, [url]);

  return state;
}
