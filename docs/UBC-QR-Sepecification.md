# UNIFIED BHARAT E-CHARGE (UBC) INTERFACE

**UBC Linking Specifications Version 1.0**  
(Common QR Specifications for EV Charging Integration)

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Link Specification and Parameters](#2-link-specification-and-parameters)
   - [2.1 URL Creation](#21-url-creation)
   - [2.2 URL Parameters](#22-url-parameters)
   - [2.3 Item ID Structure (Connector Level)](#23-item-id-structure-connector-level)
3. [Implementation Samples](#3-implementation-samples)
   - [3.1 QR Code](#31-qr-code)
4. [Design Principles](#4-design-principles)
5. [References](#5-references)

---

## 1. INTRODUCTION

The Unified Bharat E-Charge (UBC) Interface enables a standardised approach for initiating electric vehicle charging sessions. Similar to the Unified Payments Interface (UPI) for payments, this specification allows the Charging Point Operator (CPO) to provide a standardised request to the EV User.

By utilising a common URI scheme placed at the Connector Level, CPOs can allow any compliant application to discover the specific connector and initiate charging on their network seamlessly. This document provides the technical specifications for developers to enable inter-application charging requests using deep linking and QR codes.

---

## 2. LINK SPECIFICATION AND PARAMETERS

### 2.1 URL CREATION

The deep link or QR code string must follow the standard URI format identified by the scheme `beckn`. The scheme identifies the intent of the EV charging discovery using the Beckn Protocol.

**Format:**

```
beckn://discover?{parameter_1}={value}&{parameter_2}={value}&...
```

---

### 2.2 URL PARAMETERS

The following parameters are mandatory for the Beckn discovery intent:

| Tag | Parameter Name | Description | Type | Mandatory |
|-----|---------------|-------------|------|-----------|
| `message.catalogs.items.provider.id` | Provider ID | Service Provider Identity: The unique identifier for the entity providing the service (CPO/Network). Example: `atherenergy` | String | Yes |
| `message.catalogs.items.id` | Item ID | Connector Identity: The unique identifier for the specific connector (gun/socket) where the QR is placed | String | Yes |
| `version` | Version | The version of the QR Code being used | String | Yes |

---

### 2.3 ITEM ID STRUCTURE (Connector Level)

The `connector.id` represents the specific Connector uid and must strictly adhere to the following breakdown to ensure unique identification across the network. Connector uid is an assimilation of:

```
chargingstationid * chargingpointid * connectorid = Connector uid
```

**Format:**

```
<country code><separator><operator id><separator><connector uid>
```

| Component | Description | Length/Type | Example |
|-----------|-------------|-------------|---------|
| Country Code | ISO 3166-1 Alpha-3 | 3 Characters | `IND` |
| Separator | Visibility separator | 1 Character | `*` |
| Operator ID | CPO code | 3 Alphanumeric | `ABC` |
| Connector uID | Unique connector ID | 34 Alphanumeric | `12345` |

**Example:**

```
IND*ABC*12345
```

---

## 3. IMPLEMENTATION SAMPLES

### 3.1 QR CODE

The Charging Point Operator (CPO) should generate a QR code containing the Beckn link with all mandatory parameters populated. This QR code is specific to the connector.

**Structure:**

```
beckn://discover?&message.catalogs.items.provider.id={PROVIDER_ID}&message.catalogs.items.id={ITEMS_ID}&version=1.0
```

**Sample String:**

```
beckn://discover?&message.catalogs.items.provider.id=atherenergy&message.catalogs.items.id=IND*ABC*12345&version=1.0
```

**Usage Flow:**

1. **Generation**: The CPO generates a unique QR code for each connector with the structure above.
2. **Scanning**: The EV Driver opens a Beckn-compliant mobile application and scans the QR code found directly on the connector or adjacent to the specific socket.
3. **Discovery**: The application parses the `message.catalogs.items.provider.id` and `message.catalogs.items.id` to discover the specific connector status via the Catalog Discovery System (CDS) and initiates the session.

---

## 4. DESIGN PRINCIPLES

This specification is built on three core principles:

### Interoperability

The QR specification enables seamless interoperability both within and across various Beckn networks, ensuring that any compliant application can discover and interact with services regardless of the network they operate on.

### Permanency

The QR specification is designed to remain stable even as the backend protocol evolves. This ensures that QR codes need not be replaced regularly as the backend protocol undergoes updates and improvements, providing long-term viability for deployed QR codes.

### Minimalism

The specification follows a minimalist approach by deriving as much information as possible at runtime rather than encoding it in the QR code itself. This keeps QR codes compact and reduces the need for frequent updates.

---

## 5. REFERENCES

This document is an easy-to-read representation of the official Beckn QR Code specification. The source of truth for the QR specification is the [**Beckn QR Code Specification on GitHub**](https://github.com/beckn/protocol-specifications-new/blob/main/docs/BECKN-010-QR-Codes.md). Please refer to the GitHub specification for the authoritative version and any updates.

---

**Document Version**: 1.0  
**Last Updated**: Based on UBC Interface Specification PDF
