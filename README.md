# UBC Technical Specification Document (UBC-TSD)

Welcome to the UBC Technical Specification Document repository. This repository allows you to easily navigate the protocols, schemas, and technical standards defined for the project.

## 📂 Repository Structure

The repository is organized into the following key directories:

### 1. `beckn-schemas`
This directory contains the formal schema definitions for the Beckn protocol.
- **Purpose**: Defines the structure and validation rules for the data models.
- **Contents**: 
    - **Core Schemas**: Fundamental Beckn protocol definitions.
    - **Domain Schemas**: Specific extensions for domains like EV Charging and Payment Settlements.
- **Use Case**: Refer to this when you need to know the exact fields, data types, and hierarchy of the protocol objects.

### 2. `docs`
This directory contains the comprehensive technical documentation and specification files.
- **Purpose**: Provides high-level technical details, architectural guidelines, and standard definitions.
- **Contents**:
    - **Technical Specification Document**: Detailed breakdown of the system architecture and flows.
    - **QR Resolution Standard**: Specifications for QR code implementation and resolution.
- **Use Case**: Start here to understand the "Why" and "How" of the system before diving into the code.

### 3. `Example-schemas`
This directory provides practical JSON examples for various API interactions.
- **Purpose**: Demonstrates how the schemas are applied in real-world scenarios.
- **Contents**: Folders organized by API actions (e.g., `discovery`, `ordering`, `fulfillment`), containing sample JSON payloads for requests and responses.
- **Use Case**: Use these as templates for testing or when building your own API payloads to ensure compliance.

### 4. `openAPI`
This directory houses the standard API specifications.
- **Purpose**: Facilitates API development, testing, and integration.
- **Contents**:
    - **Swagger/OpenAPI Files**: YAML/JSON files defining the API endpoints.
    - **Postman Collections**: Ready-to-use collections for testing APIs.
- **Use Case**: Import these into tools like Postman or Swagger UI to interact with and test the APIs directly.

## 🚀 How to Navigate

- **For New Developers**: Start with **`docs`** to get an overview of the system.
- **For API Implementers**: Reference **`beckn-schemas`** for data models and **`openAPI`** for endpoint definitions.
- **For Testers**: Use **`Example-schemas`** to create test data and **`openAPI`** for checking endpoints.

---
*Maintained by the NBSL Technical Team.*
