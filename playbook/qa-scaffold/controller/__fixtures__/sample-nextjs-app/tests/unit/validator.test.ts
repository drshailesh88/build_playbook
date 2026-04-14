import { describe, expect, it } from "vitest";
import { isValidEmail, requireFields } from "../../src/lib/validator.js";

describe("isValidEmail", () => {
  it("accepts a simple address", () => {
    expect(isValidEmail("user@example.com")).toBe(true);
  });

  it("accepts subdomains and plus tags", () => {
    expect(isValidEmail("first.last+tag@mail.example.co.uk")).toBe(true);
  });

  it("rejects missing @", () => {
    expect(isValidEmail("user.example.com")).toBe(false);
  });

  it("rejects empty string", () => {
    expect(isValidEmail("")).toBe(false);
  });

  it("rejects whitespace-only strings", () => {
    expect(isValidEmail("   ")).toBe(false);
  });

  it("rejects missing domain tld", () => {
    expect(isValidEmail("user@example")).toBe(false);
  });
});

describe("requireFields", () => {
  it("returns ok=true when all required fields are present", () => {
    const result = requireFields({ name: "Ada", email: "ada@x.com" }, ["name", "email"]);
    expect(result.ok).toBe(true);
    expect(result.missing).toEqual([]);
  });

  it("reports missing keys", () => {
    const result = requireFields({ name: "Ada" }, ["name", "email"]);
    expect(result.ok).toBe(false);
    expect(result.missing).toEqual(["email"]);
  });

  it("treats empty string as missing", () => {
    const result = requireFields({ name: "", email: "ada@x.com" }, ["name", "email"]);
    expect(result.ok).toBe(false);
    expect(result.missing).toEqual(["name"]);
  });

  it("treats null as missing", () => {
    const result = requireFields({ name: null, email: "ada@x.com" }, ["name", "email"]);
    expect(result.ok).toBe(false);
    expect(result.missing).toEqual(["name"]);
  });

  it("returns every missing field in order", () => {
    const result = requireFields({}, ["name", "email", "phone"]);
    expect(result.ok).toBe(false);
    expect(result.missing).toEqual(["name", "email", "phone"]);
  });
});
