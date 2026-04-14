const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export function isValidEmail(value: string): boolean {
  if (typeof value !== "string") return false;
  if (value.length === 0) return false;
  return EMAIL_RE.test(value);
}

export interface RequiredFieldsResult {
  ok: boolean;
  missing: string[];
}

export function requireFields(
  input: Record<string, unknown>,
  fields: readonly string[],
): RequiredFieldsResult {
  const missing: string[] = [];
  for (const field of fields) {
    const value = input[field];
    if (value === undefined || value === null || value === "") {
      missing.push(field);
    }
  }
  return { ok: missing.length === 0, missing };
}
