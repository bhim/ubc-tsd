# Beckn V2 EV Charging API - Field Reference Guide

This document provides a comprehensive reference for all fields used in the Beckn V2 EV Charging API examples.

## Table of Contents
- [Context Fields](#context-fields)
- [Discovery & Search](#discovery--search)
- [Catalog & Items](#catalog--items)
- [ChargingService Attributes](#chargingservice-attributes)
- [Offers & Pricing](#offers--pricing)
- [Order Management](#order-management)
- [Order Attributes](#order-attributes)
- [Buyer Information](#buyer-information)
- [Order Items](#order-items)
- [Fulfillment](#fulfillment)
- [ChargingSession Attributes](#chargingsession-attributes)
- [Charging Telemetry](#charging-telemetry)
- [Tracking](#tracking)
- [Payment](#payment)
- [Rating & Feedback](#rating--feedback)
- [Support](#support)
- [Cancellation](#cancellation)
- [Catalog Publish](#catalog-publish)

---

## Context Fields

Fields that appear in the `context` object of every API call.

| Field Path | Field Name | Type | Required | Description | Example | Used In |
|------------|-----------|------|----------|-------------|---------|---------|
| `context.version` | Version | String | ✅ | Beckn protocol version | `2.0.0` | All APIs |
| `context.action` | Action | String | ✅ | The API action being performed | `discover`, `on_discover`, `select`, etc. | All APIs |
| `context.domain` | Domain | String | ✅ | Domain/use case identifier | `beckn.one:deg:ev-charging:*` | All APIs |
| `context.location.country.code` | Country Code | String | ✅ | ISO 3166-1 alpha-3 country code | `IND` | All APIs |
| `context.location.city.code` | City Code | String | ✅ | City code with standard prefix | `std:080` | All APIs |
| `context.timestamp` | Timestamp | DateTime | ✅ | Request/response timestamp | `2024-01-15T10:30:00Z` | All APIs |
| `context.transaction_id` | Transaction ID | UUID | ✅ | Unique identifier for the transaction | `2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002` | All APIs |
| `context.message_id` | Message ID | UUID | ✅ | Unique identifier for each message | `a1eabf26-29f5-4a01-9d4e-4c5c9d1a3d02` | All APIs |
| `context.bap_id` | BAP ID | String | ✅ | Buyer Application Platform identifier | `bap.example.com` | All APIs |
| `context.bap_uri` | BAP URI | URL | ✅ | BAP callback endpoint | `https://bap.example.com` | All APIs |
| `context.bpp_id` | BPP ID | String | ❌ | Beckn Provider Platform identifier | `bpp.example.com` | Response APIs |
| `context.bpp_uri` | BPP URI | URL | ❌ | BPP endpoint | `https://bpp.example.com` | Response APIs |
| `context.ttl` | Time To Live | Duration | ✅ | Maximum time to wait for response | `PT30S` | All APIs |
| `context.schema_context` | Schema Context | Array[URL] | ✅ | JSON-LD context references | `["https://...context.jsonld"]` | All APIs |

**Notes:**
- `transaction_id` remains the same across request-response pairs
- `message_id` is unique for each request/response
- `ttl` uses ISO 8601 duration format
- `bpp_id` and `bpp_uri` only present in response APIs

---

## Discovery & Search

Fields used in `discover` request for searching charging stations.

| Field Path | Field Name | Type | Required | Description | Example | Notes |
|------------|-----------|------|----------|-------------|---------|-------|
| `message.text_search` | Text Search | String | ❌ | Free-text search query | `EV charger fast charging` | Natural language search |
| `message.spatial` | Spatial Filters | Array[Object] | ❌ | Geographic search filters | `[{op: "s_dwithin", ...}]` | CQL2 spatial operators |
| `message.spatial[].op` | Spatial Operator | String | ✅ | Spatial operation type | `s_dwithin`, `s_contains`, `s_intersects` | CQL2 standard |
| `message.spatial[].targets` | Targets JSONPath | String | ✅ | JSONPath to target fields | `$['beckn:availableAt'][*]['geo']` | Which fields to filter |
| `message.spatial[].geometry.type` | Geometry Type | String | ✅ | GeoJSON geometry type | `Point`, `Polygon`, `LineString` | GeoJSON standard |
| `message.spatial[].geometry.coordinates` | Coordinates | Array | ✅ | Geographic coordinates | `[77.5900, 12.9400]` | [longitude, latitude] |
| `message.spatial[].distanceMeters` | Distance (m) | Number | ❌ | Radius for distance queries | `10000` | For s_dwithin operator |
| `message.filters.expression` | Filter Expression | String | ❌ | JSONPath filtering logic | `$[?(@.itemAttributes.connectorType=='CCS2')]` | Complex filtering |

**Notes:**
- Spatial filters use CQL2 (Common Query Language 2) operators
- Coordinates are always [longitude, latitude] order (GeoJSON standard)
- Multiple spatial filters can be combined (AND logic)
- JSONPath expressions allow complex attribute filtering

---

## Catalog & Items

Fields in `on_discover` response containing available charging stations.

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `message.catalogs` | Catalogs | Array[Object] | ✅ | Array of catalog objects | `[{@type: "beckn:Catalog", ...}]` |
| `message.catalogs[].@context` | Context | URL | ✅ | JSON-LD context | `https://becknprotocol.io/.../Catalog/schema-context.jsonld` |
| `message.catalogs[].@type` | Type | String | ✅ | JSON-LD type | `beckn:Catalog` |
| `message.catalogs[].beckn:descriptor` | Descriptor | Object | ✅ | Catalog description | `{schema:name: "EV Charging Services"}` |
| `message.catalogs[].beckn:descriptor.schema:name` | Name | String | ✅ | Display name | `EV Charging Services Network` |
| `message.catalogs[].beckn:descriptor.beckn:shortDesc` | Short Description | String | ❌ | Brief description | `Comprehensive network of fast charging stations` |
| `message.catalogs[].beckn:validity` | Validity Period | Object | ❌ | Time period for catalog | `{schema:startDate, schema:endDate}` |
| `message.catalogs[].beckn:validity.schema:startDate` | Start Date | DateTime | ✅ | Validity start | `2024-10-01T00:00:00Z` |
| `message.catalogs[].beckn:validity.schema:endDate` | End Date | DateTime | ✅ | Validity end | `2025-01-15T23:59:59Z` |
| `message.catalogs[].beckn:items` | Items | Array[Object] | ✅ | Available items/services | `[{@type: "beckn:Item", ...}]` |

### Item Fields

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `beckn:items[].@context` | Context | URL | ✅ | JSON-LD context | `https://becknprotocol.io/.../Item/schema-context.jsonld` |
| `beckn:items[].@type` | Type | String | ✅ | JSON-LD type | `beckn:Item` |
| `beckn:items[].beckn:id` | Item ID | String | ✅ | Unique item identifier | `ev-charger-ccs2-001` |
| `beckn:items[].beckn:descriptor` | Descriptor | Object | ✅ | Item description | `{schema:name, beckn:shortDesc, beckn:longDesc}` |
| `beckn:items[].beckn:descriptor.schema:name` | Name | String | ✅ | Display name | `DC Fast Charger - CCS2 (60kW)` |
| `beckn:items[].beckn:descriptor.beckn:shortDesc` | Short Description | String | ❌ | Brief description | `High-speed DC charging station` |
| `beckn:items[].beckn:descriptor.beckn:longDesc` | Long Description | String | ❌ | Detailed description | `Ultra-fast DC charging station supporting...` |
| `beckn:items[].beckn:category` | Category | Object | ✅ | Item classification | `{schema:codeValue: "ev-charging"}` |
| `beckn:items[].beckn:category.schema:codeValue` | Code Value | String | ✅ | Category code | `ev-charging` |
| `beckn:items[].beckn:category.schema:name` | Category Name | String | ✅ | Category name | `EV Charging` |

### Location Fields

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `beckn:items[].beckn:availableAt` | Available At | Array[Object] | ✅ | Geographic locations | `[{geo, address}]` |
| `beckn:items[].beckn:availableAt[].geo` | Geo Location | Object | ✅ | GeoJSON location | `{type: "Point", coordinates: [77.5946, 12.9716]}` |
| `beckn:items[].beckn:availableAt[].geo.type` | Geometry Type | String | ✅ | GeoJSON type | `Point` |
| `beckn:items[].beckn:availableAt[].geo.coordinates` | Coordinates | Array[Number] | ✅ | [Longitude, Latitude] | `[77.5946, 12.9716]` |
| `beckn:items[].beckn:availableAt[].address` | Address | Object | ✅ | Postal address | `{streetAddress, addressLocality, ...}` |
| `beckn:items[].beckn:availableAt[].address.streetAddress` | Street Address | String | ✅ | Street and building | `EcoPower BTM Hub, 100 Ft Rd` |
| `beckn:items[].beckn:availableAt[].address.addressLocality` | City/Locality | String | ✅ | City name | `Bengaluru` |
| `beckn:items[].beckn:availableAt[].address.addressRegion` | State/Region | String | ✅ | State or province | `Karnataka` |
| `beckn:items[].beckn:availableAt[].address.postalCode` | Postal Code | String | ✅ | ZIP/postal code | `560076` |
| `beckn:items[].beckn:availableAt[].address.addressCountry` | Country | String | ✅ | Country code | `IN` |

### Item Metadata

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `beckn:items[].beckn:availabilityWindow` | Availability Window | Object | ❌ | Operating hours | `{schema:startTime: "06:00:00", schema:endTime: "22:00:00"}` |
| `beckn:items[].beckn:availabilityWindow.schema:startTime` | Start Time | Time | ✅ | Opening time | `06:00:00` |
| `beckn:items[].beckn:availabilityWindow.schema:endTime` | End Time | Time | ✅ | Closing time | `22:00:00` |
| `beckn:items[].beckn:rateable` | Rateable | Boolean | ✅ | Can be rated | `true` |
| `beckn:items[].beckn:rating` | Rating | Object | ❌ | Rating info | `{beckn:ratingValue: 4.5, beckn:ratingCount: 128}` |
| `beckn:items[].beckn:rating.beckn:ratingValue` | Rating Value | Number | ✅ | Average rating | `4.5` |
| `beckn:items[].beckn:rating.beckn:ratingCount` | Rating Count | Integer | ✅ | Number of ratings | `128` |
| `beckn:items[].beckn:isActive` | Is Active | Boolean | ✅ | Currently active | `true` |

### Provider Fields

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `beckn:items[].beckn:provider` | Provider | Object | ✅ | Provider info | `{beckn:id, beckn:descriptor}` |
| `beckn:items[].beckn:provider.beckn:id` | Provider ID | String | ✅ | Provider identifier | `ecopower-charging` |
| `beckn:items[].beckn:provider.beckn:descriptor` | Descriptor | Object | ✅ | Provider details | `{schema:name: "EcoPower Charging Pvt Ltd"}` |

---

## ChargingService Attributes

EV-specific attributes in `beckn:itemAttributes` (ChargingService schema).

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `beckn:itemAttributes.@context` | Context | URL | ✅ | ChargingService context | `https://raw.githubusercontent.com/.../EvChargingService/v1/context.jsonld` |
| `beckn:itemAttributes.@type` | Type | String | ✅ | Type identifier | `ChargingService` |
| `beckn:itemAttributes.connectorType` | Connector Type | String | ✅ | Charging connector | `CCS2`, `CHAdeMO`, `Type2`, `GBT` |
| `beckn:itemAttributes.maxPowerKW` | Max Power (kW) | Number | ✅ | Maximum power | `60` |
| `beckn:itemAttributes.minPowerKW` | Min Power (kW) | Number | ❌ | Minimum power | `5` |
| `beckn:itemAttributes.socketCount` | Socket Count | Integer | ✅ | Available sockets | `2` |
| `beckn:itemAttributes.reservationSupported` | Reservation | Boolean | ✅ | Advance booking | `true` |
| `beckn:itemAttributes.acceptedPaymentMethod` | Payment Methods | Array[String] | ✅ | Accepted payments | `["schema:UPI", "schema:CreditCard", "schema:Wallet"]` |
| `beckn:itemAttributes.serviceLocation` | Service Location | Object | ✅ | Location details | `{geo, address}` |
| `beckn:itemAttributes.amenityFeature` | Amenities | Array[String] | ❌ | Available facilities | `["RESTAURANT", "RESTROOM", "WI-FI"]` |
| `beckn:itemAttributes.ocppId` | OCPP ID | String | ❌ | OCPP station ID | `IN-ECO-BTM-01` |
| `beckn:itemAttributes.evseId` | EVSE ID | String | ❌ | EVSE identifier | `IN*ECO*BTM*01*CCS2*A` |
| `beckn:itemAttributes.roamingNetwork` | Roaming Network | String | ❌ | Network name | `GreenRoam` |
| `beckn:itemAttributes.parkingType` | Parking Type | String | ❌ | Parking category | `Mall`, `Street`, `Highway` |
| `beckn:itemAttributes.connectorId` | Connector ID | String | ❌ | Physical connector | `CCS2-A` |
| `beckn:itemAttributes.powerType` | Power Type | String | ✅ | AC or DC | `AC`, `DC` |
| `beckn:itemAttributes.connectorFormat` | Connector Format | String | ✅ | Socket or cable | `SOCKET`, `CABLE` |
| `beckn:itemAttributes.chargingSpeed` | Charging Speed | String | ✅ | Speed category | `SLOW`, `FAST`, `ULTRA_FAST` |
| `beckn:itemAttributes.stationStatus` | Station Status | String | ✅ | Availability status | `Available`, `Charging`, `Offline` |
| `beckn:itemAttributes.vehicleType` | Vehicle Type | String | ❌ | Supported vehicle type | `2-WHEELER`, `3-WHEELER`, `4-WHEELER` |
| `beckn:itemAttributes.chargingStation` | Charging Station | Object | ❌ | Physical station details | `{id, serviceLocation}` |
| `beckn:itemAttributes.chargingStation.id` | Station ID | String | ✅ | Unique station identifier | `IN-ECO-BTM-STATION-01` |
| `beckn:itemAttributes.chargingStation.serviceLocation` | Service Location | Object | ✅ | Station location details | `{@type: "beckn:Location", geo, address}` |

**Notes:**
- `connectorType` follows ISO 15118 standards
- `evseId` format: Country*Operator*Location*EVSE*Connector
- `acceptedPaymentMethod` uses schema.org types
- Status updates in real-time
- `vehicleType` indicates compatible vehicle categories

---

## Offers & Pricing

Fields in `beckn:offers` array for pricing plans.

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `beckn:offers[].@context` | Context | URL | ✅ | Offer context | `https://becknprotocol.io/.../Offer/schema-context.jsonld` |
| `beckn:offers[].@type` | Type | String | ✅ | Type identifier | `beckn:Offer` |
| `beckn:offers[].beckn:id` | Offer ID | String | ✅ | Unique offer ID | `eco-charge-offer-ccs2-60kw-kwh` |
| `beckn:offers[].beckn:descriptor` | Descriptor | Object | ✅ | Offer description | `{schema:name: "Per-kWh Tariff - CCS2 60kW"}` |
| `beckn:offers[].beckn:items` | Items | Array[Object] | ✅ | Applicable items | `[{beckn:id: "ev-charger-ccs2-001"}]` |
| `beckn:offers[].beckn:price` | Price | Object | ✅ | Pricing details | `{@type: "schema:PriceSpecification", ...}` |

### Price Specification

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `beckn:price.@type` | Type | String | ✅ | Price type | `schema:PriceSpecification` |
| `beckn:price.schema:priceCurrency` | Currency | String | ✅ | Currency code | `INR` |
| `beckn:price.schema:price` | Unit Price | Number | ✅ | Price per unit | `18.00` |
| `beckn:price.schema:unitCode` | Unit Code | String | ✅ | Measurement unit | `KWH` |
| `beckn:price.schema:valueAddedTaxIncluded` | VAT Included | Boolean | ✅ | Tax inclusion | `false` |

| `beckn:offerAttributes.@context` | Context | URL | ✅ | ChargingOffer context | `https://raw.githubusercontent.com/.../EvChargingOffer/v1/context.jsonld` |
| `beckn:offerAttributes.@type` | Type | String | ✅ | Type identifier | `ChargingOffer` |
| `beckn:offerAttributes.tariffModel` | Tariff Model | String | ✅ | Pricing model | `PER_KWH`, `PER_MINUTE`, `SUBSCRIPTION`, `TIME_OF_DAY` |
| `beckn:offerAttributes.idleFeePolicy` | Idle Fee Policy | Object | ❌ | Idle fee specification | `{currency: "INR", value: 2, applicableQuantity: {...}}` |
| `beckn:offerAttributes.idleFeePolicy.currency` | Currency | String | ✅ | Idle fee currency | `INR` |
| `beckn:offerAttributes.idleFeePolicy.value` | Value | Number | ✅ | Idle fee amount | `2` |
| `beckn:offerAttributes.idleFeePolicy.applicableQuantity` | Applicable Quantity | Object | ✅ | Time unit for idle fee | `{unitCode: "MIN", unitQuantity: 10}` |

**Tariff Models:**
- `PER_KWH` - Pricing per kilowatt-hour of energy
- `PER_MINUTE` - Pricing per minute of charging time
- `SUBSCRIPTION` - Subscription-based pricing
- `TIME_OF_DAY` - Variable pricing based on time of day

**Notes:**
- Currency codes follow ISO 4217
- Unit codes follow UN/CEFACT standards
- Multiple offers can exist per item (different pricing tiers)
- `idleFeePolicy` charges users who remain connected after charging completes

---

## Order Management

Fields in `message.order` object for order handling.

| Field Path | Field Name | Type | Required | Description | Example | Used In |
|------------|-----------|------|----------|-------------|---------|---------|
| `message.order.@context` | Context | URL | ✅ | Order context | `https://becknprotocol.io/.../Order/schema-context.jsonld` | select, on_select, init, on_init, confirm, on_confirm |
| `message.order.@type` | Type | String | ✅ | Type identifier | `beckn:Order` | select, on_select, init, on_init, confirm, on_confirm |
| `message.order.beckn:id` | Order ID | String | ✅ | Unique order ID | `order-12345` | All order APIs |
| `message.order.beckn:status` | Order Status | String | ✅ | Current status | `PENDING`, `CONFIRMED`, `ACTIVE`, `COMPLETED`, `CANCELLED` | on_select onwards |
| `message.order.beckn:orderNumber` | Order Number | String | ❌ | Display number | `ORD-2024-001` | on_confirm onwards |

**Order Status Values:**
- `PENDING` - Order created, awaiting confirmation
- `CONFIRMED` - Order confirmed by provider
- `ACTIVE` - Service is active (charging in progress)
- `COMPLETED` - Service completed successfully
- `CANCELLED` - Order cancelled

---

## Order Attributes

Fields in `message.order.beckn:orderAttributes` for EV charging order specifics.

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `beckn:orderAttributes` | Order Attributes | Object | ❌ | Order-level domain attributes | `{@type: "EvChargingOrder", preferences: {...}}` |
| `beckn:orderAttributes.preferences` | Preferences | Object | ❌ | User charging preferences | `{startTime, endTime}` |
| `beckn:orderAttributes.preferences.startTime` | Preferred Start | DateTime | ❌ | Preferred session start | `2026-01-04T08:00:00+05:30` |
| `beckn:orderAttributes.preferences.endTime` | Preferred End | DateTime | ❌ | Preferred session end | `2026-01-04T10:00:00+05:30` |
| `beckn:orderAttributes.buyerFinderFee` | Buyer Finder Fee | Object | ❌ | BAP commission | `{currency: "INR", value: 2.5}` |

**Notes:**
- `preferences` allows buyers to specify desired charging time windows
- `buyerFinderFee` represents the commission charged by the BAP

---

## Buyer Information

Fields in `message.order.beckn:buyer` (Party schema).

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `beckn:buyer.@context` | Context | URL | ✅ | Party context | `https://becknprotocol.io/.../Party/schema-context.jsonld` |
| `beckn:buyer.@type` | Type | String | ✅ | Type identifier | `beckn:Buyer` |
| `beckn:buyer.beckn:id` | Buyer ID | String | ✅ | Unique buyer identifier | `user-123` |
| `beckn:buyer.beckn:displayName` | Display Name | String | ❌ | Buyer name | `Ravi Kumar` |
| `beckn:buyer.beckn:telephone` | Phone | String | ❌ | Phone number | `+91-9876543210` |
| `beckn:buyer.beckn:email` | Email | String | ❌ | Email address | `ravi.kumar@example.com` |
| `beckn:buyer.beckn:taxID` | Tax ID | String | ❌ | Tax number | `GSTIN29ABCDE1234F1Z5` |
| `beckn:buyer.beckn:buyerAttributes` | Buyer Attributes | Object | ❌ | Buyer payment info | `{@type: "BuyerPaymentInfo", vpa: "user@upi"}` |

### Buyer Attributes (BuyerPaymentInfo)

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `beckn:buyerAttributes.@context` | Context | URL | ✅ | BuyerPaymentInfo context | `https://raw.githubusercontent.com/.../PaymentSettlement/v1/context.jsonld` |
| `beckn:buyerAttributes.@type` | Type | String | ✅ | Type identifier | `BuyerPaymentInfo` |
| `beckn:buyerAttributes.vpa` | VPA | String | ✅ | Virtual Payment Address | `ravikumar@upi` |

**Notes:**
- `vpa` is the buyer's UPI Virtual Payment Address for refunds
- `buyerAttributes` is used across init, confirm, track, and cancel flows

---

## Order Items

Fields in `message.order.beckn:orderItems` array.

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `beckn:orderItems[].beckn:id` | Item ID | String | ✅ | Catalog item reference | `ev-charger-ccs2-001` |
| `beckn:orderItems[].beckn:quantity` | Quantity | Object | ✅ | Quantity details | `{beckn:count: 2.5, beckn:unitCode: "KWH"}` |
| `beckn:orderItems[].beckn:quantity.beckn:count` | Count | Number | ✅ | Quantity amount | `2.5` |
| `beckn:orderItems[].beckn:quantity.beckn:unitCode` | Unit Code | String | ✅ | Unit of measure | `KWH` |
| `beckn:orderItems[].beckn:offer` | Offer | Object | ✅ | Selected offer | `{beckn:id: "eco-charge-offer..."}` |

---

## Fulfillment

Fields in `message.order.beckn:fulfillments` array.

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `beckn:fulfillments[].beckn:id` | Fulfillment ID | String | ✅ | Unique fulfillment ID | `fulfillment-001` |
| `beckn:fulfillments[].beckn:status` | Status | String | ✅ | Current status | `PENDING`, `ACTIVE`, `COMPLETED`, `CANCELLED` |
| `beckn:fulfillments[].beckn:deliveryMethod` | Delivery Method | String | ✅ | Fulfillment type | `RESERVATION` |
| `beckn:fulfillments[].beckn:start` | Start | Object | ✅ | Start details | `{beckn:time, beckn:location}` |
| `beckn:fulfillments[].beckn:start.beckn:time` | Start Time | Object | ✅ | Time details | `{beckn:timestamp, beckn:range}` |
| `beckn:fulfillments[].beckn:start.beckn:location` | Start Location | Object | ✅ | Location details | `{beckn:id, geo, address}` |
| `beckn:fulfillments[].beckn:end` | End | Object | ❌ | End details | `{beckn:time}` |

**Fulfillment Status Values:**
- `PENDING` - Not yet started
- `ACTIVE` - Currently in progress (charging)
- `COMPLETED` - Finished successfully
- `CANCELLED` - Cancelled

---

## ChargingSession Attributes

EV-specific fulfillment data in `beckn:fulfillmentAttributes` (ChargingSession schema).

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `beckn:fulfillmentAttributes.@context` | Context | URL | ✅ | ChargingSession context | `https://raw.githubusercontent.com/.../ChargingSession/v1/context.jsonld` |
| `beckn:fulfillmentAttributes.@type` | Type | String | ✅ | Type identifier | `ChargingSession` |
| `beckn:fulfillmentAttributes.sessionId` | Session ID | String | ❌ | Session identifier | `SESSION-123` |
| `beckn:fulfillmentAttributes.sessionStatus` | Session Status | String | ✅ | Charging status | `PENDING`, `ACTIVE`, `COMPLETED`, `INTERRUPTED` |
| `beckn:fulfillmentAttributes.authorizationMode` | Authorization Mode | String | ✅ | Auth method | `OTP`, `RFID`, `APP` |
| `beckn:fulfillmentAttributes.authorizationToken` | Authorization Token | String | ❌ | Auth credential | `123456` |
| `beckn:fulfillmentAttributes.vehicleRegistration` | Vehicle Registration | String | ❌ | License plate | `KA01AB1234` |
| `beckn:fulfillmentAttributes.vehicleModel` | Vehicle Model | String | ❌ | Make and model | `Tesla Model 3` |
| `beckn:fulfillmentAttributes.batteryCapacityKWh` | Battery Capacity | Number | ❌ | Battery size (kWh) | `75` |
| `beckn:fulfillmentAttributes.currentBatteryLevelPercent` | Current Battery % | Number | ❌ | Starting battery | `25` |
| `beckn:fulfillmentAttributes.targetBatteryLevelPercent` | Target Battery % | Number | ❌ | Desired battery | `80` |
| `beckn:fulfillmentAttributes.connectorId` | Connector ID | String | ✅ | Which connector | `CCS2-A` |
| `beckn:fulfillmentAttributes.chargingPowerKW` | Charging Power | Number | ❌ | Current power (kW) | `45.5` |
| `beckn:fulfillmentAttributes.energyDeliveredKWh` | Energy Delivered | Number | ❌ | Total energy (kWh) | `2.3` |
| `beckn:fulfillmentAttributes.chargingProgressPercent` | Charging Progress | Number | ❌ | Completion % | `65` |
| `beckn:fulfillmentAttributes.estimatedCompletionTime` | Estimated Completion | DateTime | ❌ | Expected end time | `2024-01-15T12:45:00Z` |

| `beckn:deliveryAttributes.connectorStatus` | Connector Status | String | ❌ | OCPP connector status | `AVAILABLE`, `PREPARING`, `UNAVAILABLE` |
| `beckn:deliveryAttributes.meteredEnergyKWh` | Metered Energy | Number | ❌ | Total energy delivered (kWh) | `13.6` |
| `beckn:deliveryAttributes.meteredDurationMinutes` | Metered Duration | Number | ❌ | Total session time (minutes) | `35` |
| `beckn:deliveryAttributes.totalCost` | Total Cost | Object | ❌ | Session cost breakdown | `{exclVat: 245.0, inclVat: 289.1}` |
| `beckn:deliveryAttributes.totalCost.exclVat` | Cost Excluding VAT | Number | ✅ | Cost before tax | `245.0` |
| `beckn:deliveryAttributes.totalCost.inclVat` | Cost Including VAT | Number | ✅ | Cost after tax | `289.1` |
| `beckn:deliveryAttributes.reservationId` | Reservation ID | String | ❌ | Server-assigned reservation ID | `RESV-984532` |
| `beckn:deliveryAttributes.gracePeriodMinutes` | Grace Period | Number | ❌ | Minutes before releasing slot | `10` |
| `beckn:deliveryAttributes.lastUpdated` | Last Updated | DateTime | ❌ | Last telemetry update | `2024-01-15T12:30:00Z` |
| `beckn:deliveryAttributes.vehicleMake` | Vehicle Make | String | ❌ | Vehicle brand | `Tata` |
| `beckn:deliveryAttributes.vehicleModel` | Vehicle Model | String | ❌ | Vehicle model | `Nexon EV` |

**Session Status Values:**
- `PENDING` - Session created, not started
- `ACTIVE` - Charging in progress
- `STOP` - Charging stopped by user/system
- `COMPLETED` - Charging finished
- `INTERRUPTED` - Charging stopped unexpectedly

**Connector Status Values (OCPP):**
- `AVAILABLE` - Connector ready for use
- `PREPARING` - Connector getting ready (cable connected)
- `UNAVAILABLE` - Connector not available

---

## Charging Telemetry

Real-time charging session metrics in `beckn:deliveryAttributes.chargingTelemetry`.

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `chargingTelemetry` | Charging Telemetry | Array[Object] | ❌ | Time-series telemetry data | `[{eventTime, metrics: [...]}]` |
| `chargingTelemetry[].eventTime` | Event Time | DateTime | ✅ | Timestamp of reading | `2025-01-27T17:00:00Z` |
| `chargingTelemetry[].metrics` | Metrics | Array[Object] | ✅ | Array of measurements | `[{name, value, unitCode}]` |
| `chargingTelemetry[].metrics[].name` | Metric Name | String | ✅ | Type of measurement | `STATE_OF_CHARGE`, `POWER`, `ENERGY`, `VOLTAGE`, `CURRENT` |
| `chargingTelemetry[].metrics[].value` | Metric Value | Number | ✅ | Measured value | `62.5` |
| `chargingTelemetry[].metrics[].unitCode` | Unit Code | String | ✅ | Unit of measurement | `PERCENTAGE`, `KWH`, `KW`, `VLT`, `AMP` |

**Metric Types:**
- `STATE_OF_CHARGE` - Battery percentage (unitCode: `PERCENTAGE`)
- `POWER` - Current charging power in kW (unitCode: `KW`)
- `ENERGY` - Total energy delivered in kWh (unitCode: `KWH`)
- `VOLTAGE` - Voltage in volts (unitCode: `VLT`)
- `CURRENT` - Current in amperes (unitCode: `AMP`)

**Notes:**
- Used in `on_track` and `on_status` APIs
- Provides real-time charging session monitoring
- Multiple telemetry events can be streamed for time-series data

---

## Tracking

Fields for real-time tracking in `beckn:fulfillments[].beckn:trackingAction`.

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `beckn:trackingAction.@type` | Type | String | ✅ | Action type | `schema:TrackAction` |
| `beckn:trackingAction.schema:target` | Target | Object | ✅ | Tracking target | `{@type: "schema:EntryPoint", ...}` |
| `beckn:trackingAction.schema:target.schema:urlTemplate` | URL Template | String | ✅ | Tracking URL | `https://track.example.com/session/SESSION-123` |
| `beckn:trackingAction.schema:object` | Object | Object | ✅ | Tracked entity | `{schema:identifier: "RESERVATION-12345"}` |

---

## Payment

Fields in `message.order.beckn:payment` for payment handling.

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `beckn:payment.@context` | Context | URL | ✅ | Payment context | `https://becknprotocol.io/.../Payment/schema-context.jsonld` |
| `beckn:payment.@type` | Type | String | ✅ | Payment type | `beckn:Payment` |
| `beckn:payment.beckn:id` | Payment ID | String | ✅ | Unique payment identifier | `payment-123e4567-e89b-12d3-a456-426614174000` |
| `beckn:payment.beckn:amount` | Amount | Object | ✅ | Payment amount | `{currency: "INR", value: 143.95}` |
| `beckn:payment.beckn:paymentURL` | Payment URL | URL | ❌ | Payment link | `https://pay.example.com?order=12345` |
| `beckn:payment.beckn:txnRef` | Transaction Reference | String | ❌ | Transaction reference | `TXN-123456789` |
| `beckn:payment.beckn:paidAt` | Paid At | DateTime | ❌ | Payment timestamp | `2025-12-19T10:05:00Z` |
| `beckn:payment.beckn:beneficiary` | Beneficiary | String | ❌ | Payment recipient | `BAP`, `BPP`, `BUYER` |
| `beckn:payment.beckn:paymentStatus` | Payment Status | String | ✅ | Current status | `PENDING`, `COMPLETED`, `REFUNDED` |
| `beckn:payment.beckn:upiTransactionId` | UPI Transaction ID | String | ❌ | UPI payment reference | `UPI123456789012` |

**Payment Status Values:**
- `INITIATED` - Payment initiated
- `PENDING` - Payment pending
- `AUTHORIZED` - Payment authorized
- `COMPLETED` - Payment successful
- `FAILED` - Payment failed
- `REFUNDED` - Payment refunded

---

## Order Value

Fields in `message.order.beckn:orderValue` for pricing breakdown.

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `beckn:orderValue.@type` | Type | String | ✅ | Price type | `schema:PriceSpecification` |
| `beckn:orderValue.schema:priceCurrency` | Currency | String | ✅ | Currency code | `INR` |
| `beckn:orderValue.schema:price` | Total Price | Number | ✅ | Total amount | `55.00` |
| `beckn:orderValue.components` | Price Components | Array[Object] | ❌ | Price breakdown | `[{type, value, currency, description}]` |
| `beckn:orderValue.components[].type` | Component Type | String | ✅ | Cost category | `UNIT`, `FEE`, `SURCHARGE`, `DISCOUNT` |
| `beckn:orderValue.components[].value` | Value | Number | ✅ | Component amount | `112.5` |
| `beckn:orderValue.components[].currency` | Currency | String | ✅ | Currency code | `INR` |
| `beckn:orderValue.components[].description` | Description | String | ❌ | Component description | `Base charging session cost (45 INR/kWh × 2.5 kWh)` |

**Component Types:**
- `UNIT` - Base unit cost (energy charges)
- `FEE` - Service/platform fees (service fee, buyer finder fee, overcharge estimation)
- `SURCHARGE` - Additional charges (surge pricing, peak hour charges)
- `DISCOUNT` - Price reductions

---

## Payment Settlement

Fields in `beckn:payment.beckn:paymentAttributes` for settlement accounts.

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `beckn:paymentAttributes.@context` | Context | URL | ✅ | PaymentSettlement context | `https://raw.githubusercontent.com/.../PaymentSettlements/v1/context.jsonld` |
| `beckn:paymentAttributes.@type` | Type | String | ✅ | Type identifier | `PaymentSettlement` |
| `beckn:paymentAttributes.settlementAccounts` | Settlement Accounts | Array[Object] | ✅ | List of settlement accounts | `[{beneficiaryId, accountNumber, ...}]` |
| `settlementAccounts[].beneficiaryId` | Beneficiary ID | String | ✅ | Beneficiary identifier | `example-bap.com`, `example-bpp.com` |
| `settlementAccounts[].accountHolderName` | Account Holder | String | ✅ | Account holder name | `Example BAP Solutions Pvt Ltd` |
| `settlementAccounts[].accountNumber` | Account Number | String | ✅ | Bank account number | `9876543210123` |
| `settlementAccounts[].ifscCode` | IFSC Code | String | ✅ | Bank IFSC code | `HDFC0009876` |
| `settlementAccounts[].bankName` | Bank Name | String | ❌ | Name of the bank | `HDFC Bank` |
| `settlementAccounts[].vpa` | VPA | String | ❌ | Virtual Payment Address | `example-bap@paytm` |

**Notes:**
- `beneficiaryId` identifies the entity (BAP or BPP domain)
- Multiple settlement accounts can be provided for different beneficiaries
- Used in `init`, `on_init`, `on_confirm` APIs

---

## Rating & Feedback

Fields for rating submission and response.

### Rating Input (rating request)

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `message.ratings` | Ratings | Array[Object] | ✅ | Array of rating inputs | `[{@type: "beckn:RatingInput", ...}]` |
| `message.ratings[].@context` | Context | URL | ✅ | Rating context | `https://raw.githubusercontent.com/.../context.jsonld` |
| `message.ratings[].@type` | Type | String | ✅ | Rating type | `beckn:RatingInput` |
| `message.ratings[].id` | Reference ID | String | ✅ | What to rate | `fulfillment-001` |
| `message.ratings[].ratingValue` | Rating Value | Number | ✅ | Rating score | `4` |
| `message.ratings[].bestRating` | Best Rating | Number | ✅ | Maximum possible | `5` |
| `message.ratings[].worstRating` | Worst Rating | Number | ✅ | Minimum possible | `1` |
| `message.ratings[].category` | Category | String | ✅ | Rating category | `FULFILLMENT`, `PROVIDER`, `ITEM`, `ORDER` |
| `message.ratings[].feedback` | Feedback | Object | ❌ | Structured feedback | `{comments, tags: [...]}` |
| `message.ratings[].feedback.comments` | Comments | String | ❌ | User review text | `Excellent charging experience!` |
| `message.ratings[].feedback.tags` | Tags | Array[String] | ❌ | Feedback tags | `["fast-charging", "clean-station"]` |

**Rating Categories:**
- `FULFILLMENT` - Rate the charging session experience
- `PROVIDER` - Rate the charging station operator
- `ITEM` - Rate the specific charging equipment
- `ORDER` - Rate the overall order experience

### Rating Output (on_rating response)

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `message.received` | Received | Boolean | ✅ | Rating acknowledgement | `true` |
| `message.feedbackForm` | Feedback Form | Object | ❌ | Additional feedback form | `{url, mime_type, submission_id}` |
| `message.feedbackForm.url` | Form URL | URL | ✅ | Feedback form link | `https://example-bpp.com/feedback/portal` |
| `message.feedbackForm.mime_type` | MIME Type | String | ❌ | Form content type | `application/xml` |
| `message.feedbackForm.submission_id` | Submission ID | String | ❌ | Feedback submission reference | `feedback-123e4567-e89b...` |

---

## Support

Fields for support requests and responses.

### Support Request

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `message.support.beckn:ref_id` | Reference ID | String | ✅ | Entity needing support | `order-12345` |
| `message.support.beckn:ref_type` | Reference Type | String | ✅ | Type of entity | `ORDER`, `FULFILLMENT`, `ITEM`, `PROVIDER` |
| `message.support.beckn:issue` | Issue | String | ❌ | Problem description | `Payment not processing` |

**Reference Types:**
- `ORDER` - Support for order-level issues
- `FULFILLMENT` - Support for charging session problems
- `ITEM` - Support for specific charging station issues
- `PROVIDER` - General support from operator

### Support Information (on_support response)

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `message.supportInfo.beckn:phone` | Support Phone | String | ❌ | Phone number | `1800-123-4567` |
| `message.supportInfo.beckn:email` | Support Email | String | ❌ | Email address | `support@example.com` |
| `message.supportInfo.beckn:url` | Support URL | URL | ❌ | Help center | `https://help.example.com` |
| `message.supportInfo.beckn:supportTicketURL` | Ticket URL | URL | ❌ | Create ticket | `https://support.example.com/create` |

---

## Cancellation

Fields for order cancellation.

### Cancellation Request (cancel)

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `message.cancellationRequest.beckn:reason` | Reason | String | ❌ | Reason text | `User changed plans` |
| `message.cancellationRequest.beckn:reasonCode` | Reason Code | String | ✅ | Standardized code | `USER_CANCELLED`, `NO_SHOW`, `TECHNICAL_ISSUE` |
| `message.cancellationRequest.beckn:requestedBy` | Requested By | String | ✅ | Who cancelled | `BUYER`, `PROVIDER` |

**Reason Codes:**
- `USER_CANCELLED` - Buyer cancelled voluntarily
- `NO_SHOW` - Buyer didn't show up for reservation
- `TECHNICAL_ISSUE` - Technical problem with station
- `PROVIDER_CANCELLED` - Provider cancelled the service

### Cancellation Terms (on_cancel response)

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `message.cancellationTerms.beckn:refundAmount` | Refund Amount | Number | ❌ | Amount refunded | `45.00` |
| `message.cancellationTerms.beckn:cancellationFee` | Cancellation Fee | Number | ❌ | Fee charged | `10.00` |
| `message.cancellationTerms.beckn:refundPolicy` | Refund Policy | String | ❌ | Policy details | `Full refund if cancelled 1hr before` |

---

## Data Type Reference

### Common Data Types

| Type | Format | Example | Notes |
|------|--------|---------|-------|
| String | Text | `"example"` | UTF-8 encoded text |
| Number | Numeric | `45.5` | Integer or decimal |
| Integer | Whole number | `128` | No decimal places |
| Boolean | true/false | `true` | Logical value |
| DateTime | ISO 8601 | `2024-01-15T10:30:00Z` | UTC timezone recommended |
| Date | ISO 8601 | `2024-01-15` | Date only |
| Time | HH:MM:SS | `10:30:00` | 24-hour format |
| Duration | ISO 8601 | `PT30S` | Period notation |
| URL | Web address | `https://example.com` | Full URL with protocol |
| UUID | UUID v4 | `2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002` | Unique identifier |
| Array | List | `[1, 2, 3]` | Ordered collection |
| Object | JSON object | `{"key": "value"}` | Key-value pairs |

### GeoJSON Coordinate Order

⚠️ **Important**: GeoJSON always uses `[longitude, latitude]` order, which is opposite to common usage:
- ✅ Correct: `[77.5946, 12.9716]` (longitude first)
- ❌ Wrong: `[12.9716, 77.5946]` (latitude first)

### Unit Codes (UN/CEFACT)

Common unit codes used in EV charging:
- `KWH` - Kilowatt-hour (energy)
- `KW` - Kilowatt (power)
- `HUR` - Hour (time)
- `MIN` - Minute (time)
- `MTR` - Meter (distance)

### Currency Codes (ISO 4217)

- `INR` - Indian Rupee
- `USD` - US Dollar
- `EUR` - Euro
- `GBP` - British Pound

---

## API Flow Examples

### Discovery Flow
1. **discover** → Search for charging stations
2. **on_discover** ← Receive catalog of stations

### Booking Flow
3. **select** → Select station and charging amount
4. **on_select** ← Receive order confirmation with pricing
5. **init** → Initialize order with buyer details
6. **on_init** ← Receive order with payment details
7. **confirm** → Confirm order with payment method
8. **on_confirm** ← Receive confirmed order with BPP order ID

### Charging Flow
9. **update** → Start charging session (with OTP)
10. **on_update** ← Receive active session details
11. **track** → Track charging progress
12. **on_track** ← Receive real-time charging data
13. **on_status** ← Receive status updates (interruptions, completion)
14. **on_update** ← Receive final billing

### Post-Service Flow
15. **rating** → Submit rating and feedback
16. **on_rating** ← Receive aggregate ratings
17. **support** → Request support
18. **on_support** ← Receive support contact info

### Cancellation Flow
19. **cancel** → Cancel order/reservation
20. **on_cancel** ← Receive cancellation terms and refund details

### Catalog Publish Flow
21. **catalog_publish** → BPP publishes catalog to discovery indexer
22. **on_catalog_publish** ← Receive indexing results

---

## Catalog Publish

Fields for catalog publishing to discovery indexers.

### Catalog Publish Request

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `context.action` | Action | String | ✅ | API action | `catalog_publish` |
| `message.catalogs` | Catalogs | Array[Object] | ✅ | Catalogs to publish | `[{@type: "beckn:Catalog", ...}]` |

### Catalog Publish Response (on_catalog_publish)

| Field Path | Field Name | Type | Required | Description | Example |
|------------|-----------|------|----------|-------------|---------|
| `context.action` | Action | String | ✅ | API action | `on_catalog_publish` |
| `message.results` | Results | Array[Object] | ✅ | Indexing results | `[{catalog_id, status, ...}]` |
| `message.results[].catalog_id` | Catalog ID | String | ✅ | Published catalog ID | `catalog-ev-charging-001` |
| `message.results[].status` | Status | String | ✅ | Publish status | `ACCEPTED`, `REJECTED` |
| `message.results[].item_count` | Item Count | Integer | ❌ | Items indexed | `42` |
| `message.results[].warnings` | Warnings | Array[Object] | ❌ | Non-fatal issues | `[{code, message}]` |
| `message.results[].warnings[].code` | Warning Code | String | ✅ | Warning type | `NON_NORMALIZED_BRAND` |
| `message.results[].warnings[].message` | Warning Message | String | ✅ | Warning description | `Some brand values were normalized` |
| `message.results[].error` | Error | Object | ❌ | Rejection details | `{code, message, paths}` |
| `message.results[].error.code` | Error Code | String | ✅ | Error type | `INVALID_ITEM` |
| `message.results[].error.message` | Error Message | String | ✅ | Error description | `Invalid item payload at index 3` |
| `message.results[].error.paths` | Error Paths | String | ❌ | Path to invalid data | `catalogs[1].items[3]` |

**Status Values:**
- `ACCEPTED` - Catalog successfully indexed
- `REJECTED` - Catalog rejected due to validation errors

---

## Additional Resources

- [Beckn Protocol Specification](https://github.com/beckn/protocol-specifications)
- [Schema.org Documentation](https://schema.org/)
- [GeoJSON Specification](https://geojson.org/)
- [CQL2 Specification](https://docs.ogc.org/is/21-065r2/21-065r2.html)
- [UN/CEFACT Unit Codes](https://unece.org/trade/uncefact/cl-recommendations)
- [ISO 4217 Currency Codes](https://www.iso.org/iso-4217-currency-codes.html)

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2024-10-30 | Initial comprehensive field reference |
| 1.1 | 2026-01-07 | Added buyerAttributes, chargingTelemetry, chargingStation, vehicleType, catalog_publish, orderAttributes, updated payment and rating fields |

---

## Contributing

If you find any errors or have suggestions for improvement, please submit an issue or pull request to the repository.

---

**Generated for**: Beckn V2 EV Charging API Examples  
**Location**: `/Users/akarsh/ubc-tsd/Example-schemas/`  
**Last Updated**: January 7, 2026

