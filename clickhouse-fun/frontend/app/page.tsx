"use client";

import { useState } from "react";
import Explorer from "../components/Explorer";
import Overview from "../components/Overview";
import TopServices from "../components/TopServices";
import { WINDOWS } from "../lib/palette";

const TABS = ["Overview", "Explorer", "Top Services"] as const;

export default function Home() {
  const [tab, setTab] = useState<(typeof TABS)[number]>("Overview");
  const [minutes, setMinutes] = useState(60);

  return (
    <main>
      <header>
        <div>
          <h1>ClickHouse Metrics</h1>
          <p className="muted">observability.metrics via Go backend</p>
        </div>
        <div className="windows" role="group" aria-label="time window">
          {WINDOWS.map((w) => (
            <button key={w.minutes} className={w.minutes === minutes ? "active" : ""} onClick={() => setMinutes(w.minutes)}>
              {w.label}
            </button>
          ))}
        </div>
      </header>
      <nav className="tabs" role="tablist">
        {TABS.map((t) => (
          <button key={t} role="tab" aria-selected={t === tab} className={t === tab ? "active" : ""} onClick={() => setTab(t)}>
            {t}
          </button>
        ))}
      </nav>
      {tab === "Overview" && <Overview minutes={minutes} />}
      {tab === "Explorer" && <Explorer minutes={minutes} />}
      {tab === "Top Services" && <TopServices minutes={minutes} />}
    </main>
  );
}
