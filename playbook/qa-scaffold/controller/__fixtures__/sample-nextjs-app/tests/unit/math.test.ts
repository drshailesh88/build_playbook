import { describe, expect, it } from "vitest";
import { add, divide, multiply } from "../../src/lib/math.js";

describe("add", () => {
  it("sums positive integers", () => {
    expect(add(2, 3)).toBe(5);
  });

  it("sums with negatives", () => {
    expect(add(-4, 6)).toBe(2);
    expect(add(-4, -6)).toBe(-10);
  });

  it("preserves identity with zero", () => {
    expect(add(7, 0)).toBe(7);
    expect(add(0, 7)).toBe(7);
  });
});

describe("multiply", () => {
  it("multiplies positives", () => {
    expect(multiply(4, 5)).toBe(20);
  });

  it("returns zero when either operand is zero", () => {
    expect(multiply(0, 5)).toBe(0);
    expect(multiply(5, 0)).toBe(0);
  });

  it("handles negatives correctly", () => {
    expect(multiply(-3, 4)).toBe(-12);
    expect(multiply(-3, -4)).toBe(12);
  });
});

describe("divide", () => {
  it("divides positives", () => {
    expect(divide(10, 2)).toBe(5);
  });

  it("throws on divide-by-zero", () => {
    expect(() => divide(10, 0)).toThrow("division by zero");
  });

  it("handles negative divisor", () => {
    expect(divide(10, -2)).toBe(-5);
  });

  it("handles negative dividend", () => {
    expect(divide(-10, 2)).toBe(-5);
  });
});
