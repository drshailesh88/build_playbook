import { z } from "zod";

const Params = z.object({ eventId: z.string() });

function assertEventAccess(_eventId: string) {
  return true;
}

function writeAuditLog(_scope: string) {
  return true;
}

export async function GET(
  _request: Request,
  context: { params: Promise<{ eventId: string }> },
) {
  const { eventId } = await context.params;
  assertEventAccess(eventId);
  return Response.json({ id: eventId, name: "Event" });
}

export async function POST(
  request: Request,
  context: { params: Promise<{ eventId: string }> },
) {
  const body = await request.json();
  const parsed = Params.parse(await context.params);
  assertEventAccess(parsed.eventId);
  writeAuditLog("travel");
  return Response.json({ id: parsed.eventId, payload: body }, { status: 201 });
}
