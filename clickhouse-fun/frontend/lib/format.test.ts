import { test } from "node:test";
import assert from "node:assert/strict";
import { formatBytes, formatNumber, formatRatio } from "./format.ts";

test("large row counts stay short enough for a stat tile", () => {
  assert.equal(formatNumber(432_160), "432.2K");
  assert.equal(formatNumber(2_500_000), "2.5M");
  assert.equal(formatNumber(1234), "1,234");
});

test("small metric values keep precision without trailing zeros", () => {
  assert.equal(formatNumber(12.5), "12.5");
  assert.equal(formatNumber(3), "3");
  assert.equal(formatNumber(0.25), "0.25");
});

test("storage sizes use binary units like clickhouse system.parts", () => {
  assert.equal(formatBytes(512), "512 B");
  assert.equal(formatBytes(1536), "1.5 KB");
  assert.equal(formatBytes(5 * 1024 * 1024), "5.0 MB");
});

test("compression ratio never divides by zero on an empty table", () => {
  assert.equal(formatRatio(1000, 0), "-");
  assert.equal(formatRatio(1000, 100), "10.0x");
});
