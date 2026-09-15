import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "ClickHouse Metrics",
  description: "Service metrics stored in ClickHouse, queried by a Go backend",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
