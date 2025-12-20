# Beckn Core Schemas v2

This directory contains the foundational schemas for the **Beckn Protocol v2**. These specifications define the data models, vocabulary, and semantic context used across all Beckn-enabled networks for discovery, ordering, fulfillment, and payment.

## 📂 File Structure

| File | Format | Purpose |
| :--- | :--- | :--- |
| **[`attributes.yaml`](./attributes.yaml)** | OpenAPI 3.1 | **Data Validation**. Defines the structural rules, data types, and required fields for core objects (e.g., `Catalog`, `Order`). Used by developers to validate API payloads. |
| **[`vocab.jsonld`](./vocab.jsonld)** | JSON-LD / RDFS | **Semantic Vocabulary**. Defines the "dictionary" of terms (classes and properties) used in Beckn, mapped to [schema.org](https://schema.org/) where possible. |
| **[`context.jsonld`](./context.jsonld)** | JSON-LD Context | **Semantic Mapping**. A mapping file that translates JSON keys (e.g., `beckn:items`) into unique URIs defined in the vocabulary. This allows data interoperability across different systems. |

## 🧩 Key Concepts

The core schema revolves around a universal commerce transaction model:

### 1. Discovery & Catalog
*   **`Catalog`**: A collection of offerings from a provider.
*   **`Item`**: A product or service being sold.
*   **`Offer`**: Example: "Buy 1 Get 1 Free". Wraps items with pricing and time validity.
*   **`Provider`**: The entity selling the items (e.g., a store, a driver, a restaurant).
*   **`Location`**: Physical places represented using **GeoJSON** and/or postal addresses.

### 2. Transaction (Order)
*   **`Order`**: The central object recording a transaction between a Buyer and a Seller.
*   **`OrderItem`**: Individual line items within an order.
*   **`PriceSpecification`**: Detailed breakdown of costs (price, tax, discount, fees).
*   **`Fulfillment`**: Handles how the order is executed (`DELIVERY`, `PICKUP`, `RESERVATION`, `DIGITAL`).
*   **`Payment`**: Payment status and method details (`UPI`, `CARD`, etc.).

### 3. Common Utilities
*   **`Attributes`**: A flexible mechanism to attach domain-specific data (e.g., EV charging specs, healthcare details) without altering the core schema.
*   **`Descriptor`**: Standard way to describe things with names, images, and descriptions.
*   **`Error`**: Standardized error reporting structure.

## 🛠️ How it Works

Beckn uses a **dual-schema approach**:

1.  **Validation layer (`attributes.yaml`)**: Ensures that the JSON sent over the wire is structurally correct (numbers are numbers, strings are strings, required fields exist).
2.  **Semantic layer (`context.jsonld` & `vocab.jsonld`)**: Ensures that `price` means the same thing to a Mobility app as it does to a Retail app.

### Example: Linking JSON to Semantics
In your JSON payload:
```json
{
  "@context": "https://.../context.jsonld",
  "beckn:id": "item-001",
  "beckn:price": { ... }
}
```
The `@context` tells the system how to interpret `beckn:id` and `beckn:price` using the definitions in definitions `vocab.jsonld`.
