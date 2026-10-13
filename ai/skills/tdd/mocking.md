# When to Mock

Mock at **system boundaries** only:

- External APIs (payment, email, etc.)
- Databases (sometimes - prefer test DB)
- Time/randomness
- File system (sometimes)

Don't mock:

- Your own classes/modules
- Internal collaborators
- Anything you control

## How to Mock: prefer `spyOn`

`spyOn` (`vi.spyOn` in Vitest, `jest.spyOn` in Jest) is the default. A module mock (`vi.mock`, `jest.mock`) is the exception.

- `spyOn` replaces one function on a real object. All other exports stay real.
- Restore each spy after its test (`restoreMocks: true` in the config). Then the double does not leak into other tests.
- A module mock replaces the full module for the full file. It hides contract drift.

```typescript
// GOOD: one function is a double, the rest of the module runs
const charge = vi.spyOn(paymentClient, 'charge').mockResolvedValue({ id: 'ch_1' });

// BAD: the full module is a double
vi.mock('./payment-client');
```

Use a module mock only if the test environment cannot import the module. Examples:
native host modules, ESM-only packages, and asset transforms.

## Designing for Mockability

At system boundaries, design interfaces that are easy to mock:

**1. Use dependency injection**

Pass external dependencies in rather than creating them internally:

```typescript
// Easy to mock
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// Hard to mock
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**2. Prefer SDK-style interfaces over generic fetchers**

Create specific functions for each external operation instead of one generic function with conditional logic:

```typescript
// GOOD: Each function is independently mockable
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};

// BAD: Mocking requires conditional logic inside the mock
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

The SDK approach means:
- Each mock returns one specific shape
- No conditional logic in test setup
- Easier to see which endpoints a test exercises
- Type safety per endpoint
