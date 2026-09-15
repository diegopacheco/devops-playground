import { test } from "node:test";
import assert from "node:assert/strict";
import { linePath, nearestIndex, niceMax, scale, ticks } from "./chart.ts";

test("y axis ceiling rounds up so the highest spike is never clipped", () => {
  assert.equal(niceMax(87), 100);
  assert.equal(niceMax(180), 200);
  assert.equal(niceMax(2100), 2500);
  assert.equal(niceMax(100), 100);
});

test("an empty or all-zero series still gets a drawable axis", () => {
  assert.equal(niceMax(0), 1);
  assert.equal(niceMax(Number.NaN), 1);
});

test("a flat domain maps to the middle instead of NaN which would break the svg", () => {
  const y = scale(5, 5, 300, 0);
  assert.equal(y(5), 150);
});

test("higher values are drawn nearer the top of the svg", () => {
  const x = scale(0, 10, 0, 100);
  const y = scale(0, 100, 200, 0);
  const path = linePath([{ t: 0, v: 0 }, { t: 10, v: 100 }], x, y);
  assert.equal(path, "M0.0,200.0L100.0,0.0");
});

test("ticks start at the zero baseline and end at the ceiling", () => {
  assert.deepEqual(ticks(100, 4), [0, 25, 50, 75, 100]);
});

test("hover snaps to the closest bucket so the tooltip shows a real sample", () => {
  const points = [{ t: 0, v: 1 }, { t: 60, v: 2 }, { t: 120, v: 3 }];
  assert.equal(nearestIndex(points, 25), 0);
  assert.equal(nearestIndex(points, 35), 1);
  assert.equal(nearestIndex(points, 500), 2);
  assert.equal(nearestIndex([], 10), -1);
});
