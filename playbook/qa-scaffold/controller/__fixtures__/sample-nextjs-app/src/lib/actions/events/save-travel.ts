"use server";

import { z } from "zod";

const SaveTravelInput = z.object({
  eventId: z.string(),
  destination: z.string(),
});

function assertEventAccess(_eventId: string) {
  return true;
}

function writeAuditLog(_scope: string) {
  return true;
}

const db = {
  insert() {
    return true;
  },
  transaction(callback: () => boolean) {
    return callback();
  },
};

export async function saveTravel(input: unknown) {
  const parsed = SaveTravelInput.parse(input);
  assertEventAccess(parsed.eventId);
  db.transaction(() => db.insert());
  writeAuditLog("travel");
  return parsed;
}
