# UBC Network Extensions Schema (v1)

UBC Network-specific schema extensions for India. These schemas extend the core Beckn Protocol with India-specific constructs.

## Context URL

```
https://raw.githubusercontent.com/bhim/ubc-tsd/main/beckn-schemas/UBCExtensions/v1/context.jsonld
```

## Schemas

### BuyerUPI

Buyer payment information for refunds via UPI.

```json
"beckn:buyerAttributes": {
  "@context": "https://raw.githubusercontent.com/bhim/ubc-tsd/main/beckn-schemas/UBCExtensions/v1/context.jsonld",
  "@type": "BuyerUPI",
  "vpa": "ravikumar@upi"
}
```

| Property | Type | Description |
|----------|------|-------------|
| `vpa` | String | Virtual Payment Address (UPI ID) for refunds |

### UBCPaymentAttributes

Payment attributes including UPI transaction details and settlement accounts.

```json
"beckn:paymentAttributes": {
  "@context": "https://raw.githubusercontent.com/bhim/ubc-tsd/main/beckn-schemas/UBCExtensions/v1/context.jsonld",
  "@type": "UBCPaymentAttributes",
  "upiTransactionId": "UPI123456789012",
  "settlementAccounts": [
    {
      "beneficiaryId": "example-bap.com",
      "accountHolderName": "Example BAP Pvt Ltd",
      "accountNumber": "9876543210123",
      "ifscCode": "HDFC0009876",
      "bankName": "HDFC Bank",
      "vpa": "example-bap@paytm"
    }
  ]
}
```

| Property | Type | Description |
|----------|------|-------------|
| `upiTransactionId` | String | UPI transaction reference ID from payment gateway |
| `settlementAccounts` | Array | List of settlement account details |
| `settlementAccounts[].beneficiaryId` | String | Beneficiary identifier (BAP/BPP domain) |
| `settlementAccounts[].accountHolderName` | String | Account holder name |
| `settlementAccounts[].accountNumber` | String | Bank account number |
| `settlementAccounts[].ifscCode` | String | Bank IFSC code |
| `settlementAccounts[].bankName` | String | Bank name |
| `settlementAccounts[].vpa` | String | VPA for settlement |

## Used In APIs

- `init` - Buyer VPA for refunds
- `on_init` - Payment settlement accounts, UPI transaction ID
- `on_confirm` - UPI transaction confirmation
- `on_status` - Payment status with UPI details
- `on_cancel` - Refund VPA reference
