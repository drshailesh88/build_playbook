// MSW handler for Razorpay webhook replay.
// Installed when Razorpay is detected. Import and register in your MSW setup:
//
//   import { razorpayWebhookHandlers } from "./mocks/razorpay-webhook";
//   setupServer(...razorpayWebhookHandlers);
//
// Handlers respond to POST requests your app makes to forward payment events
// OR simulate webhook delivery to your /api/webhooks/razorpay route.

import { http, HttpResponse } from "msw";

const SAMPLE_PAYMENT_CAPTURED = {
  entity: "event",
  account_id: "acc_TEST_TEST",
  event: "payment.captured",
  contains: ["payment"],
  payload: {
    payment: {
      entity: {
        id: "pay_TEST_CAPTURED",
        amount: 50000, // paise
        currency: "INR",
        status: "captured",
        order_id: "order_TEST_123",
        method: "card",
        captured: true,
        email: "test@example.com",
        contact: "+919999999999",
      },
    },
  },
  created_at: 1_700_000_000,
};

const SAMPLE_PAYMENT_FAILED = {
  entity: "event",
  account_id: "acc_TEST_TEST",
  event: "payment.failed",
  contains: ["payment"],
  payload: {
    payment: {
      entity: {
        id: "pay_TEST_FAILED",
        amount: 50000,
        currency: "INR",
        status: "failed",
        order_id: "order_TEST_456",
        method: "card",
        captured: false,
        error_code: "BAD_REQUEST_ERROR",
        error_description: "Card declined",
      },
    },
  },
  created_at: 1_700_000_100,
};

/**
 * Intercepts calls to Razorpay's API so tests can trigger deterministic
 * success/failure flows without real merchant connectivity.
 */
export const razorpayWebhookHandlers = [
  // Simulate order creation succeeding
  http.post("https://api.razorpay.com/v1/orders", () =>
    HttpResponse.json({
      id: "order_TEST_123",
      entity: "order",
      amount: 50000,
      currency: "INR",
      receipt: "receipt_test_001",
      status: "created",
    }),
  ),
  // Payment capture
  http.post(/\/payments\/pay_TEST_[A-Z_]+\/capture/, () =>
    HttpResponse.json(SAMPLE_PAYMENT_CAPTURED.payload.payment.entity),
  ),
];

/**
 * Helpers for Playwright specs to POST a canned webhook payload at the app's
 * webhook endpoint — Razorpay's test mode does not reliably reach localhost
 * so we drive the webhook ourselves.
 */
export function buildWebhookPayload(
  kind: "payment.captured" | "payment.failed",
): unknown {
  return kind === "payment.captured"
    ? SAMPLE_PAYMENT_CAPTURED
    : SAMPLE_PAYMENT_FAILED;
}
