// DRAFT — MSW handler for Stripe webhook events.
// Import alongside your other MSW handlers.

import { http, HttpResponse } from "msw";

const CHECKOUT_COMPLETED = {
  id: "evt_TEST_checkout_completed",
  object: "event",
  type: "checkout.session.completed",
  data: {
    object: {
      id: "cs_test_TEST",
      object: "checkout.session",
      amount_total: 10000,
      currency: "usd",
      customer: "cus_TEST",
      payment_status: "paid",
      status: "complete",
    },
  },
  created: 1_700_000_000,
};

const PAYMENT_INTENT_SUCCEEDED = {
  id: "evt_TEST_pi_succeeded",
  object: "event",
  type: "payment_intent.succeeded",
  data: {
    object: {
      id: "pi_TEST",
      object: "payment_intent",
      amount: 10000,
      currency: "usd",
      status: "succeeded",
    },
  },
  created: 1_700_000_050,
};

export const stripeWebhookHandlers = [
  http.post("https://api.stripe.com/v1/checkout/sessions", () =>
    HttpResponse.json({
      id: "cs_test_TEST",
      object: "checkout.session",
      url: "https://checkout.stripe.com/c/pay/cs_test_TEST",
    }),
  ),
];

export function buildStripeWebhookPayload(
  kind: "checkout.session.completed" | "payment_intent.succeeded",
): unknown {
  return kind === "checkout.session.completed"
    ? CHECKOUT_COMPLETED
    : PAYMENT_INTENT_SUCCEEDED;
}
