# Unified Bharat e-Charge (UBC) - Technical Specification Document v0.9 <!-- omit from toc -->

<div align="center">
  <img width="600" alt="image" src="https://github.com/user-attachments/assets/188b1aca-f22f-4cb8-9d54-67949118c74d" />
</div>


## Table of Contents <!-- omit from toc -->
* [Disclaimer](#1-disclaimer)
* [Abstract](#2-abstract)
* [Introduction](#3-introduction)
* [Scope](#4-scope)
* [Intended Audience](#5-intended-audience)
* [Conventions and Terminology](#6-conventions-and-terminology)
* [Terminology](#7-terminology)
* [Reference Architecture](#8-reference-architecture)
* [Creating an Open Network for EV Charging](#9-creating-an-open-network-for-ev-charging)
* [Implementing EV Charging Semantics on Beckn Protocol](#10-implementing-ev-charging-semantics-on-beckn-protocol)
* [User Stories](#11-user-stories)
* [Special Corner Cases](#12-special-corner-cases)
* [Conclusion](#13-conclusion)

---

## 1. Disclaimer
This is a TSD for implementing EV charging use cases using the Beckn Protocol. It provides implementation guidance for anyone to build interoperable EV charging applications that integrate with each other on a decentralized network while maintaining compatibility with OCPI standards for CPO communication.

## 2. Abstract
This document proposes a practical way to make EV charging services easier to find and use by applying the Beckn Protocol's distributed commerce model. Instead of juggling multiple apps and accounts for different charging networks, EV users on any Beckn protocol-enabled consumer platform (a.k.a BAPs) can discover and book charging services from Beckn protocol-enabled provider platforms (a.k.a BPPs) that have onboarded one or more Charge Point Operators (CPOs).

EV users can discover, compare options, view transparent pricing, and reserve a slot at any eligible charging station owned or operated by CPOs. By standardizing discovery, pricing, and booking, the approach tackles three persistent barriers to EV adoption: charging anxiety, network fragmentation, and payment complexity.

Built on Beckn's commerce capabilities and aligned with OCPI for technical interoperability, the implementation lets e-Mobility Service Providers (eMSPs) aggregate services from multiple CPOs while delivering a consistent, app-agnostic experience to consumers.

## 3. Introduction
This document provides an implementation guidance for deploying EV charging services using the Beckn Protocol ecosystem. It specifically addresses how consumer applications can provide unified access to charging infrastructure across multiple Charge Point Operators while maintaining technical compatibility with existing OCPI-based systems.

## 4. Scope
**This document covers:**
* Architecture patterns for EV charging marketplace implementation using Beckn Protocol
* Discovery and charging mechanisms for charging EVs across multiple CPOs
* Some recommendations for BAPs, BPPs and NOs on how to map protocol API calls to internal systems (or vice-versa)
* Real-time availability and pricing integration with OCPI-based systems
* Session management and billing coordination between Beckn and OCPI protocols

**This document does NOT cover:**
* Detailed OCPI protocol specifications (refer to OCPI 2.2.1 documentation)
* Physical charging infrastructure requirements and standards
* Regulatory compliance beyond technical implementation (varies by jurisdiction)
* Smart grid integration and load management systems

## 5. Intended Audience
* **Consumer Application Developers (BAPs):** Building EV driver-facing charging applications with unified cross-network access
* **e-Mobility Service Providers (eMSPs/BPPs):** Implementing charging service aggregation platforms across multiple CPO networks
* **Charge Point Operators (CPOs):** Understanding integration requirements for Beckn-enabled marketplace participation
* **Technology Integrators:** Building bridges between existing OCPI infrastructure and new Beckn-based marketplaces
* **System Architects:** Designing scalable, interoperable EV charging ecosystems
* **Business Stakeholders:** Understanding technical capabilities and implementation requirements for EV charging marketplace strategies
* **Standards Organizations:** Evaluating interoperability approaches for future EV charging standards development

## 6. Conventions and Terminology
The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described below:

* **MUST:** The term "MUST" implies an absolute requirement.
* **MUST NOT:** The term "MUST NOT" indicates an absolute prohibition.
* **REQUIRED:** The term "REQUIRED" is synonymous with "MUST".
* **SHALL:** The term "SHALL" is equivalent to "MUST".
* **SHALL NOT:** The term "SHALL NOT" is equivalent to "MUST NOT".
* **SHOULD:** The term "SHOULD" indicates a strong recommendation.
* **SHOULD NOT:** The term "SHOULD NOT" indicates a strong recommendation against.
* **RECOMMENDED:** The term "RECOMMENDED" is synonymous with "SHOULD".
* **MAY:** The term "MAY" indicates that an item is truly optional.
* **OPTIONAL:** The term "OPTIONAL" is synonymous with "MAY".

## 7. Terminology

| Acronym | Full Form/Description | Description |
| :--- | :--- | :--- |
| **BAP** | Buyer Application Platform | Consumer-facing application that initiates transactions. Mapped to EV users and eMSPs. |
| **BPP** | Buyer Provider Platform | Service provider platform that responds to BAP requests. Mapped to CPOs. |
| **NO** | Network Operator | Organization responsible for the adoption and growth of the network. Usually the custodian of the network's registry. |
| **CDS** | Catalog Discovery Service | Enables discovery of charging services from BPPs in the network. |
| **eMSP** | e-Mobility Service Provider | Service provider that aggregates multiple CPOs. Generally onboarded by BAPs. |
| **CPO** | Charge Point Operator | Entity that owns and operates charging infrastructure. Generally onboarded by BPPs. |
| **EVSE** | Electric Vehicle Supply Equipment | Individual charging station unit. Owned and operated by CPOs. |
| **OCPI** | Open Charge Point Interface | Protocol for communication between eMSPs and CPOs. |

> **Note:** This document does not detail the mapping between Beckn Protocol and OCPI. Please refer to this document for the same. BPPs are NOT aggregators. Any CPO that has implemented a Beckn Protocol endpoint is a BPP. For all sense and purposes, CPOs are essentially BPPs and eMSPs are essentially BAPs.
> Network Operator (NO) would be NPCI BHIM SERVICES LIMITED (NBSL). Both NO and NBSL may be used interchangeably.

## 8. Reference Architecture
The section defines the reference ecosystem architecture that is used for building this implementation guide.

### 8.1. Architecture Diagram
<img width="2818" height="1200" alt="image" src="https://github.com/user-attachments/assets/6aecfdc2-3d80-4ce1-ad95-1346e4096200" />


### 8.2. Actors
* Catalog Discovery Service
* Buyer Application Platforms
* Buyer Provider Platforms
* Distributed Registry

### 8.3. Roles and Responsibilities of the Network Participants (BAP & BPP)
**The BAP is responsible for:**
* **Service Discovery:** Discovers available charging services and chargers on the network.
* **Booking and Transactions:** Interfaces with the BPP to avail offers, check dynamic pricing, and book charging services.
* **Session Management:** Views and tracks active charging sessions.
* **User Actions:** Allows customers to cancel orders, rate services, and contact support.

**The BPP is responsible for:**
* **Inventory & Services:** Maintains a live inventory of chargers and charging services.
* **Service Publication:** Publishes a catalog of its businesses, products, and services to other network participants.
* **Pricing & Terms:** Calculates pricing (statically or dynamically) and publishes its terms of service.
* **Bookings & Updates:** Receives bookings from Applications for charging services.
* **Customer Interaction:** Provides status updates on charging sessions, offers tracking information, and provides support details.
* **Feedback:** Allows its services to be rated by users and can request feedback.

### 8.4. Roles and Responsibilities of the Network Operator (NBSL)
* **Certifications:** As a network operator, we are responsible for certifying the BAP and BPP platforms to ensure they meet our standards for participation in the network. This process ensures trust and reliability within the ecosystem.
* **Registry:**
    * The network maintains a distributed registry that stores the certifications for both the Application (BAP) and the BPP (CPO). This registry holds the general schema of each BAP & BPP, including key links and the certificates we provide to validate their existence on the network.
    * The distributed nature of the registry means both the BAP & BPP are accessing this data from the same network they are a part of.
* **Data Handling:** As a network operator, NBSL would be requiring specific data to facilitate smooth and efficient transactions. Caching would help to improve performance and responsiveness across the network.
* **Endpoint:** The endpoints of the network participants (BAPs, BPPs) are stored to ensure requests are routed correctly and quickly.
* **Public Keys:** The public keys of the network participants are stored for message validation and security.
* **Search Catalogs:** We cache the search stored from various CPOs to speed up the discovery process when a user searches for a charging station in terms of presence and availability.

### 8.5. CDS - The Catalog Discovery Service
The CDS is responsible for handling discover API calls initiated by a BAP. It serves as the intermediary service that facilitates the discovery of available catalogs from BPPs within the network.

The CDS takes in the discover call from the BAP. Now the CDS has dual functionalities, where in, it would act as a fan-out feature and would have the choice to cache the presence and availability of BPPs. This is enabled with the publish API, where the BPPs would upload their catalog information. Here the **charging connectors** are placed as items. The items uploaded, along with their corresponding offers, would have time-based and expiry bound validity associated with them. The catalog, in terms of availability, is categorized as available and unavailable.

#### 8.5.1 CDS with respect to the flow:
1. The discover API call is made to the CDS. The CDS will validate the sender BAP.
2. The CDS looks at the needs of the discover call and then would correspond that with the internal cache first and sends back the response to the BAP with the corresponding catalog through the on_discover call. If there is no availability currently, then there would be a fan-out, and the CDS will send out the same request to the BPPs who aren't caching their data.
3. The on_discover is sent to the BAP through the CDS even if a fan out occurs and BPPs individually respond with on_discover.

#### 8.5.2 Publishing catalog within the CDS

The Catalog Discovery Service (CDS) provides a centralized mechanism for Buyer Provider Platforms (BPPs) to cache their service catalogs within the network infrastructure. This architectural capability significantly enhances network efficiency by decoupling the discovery process from the real-time operational availability of individual BPPs. By caching catalog data, the CDS can independently service discovery requests from Buyer Application Platforms (BAPs), aggregating disparate provider data into a single, unified catalog response. This approach not only ensures a faster response time for the end-user but also reduces the computational load and infrastructure robustness required for BPPs to handle high-frequency discovery traffic. To utilize this caching capability, providers must transmit their catalog details using the `catalog_publish` API.

**8.5.2.1. action: catalog_publish**
* **Method:** POST
<details>
<summary><a href="../Example-schemas/21_publish/ev-charging-catalog-publish.json">Example json :rocket:</a></summary>

```json
{
    "context": {
        "version": "2.0.0",
        "action": "catalog_publish",
        "timestamp": "2025-12-19T10:05:00Z",
        "message_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
        "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
        "bpp_id": "example-bpp.com",
        "bpp_uri": "[https://example-bpp.com/pilot/bap/energy/v2](https://example-bpp.com/pilot/bap/energy/v2)",
        "ttl": "PT30S"
    },
    "message": {
        "catalogs": [
            {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
                "@type": "beckn:Catalog",
                "beckn:id": "catalog-ev-charging-001",
                "beckn:descriptor": {
                    "@type": "beckn:Descriptor",
                    "schema:name": "EV Charging Services Network",
                    "beckn:shortDesc": "Comprehensive network of fast charging stations across Bengaluru"
                },
                "beckn:bppId": "bpp.ev-network.example.com",
                "beckn:bppUri": "[https://bpp.ev-network.example.com/bpp](https://bpp.ev-network.example.com/bpp)",
                "beckn:items": [
                    {
                        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
                        "@type": "beckn:Item",
                        "beckn:id": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
                        "beckn:descriptor": {
                            "@type": "beckn:Descriptor",
                            "schema:name": "DC Fast Charger - CCS2 (60kW)",
                            "beckn:shortDesc": "High-speed DC charging station with CCS2 connector",
                            "beckn:longDesc": "Ultra-fast DC charging station supporting CCS2 connector type with 60kW maximum power output. Features advanced thermal management and smart charging capabilities."
                        },
                        "beckn:category": {
                            "@type": "schema:CategoryCode",
                            "schema:codeValue": "ev-charging",
                            "schema:name": "EV Charging"
                        },
                        "beckn:availabilityWindow": [
                            {
                                "@type": "beckn:TimePeriod",
                                "schema:startTime": "06:00:00",
                                "schema:endTime": "22:00:00"
                            }
                        ],
                        "beckn:rateable": true,
                        "beckn:rating": {
                            "@type": "beckn:Rating",
                            "beckn:ratingValue": 4.5,
                            "beckn:ratingCount": 128
                        },
                        "beckn:isActive": true,
                        "beckn:provider": {
                            "beckn:id": "ecopower-charging",
                            "beckn:descriptor": {
                                "@type": "beckn:Descriptor",
                                "schema:name": "EcoPower Charging Pvt Ltd"
                            }
                        },
                        "beckn:itemAttributes": {
                            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld)",
                            "@type": "ChargingService",
                            "connectorType": "CCS2",
                            "maxPowerKW": 60,
                            "minPowerKW": 5,
                            "reservationSupported": true,
                            "chargingStation": {
                                "id": "IN-ECO-BTM-STATION-01",
                                "serviceLocation": {
                                    "@type": "beckn:Location",
                                    "geo": {
                                        "type": "Point",
                                        "coordinates": [
                                            77.5946,
                                            12.9716
                                        ]
                                    },
                                    "address": {
                                        "streetAddress": "EcoPower BTM Hub, 100 Ft Rd",
                                        "addressLocality": "Bengaluru",
                                        "addressRegion": "Karnataka",
                                        "postalCode": "560076",
                                        "addressCountry": "IN"
                                    }
                                }
                            },
                            "amenityFeature": [
                                "RESTAURANT",
                                "RESTROOM",
                                "WI-FI"
                            ],
                            "evseId": "IN*ECO*BTM*01*CCS2*A",
                            "parkingType": "Mall",
                            "powerType": "DC",
                            "connectorFormat": "CABLE",
                            "chargingSpeed": "FAST",
                            "vehicleType": "4-WHEELER"
                        }
                    },
                    {
                        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
                        "@type": "beckn:Item",
                        "beckn:id": "IND*greencharge-koramangala*cs-02*IN*GC*KOR*01*CCS2*A*CCS2-B",
                        "beckn:descriptor": {
                            "@type": "beckn:Descriptor",
                            "schema:name": "DC Fast Charger - CCS2 (120kW)",
                            "beckn:shortDesc": "Ultra-fast DC charging station with CCS2 connector",
                            "beckn:longDesc": "Ultra-fast DC charging station supporting CCS2 connector type with 120kW maximum power output. Features liquid cooling and advanced power management."
                        },
                        "beckn:category": {
                            "@type": "schema:CategoryCode",
                            "schema:codeValue": "ev-charging",
                            "schema:name": "EV Charging"
                        },
                        "beckn:availabilityWindow": [
                            {
                                "@type": "beckn:TimePeriod",
                                "schema:startTime": "00:00:00",
                                "schema:endTime": "23:59:59"
                            }
                        ],
                        "beckn:rateable": true,
                        "beckn:rating": {
                            "@type": "beckn:Rating",
                            "beckn:ratingValue": 4.7,
                            "beckn:ratingCount": 89
                        },
                        "beckn:isActive": true,
                        "beckn:provider": {
                            "beckn:id": "greencharge-koramangala",
                            "beckn:descriptor": {
                                "@type": "beckn:Descriptor",
                                "schema:name": "GreenCharge Energy Solutions"
                            }
                        },
                        "beckn:itemAttributes": {
                            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld)",
                            "@type": "ChargingService",
                            "connectorType": "CCS2",
                            "maxPowerKW": 120,
                            "minPowerKW": 10,
                            "reservationSupported": true,
                            "chargingStation": {
                                "id": "cs-02",
                                "serviceLocation": {
                                    "@type": "beckn:Location",
                                    "geo": {
                                        "type": "Point",
                                        "coordinates": [
                                            77.6104,
                                            12.9153
                                        ]
                                    },
                                    "address": {
                                        "streetAddress": "GreenCharge Koramangala, 80 Ft Rd",
                                        "addressLocality": "Bengaluru",
                                        "addressRegion": "Karnataka",
                                        "postalCode": "560034",
                                        "addressCountry": "IN"
                                    }
                                }
                            },
                            "amenityFeature": [
                                "RESTAURANT",
                                "RESTROOM",
                                "WI-FI",
                                "PARKING"
                            ],
                            "evseId": "IN*GC*KOR*01*CCS2*A",
                            "parkingType": "OffStreet",
                            "powerType": "DC",
                            "connectorFormat": "CABLE",
                            "chargingSpeed": "ULTRAFAST",
                            "vehicleType": "3-WHEELER"
                        }
                    },
                    {
                        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
                        "@type": "beckn:Item",
                        "beckn:id": "IND*powergrid-indiranagar*cs-03*IN*PG*IND*01*TYPE2*A*TYPE2-A",
                        "beckn:descriptor": {
                            "@type": "beckn:Descriptor",
                            "schema:name": "AC Fast Charger - Type 2 (22kW)",
                            "beckn:shortDesc": "AC fast charging station with Type 2 connector",
                            "beckn:longDesc": "AC fast charging station supporting Type 2 connector type with 22kW maximum power output. Ideal for overnight charging and workplace charging."
                        },
                        "beckn:category": {
                            "@type": "schema:CategoryCode",
                            "schema:codeValue": "ev-charging",
                            "schema:name": "EV Charging"
                        },
                        "beckn:availabilityWindow": [
                            {
                                "@type": "beckn:TimePeriod",
                                "schema:startTime": "08:00:00",
                                "schema:endTime": "20:00:00"
                            }
                        ],
                        "beckn:rateable": true,
                        "beckn:rating": {
                            "@type": "beckn:Rating",
                            "beckn:ratingValue": 4.3,
                            "beckn:ratingCount": 156
                        },
                        "beckn:isActive": true,
                        "beckn:provider": {
                            "beckn:id": "powergrid-indiranagar",
                            "beckn:descriptor": {
                                "@type": "beckn:Descriptor",
                                "schema:name": "PowerGrid Charging Solutions"
                            }
                        },
                        "beckn:itemAttributes": {
                            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld)",
                            "@type": "ChargingService",
                            "connectorType": "Type2",
                            "maxPowerKW": 22,
                            "minPowerKW": 3,
                            "reservationSupported": true,
                            "chargingStation": {
                                "id": "cs-03",
                                "serviceLocation": {
                                    "@type": "beckn:Location",
                                    "geo": {
                                        "type": "Point",
                                        "coordinates": [
                                            77.6254,
                                            12.9716
                                        ]
                                    },
                                    "address": {
                                        "streetAddress": "PowerGrid Indiranagar, 100 Ft Rd",
                                        "addressLocality": "Bengaluru",
                                        "addressRegion": "Karnataka",
                                        "postalCode": "560008",
                                        "addressCountry": "IN"
                                    }
                                }
                            },
                            "amenityFeature": [
                                "RESTROOM",
                                "WI-FI",
                                "PARKING"
                            ],
                            "evseId": "IN*PG*IND*01*TYPE2*A",
                            "parkingType": "Office",
                            "powerType": "AC_3_PHASE",
                            "connectorFormat": "SOCKET",
                            "chargingSpeed": "NORMAL",
                            "vehicleType": "4-WHEELER"
                        }
                    }
                ],
                "beckn:offers": [
                    {
                        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
                        "@type": "beckn:Offer",
                        "beckn:id": "offer-ccs2-60kw-kwh",
                        "beckn:descriptor": {
                            "@type": "beckn:Descriptor",
                            "schema:name": "Per-kWh Tariff - CCS2 60kW"
                        },
                        "beckn:items": [
                            "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
                        ],
                        "beckn:price": {
                            "currency": "INR",
                            "value": 45.0,
                            "applicableQuantity": {
                                "unitText": "Kilowatt Hour",
                                "unitCode": "KWH",
                                "unitQuantity": 1
                            }
                        },
                        "beckn:validity": {
                            "@type": "beckn:TimePeriod",
                            "schema:startDate": "2025-10-01T00:00:00Z",
                            "schema:endDate": "2026-03-31T23:59:59Z"
                        },
                        "beckn:acceptedPaymentMethod": [
                            "UPI",
                            "CREDIT_CARD",
                            "WALLET"
                        ],
                        "beckn:offerAttributes": {
                            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingOffer/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingOffer/v1/context.jsonld)",
                            "@type": "ChargingOffer",
                            "tariffModel": "PER_KWH",
                            "idleFeePolicy": {
                                "currency": "INR",
                                "value": 2,
                                "applicableQuantity": {
                                    "unitCode": "MIN",
                                    "unitText": "minutes",
                                    "unitQuantity": 10
                                }
                            }
                        },
                        "beckn:provider": "ecopower-charging"
                    },
                    {
                        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
                        "@type": "beckn:Offer",
                        "beckn:id": "offer-ccs2-120kw-kwh",
                        "beckn:descriptor": {
                            "@type": "beckn:Descriptor",
                            "schema:name": "Per-kWh Tariff - CCS2 120kW"
                        },
                        "beckn:items": [
                            "IND*greencharge-koramangala*cs-02*IN*GC*KOR*01*CCS2*A*CCS2-B"
                        ],
                        "beckn:price": {
                            "currency": "INR",
                            "value": 22.0,
                            "applicableQuantity": {
                                "unitText": "Kilowatt Hour",
                                "unitCode": "KWH",
                                "unitQuantity": 1
                            }
                        },
                        "beckn:validity": {
                            "@type": "beckn:TimePeriod",
                            "schema:startDate": "2025-10-15T00:00:00Z",
                            "schema:endDate": "2026-04-15T23:59:59Z"
                        },
                        "beckn:acceptedPaymentMethod": [
                            "UPI",
                            "CREDIT_CARD",
                            "WALLET",
                            "BANK_TRANSFER"
                        ],
                        "beckn:offerAttributes": {
                            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingOffer/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingOffer/v1/context.jsonld)",
                            "@type": "ChargingOffer",
                            "tariffModel": "PER_KWH",
                            "idleFeePolicy": {
                                "currency": "INR",
                                "value": 3,
                                "applicableQuantity": {
                                    "unitCode": "MIN",
                                    "unitText": "minutes",
                                    "unitQuantity": 15
                                }
                            }
                        },
                        "beckn:provider": "greencharge-koramangala"
                    },
                    {
                        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
                        "@type": "beckn:Offer",
                        "beckn:id": "offer-type2-22kw-kwh",
                        "beckn:descriptor": {
                            "@type": "beckn:Descriptor",
                            "schema:name": "Per-kWh Tariff - Type 2 22kW"
                        },
                        "beckn:items": [
                            "IND*powergrid-indiranagar*cs-03*IN*PG*IND*01*TYPE2*A*TYPE2-A"
                        ],
                        "beckn:price": {
                            "currency": "INR",
                            "value": 15.0,
                            "applicableQuantity": {
                                "unitText": "Kilowatt Hour",
                                "unitCode": "KWH",
                                "unitQuantity": 1
                            }
                        },
                        "beckn:validity": {
                            "@type": "beckn:TimePeriod",
                            "schema:startDate": "2025-10-20T00:00:00Z",
                            "schema:endDate": "2026-04-20T23:59:59Z"
                        },
                        "beckn:acceptedPaymentMethod": [
                            "UPI",
                            "CREDIT_CARD",
                            "WALLET",
                            "BANK_TRANSFER"
                        ],
                        "beckn:offerAttributes": {
                            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingOffer/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingOffer/v1/context.jsonld)",
                            "@type": "ChargingOffer",
                            "tariffModel": "PER_KWH",
                            "idleFeePolicy": {
                                "currency": "INR",
                                "value": 1,
                                "applicableQuantity": {
                                    "unitCode": "MIN",
                                    "unitText": "minutes",
                                    "unitQuantity": 30
                                }
                            }
                        },
                        "beckn:provider": "powergrid-indiranagar"
                    }
                ]
            }
        ]
    }
}
```
</details>

* **Successful Catalog Upload** 
<details>
<summary><a href="../Example-schemas/21_publish/ev-charging-catalog-on_publish.json">Example json :rocket:</a></summary>
  
```json
{
    "ack_status": "ACK",
    "timestamp": "2025-10-14T07:32:05Z"
}
```
</details>

> **Note:** It is imperative to understand the structural composition of the catalog, which is architected as an aggregation of `items` and `offers`. Within this framework, the `item` serves as the fundamental, root-level entity. In the specific context of the EV charging ecosystem, an `item` maps directly to an individual charging connector. Consequently, catalog implementation must treat every `item` entry as a distinct connector instance. Furthermore, the `item:id` attribute must be populated in strict adherence to the recommended nomenclature to ensure the unique and standardized identification of each connector within the network.

## 9. Creating an Open Network for EV Charging
The open network for EV charging requires all the EV charging BAPs, BPPs, to be able to discover each other and become part of a common network. This network is manifested in the form of a Distributed Registry maintained by NBSL (the Network Operator).

### 9.1. Distributed Registry
A Distributed Registry is a decentralized registry accessible to all network participants (NPs). It provides an authoritative source for network-wide identity, addressability, and certification of participants.
The Distributed Registry acts as the root of addressability and trust within the network. It maintains comprehensive details for each participant, including:
* The participant's globally unique identifier (ID)
* Network Address (Beckn API URL)
* Public keys for digital signatures
* Operational domains
* Assigned roles (e.g. BAP or BPP)

In addition to managing participant registration, authentication, authorization and permission control, the Registry also oversees participant verification, activation, and lifecycle management. This ensures that only validated and authorized entities can operate within the network.

Each participant published their details (including public keys and endpoints) in their respective registries. They public keys facilitate secure validation and signed communication between BAPs and BPPs.

We at NBSL shall be onboarding the participants post certification. Within the registry all the participants will place the session identifiers and their corresponding public keys. The public keys will help during validation of the rightful Network participant may they be a BAP or a BPP. Within the registry you will also have the space to put in the corresponding URLs as endpoints. Network Participants must create these records within the registry, post certification they will be added to NBSL's namespace through which they will be officially part of the network.

#### 9.1.1. For a Network Participant

**9.1.1.1. Step 1: Claiming a Namespace**
To ensure global addressability, all Network Participants (NPs)—including BAPs and BPPs—must register as users on publish.dedi.global. As part of this registration, participants are required to claim a unique namespace corresponding to their Fully Qualified Domain Name (FQDN).
To successfully claim a namespace, the user must prove domain ownership through the following whitelisting process:

***Registry Addition**: The domain must be sent in for whitelisting to the network operator.

***DNS Verification**: Post whitelisting the user must retrieve the DNS TXT record generated within publish.dedi.global and publish it as a record within their own whitelisted domain's DNS configuration

**9.1.1.2. Step 2: Setting up a Registry**
Once the namespace is claimed, each NP MUST create a Beckn NP registry in the namespace to list their subscriber details. While creating the registry, the user MUST configure it with the subscriber schema.

**9.1.1.3. Step 3: Publishing subscriber details**
In the registry that is created, NPs MUST publish their subscription details including their ID, network endpoints, public keys, operational domains and assigned roles (BAP, BPP) as records.
Detailed steps to create namespaces and registries in publish.dedi.global can be found here.

**9.1.1.4. Step 4: Share details of the registry created with the NBSL team**
Once the registry is created and details are published, the namespace and the registry name of the newly created registry should be shared with the beckn one team.

### 9.2. Setting up the Protocol Endpoints
This section contains instructions to set up and test the protocol stack for EV charging transactions.

#### 9.2.1. Installing Beckn ONIX
All NPs SHOULD install the Beckn ONIX adapter to quickly get set up and become Beckn Protocol compliant. Click here to learn how to set up Beckn ONIX.

#### 9.2.2. Configuring Beckn ONIX for EV Charging Transactions
A detailed Configuration Guide is available here. A quick read of key concepts from the link is recommended.
Specifically, for EV Charging, please use the Configuration Guide for the following configuration:
* Configure dediregistry plugin instead of registry plugin.
* Start with using Simplekeymanager plugin during development. For production deployment, you may setup vault.

#### 9.2.3. Performing a test EV charging transaction
**Step 1:** Download the postman collection, from here.
**Step 2:** Run API calls

**If you are a BAP:**
* Configure the collection/environment variables to the newly installed Beckn ONIX adapter URL and other variables in the collection.
* Select the discover example and hit send
* You should see the EV charging service catalog response

**If you are a BPP:**
* Configure the collection/environment variables to the newly installed Beckn ONIX adapter URL and other variables in the collection.
* Select the on_status example and hit send
* You should see the response in your console

## 10. Implementing EV Charging Semantics on Beckn Protocol
This section contains recommendations and guidelines on how to implement EV Charging Services on Beckn Protocol enabled networks. To ensure global interoperability between actors of the EV charging network, the semantics of the EV charging industry need to be mapped to the core schema of Beckn Protocol. The below table summarizes key semantic mappings between the EV Charging Domain and Beckn Protocol domain.

### 10.1. Key Assumptions
* **Assumption 1:** EV charging is treated as a service, not as a physical object.
* **Assumption 2:** All CPOs have implemented OCPI interfaces

Each entity in the charging lifecycle — the service, the commercial terms, and the usage instance — maps to a well-defined semantic concept, enabling platforms to exchange information in a standardized, machine-readable way.

### 10.2. Semantic Model

| EV Charging Domain Entity | Charging Example | Semantically maps to |
| :--- | :--- | :--- |
| **Charging Station** | "DC Fast-Charging (60 kW CCS2)" | **Item** |
| **Charging Service** | "₹18 per kWh", "₹150 per hour", "₹999 monthly pass", "Off-peak discount 2 AM–5 AM" | **Offer** |
| **Charging Session** | A specific booking or usage instance created when the user plugs in or reserves a slot | **Order** |

### 10.3. Example Category Codes
The following section contains example category codes that can be used:

#### Charger types
| Code | What it means |
| :--- | :--- |
| **AC_SLOW** | AC charge points in the "slow" band (≈ 3–7 kW). |
| **AC_FAST** | AC "fast" public charging (≈ 7–22 kW; UK fast band 8–49 kW covers AC up to ~22 kW). |
| **DC_FAST** | DC "rapid/fast" typically ~50–149 kW. |
| **DC_ULTRA** | DC "ultra-rapid/ultra-fast", ≥ 150 kW (also aligns with AFIR focus on ≥ 150 kW corridors). |

#### Connector types
| Code | What it means |
| :--- | :--- |
| **TYPE1** | Type 1 (SAE J1772) AC connector (North America/JP usage). |
| **TYPE2** | Type 2 (IEC 62196-2) AC connector; EU standard. |
| **CCS2** | Combined Charging System "Combo 2" (IEC 62196 based) enabling high-power DC on Type 2. |
| **CHADEMO** | CHAdeMO DC fast-charging standard. |
| **GB_T** | China's GB/T charging standard (AC & DC). |

#### Service types
| Code | What it means |
| :--- | :--- |
| **GREEN_ENERGY_CERTIFIED** | Flag that the site/session is supplied by verified green energy per catalog metadata (e.g., OCPI EnergyMix.is_green_energy). |
| **GO_EU** | Energy backed by EU Guarantees of Origin (GOs). |
| **REGO_UK** | Energy backed by the UK Renewable Energy Guarantees of Origin (REGO) scheme. |
| **I_REC** | Energy backed by I-REC certificates (international EACs). |
| **V2G_ENABLED** | Charger/site supports bidirectional power transfer (V2G), e.g., per ISO 15118-20 implementations. |
| **REMOTE_START_STOP** | Remote start/stop of sessions exposed via roaming interface (OCPI Commands module). |



## 11. User Stories

### 11.1. User Story – 1 - Walk-In to a charging station without reservation
This section covers a walk-in case where users discover the charger using third-party apps, word of mouth, or Beckn API, and then drive to the location, plug in their EV and charge their vehicle.

#### 11.1.1. Consumer User Journey
A sales manager, Arjun, drives an EV to client meetings. He's time-bound, cost-conscious, and prefers simple, scan-and-go experiences. Arjun arrives at a large dine-in restaurant for a one-hour client meeting. He notices a charging bay in the parking lot and decides to top up while he's inside.

**Discovery and Selection:**
Arjun opens his EV app, taps "Scan & Charge," and immediately scans the QR code on the charger unit. The app rapidly retrieves all critical charger details:
* Connector Type: CCS2
* Power Rating: 50 kW DC Fast Charger
* Live Status: Available
* Tariff: ₹18.00/kWh
* Active Offers: A Lunch-Hour Promo is highlighted, offering 10% off between 12:00 PM and 2:00 PM.

**Order and Authorization**
Arjun opts for a cost-based top-up to manage his budget effectively.
* **Session Selection:** Arjun selects a session limit of ₹450.00.
* **Review and Confirmation:** He reviews the session terms, which clearly state:
    * Rate: ₹18.00/kWh (with a 10% auto-applied discount expected during the session).
    * Idle Fee Window: 10 minutes grace period post-session completion to avoid surcharges.
    * Cancellation Rules: Free cancellation is allowed before physically plugging in and initiating charging.
* **Payment Authorization:** He confirms the order and chooses UPI for authorization. The app instantly processes an authorization hold of ₹450.00 on his account.
* **ID Generation:** The app instantly returns a unique Booking/Transaction ID for the confirmed session reservation.

**Fulfilment and Real-time Monitoring**
Arjun plugs the cable into his EV's charging port and initiates the session directly from the app before heading into his meeting.
* **Session Start:** The charging session begins, and since it is within the promotional time window, the Lunch-Hour Promo discount (10%) is automatically applied, setting the effective rate to ₹16.20/kWh.
* **Live Progress:** While Arjun is in his meeting, the app provides a live dashboard showing the session's progress:
    * Energy Delivered (kWh): Real-time consumption, increasing second-by-second.
    * Cost Consumed (₹): The monetary value spent, tracking towards the ₹450.00 limit.
    * Estimated Kilowatt-Hours Remaining: An estimation of how much more energy can be delivered within the cost limit.
* **Status Alerts:** Immediate notification if the session speed is derated or if charging is unexpectedly interrupted.

**Post-Fulfilment and Reconciliation**
The charging session will terminate when the ₹450.00 cost limit is reached, or if the vehicle's SOC reaches 100%, whichever occurs first.
* **Session Stop:** Upon reaching the cost limit, the charging session automatically ceases. A notification is sent to Arjun's phone reminding him to unplug his vehicle promptly.
* **Digital Summary:** Arjun immediately receives a digital invoice and a comprehensive session summary in his app, which details:
    * Total Energy Delivered (e.g., 27.78 kWh).
    * Discount Applied (10% on the total energy cost).
    * Final Billed Amount (₹450.00).
* **Automatic Reconciliation:** If the session is interrupted or stops before the full ₹450.00 is consumed (e.g., only ₹325.00 worth of energy was delivered), the system automatically reconciles the payment:
    * The system calculates the exact cost for the energy delivered (e.g., ₹325.00).
    * It initiates an automatic refund/adjustment (e.g., ₹125.00) from the initial ₹450.00 authorization hold back to Arjun's UPI source, ensuring he is billed only for the energy actually consumed.

#### 11.1.2. API Calls and Schema
*Note: The API calls and schema for walk-in charging are identical to the advance reservation use case with minor differences in timing and availability. Where sections reference Use Case 2, the same API structure, field definitions, and examples apply unless specifically noted otherwise.*

**11.1.2.1. action: discover**
* **Method:** POST
* **Use Cases:** Raghav scans QR code on charger using his BAP user app.
<details>
<summary><a href="../Example-schemas/01_discover/discovery-by-QR.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "discover",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "app.example.com",
    "bap_uri": "[https://app.example.com/bap](https://app.example.com/bap)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "a1eabf26-29f5-4a01-9d4e-4c5c9d1a3d02",
    "timestamp": "2025-10-14T07:31:00Z",
    "ttl": "PT30S",
    "schema_context": [
      "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld)"
    ]
  },
  "message": {
    "filters": {
      "type": "jsonpath",
      "expression": "$[?(@.beckn:id == 'IND*CP01*cs-01*evse-01*connectorid-01')]"
    }
  }
}
```
</details>

**11.1.2.2. action: on_discover**
* **Method:** POST
* **Use Cases:** The app receives the charger's details (connector, power rating, live status, tariff, any active time-bound offer).
<details>
<summary><a href="../Example-schemas/02_on_discover/specific-item-catalog.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "on_discover",
    "domain": "beckn.one:deg:ev-charging:*",
    "timestamp": "2024-01-15T10:30:05Z",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "a1eabf26-29f5-4a01-9d4e-4c5c9d1a3d02",
    "bap_id": "app.example.com",
    "bap_uri": "[https://app.example.com/bap](https://app.example.com/bap)",
    "ttl": "PT30S",
    "bpp_id": "example-cds.com",
    "bpp_uri": "[https://example-cds.com/pilot/cds/energy/v2](https://example-cds.com/pilot/cds/energy/v2)"
  },
  "message": {
    "catalogs": [
      {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
        "@type": "beckn:Catalog",
        "beckn:id": "catalog-ev-charging-001",
        "beckn:descriptor": {
          "@type": "beckn:Descriptor",
          "schema:name": "EV Charging Services Network",
          "beckn:shortDesc": "Comprehensive network of fast charging stations across Bengaluru"
        },
        "beckn:bppId": "bpp.ev-network.example.com",
        "beckn:bppUri": "[https://bpp.ev-network.example.com/bpp](https://bpp.ev-network.example.com/bpp)",
        "beckn:items": [
          {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
            "@type": "beckn:Item",
            "beckn:id": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
            "beckn:descriptor": {
              "@type": "beckn:Descriptor",
              "schema:name": "DC Fast Charger - CCS2 (60kW)",
              "beckn:shortDesc": "High-speed DC charging station with CCS2 connector",
              "beckn:longDesc": "Ultra-fast DC charging station supporting CCS2 connector type with 60kW maximum power output. Features advanced thermal management and smart charging capabilities."
            },
            "beckn:category": {
              "@type": "schema:CategoryCode",
              "schema:codeValue": "ev-charging",
              "schema:name": "EV Charging"
            },
            "beckn:availabilityWindow": [
              {
                "@type": "beckn:TimePeriod",
                "schema:startTime": "06:00:00",
                "schema:endTime": "22:00:00"
              }
            ],
            "beckn:rateable": true,
            "beckn:rating": {
              "@type": "beckn:Rating",
              "beckn:ratingValue": 4.5,
              "beckn:ratingCount": 128
            },
            "beckn:isActive": true,
            "beckn:provider": {
              "beckn:id": "ecopower-charging",
              "beckn:descriptor": {
                "@type": "beckn:Descriptor",
                "schema:name": "EcoPower Charging Pvt Ltd"
              }
            },
            "beckn:itemAttributes": {
              "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld)",
              "@type": "ChargingService",
              "connectorType": "CCS2",
              "maxPowerKW": 60,
              "minPowerKW": 5,
              "reservationSupported": true,
              "chargingStation": {
                "id": "IN-ECO-BTM-STATION-01",
                "serviceLocation": {
                  "@type": "beckn:Location",
                  "geo": {
                    "type": "Point",
                    "coordinates": [
                      77.5946,
                      12.9716
                    ]
                  },
                  "address": {
                    "streetAddress": "EcoPower BTM Hub, 100 Ft Rd",
                    "addressLocality": "Bengaluru",
                    "addressRegion": "Karnataka",
                    "postalCode": "560076",
                    "addressCountry": "IN"
                  }
                }
              },
              "amenityFeature": [
                "RESTAURANT",
                "RESTROOM",
                "WI-FI"
              ],
              "evseId": "IN*ECO*BTM*01*CCS2*A",
              "parkingType": "Mall",
              "powerType": "DC",
              "connectorFormat": "CABLE",
              "chargingSpeed": "FAST",
              "vehicleType": "4-WHEELER"
            }
          }
        ],
        "beckn:offers": [
          {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
            "@type": "beckn:Offer",
            "beckn:id": "eco-charge-offer-ccs2-60kw-kwh",
            "beckn:descriptor": {
              "@type": "beckn:Descriptor",
              "schema:name": "Per-kWh Tariff - CCS2 60kW"
            },
            "beckn:items": [
              "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
            ],
            "beckn:price": {
              "currency": "INR",
              "value": 45.0,
              "applicableQuantity": {
                "unitText": "Kilowatt Hour",
                "unitCode": "KWH",
                "unitQuantity": 1
              }
            },
            "beckn:validity": {
              "@type": "beckn:TimePeriod",
              "schema:startDate": "2025-10-10T00:00:00Z",
              "schema:endDate": "2026-04-10T23:59:59Z"
            },
            "beckn:acceptedPaymentMethod": [
              "UPI",
              "CREDIT_CARD",
              "WALLET"
            ],
            "beckn:offerAttributes": {
              "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingOffer/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingOffer/v1/context.jsonld)",
              "@type": "ChargingOffer",
              "tariffModel": "PER_KWH",
              "idleFeePolicy": {
                "currency": "INR",
                "value": 2,
                "applicableQuantity": {
                  "unitCode": "MIN",
                  "unitText": "minutes",
                  "unitQuantity": 10
                }
              }
            },
            "beckn:provider": "GoGreen-charging"
          },
          {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
            "@type": "beckn:Offer",
            "beckn:id": "go-green-offer-ccs2-60kw-kwh",
            "beckn:descriptor": {
              "@type": "beckn:Descriptor",
              "schema:name": "Per-kWh Tariff - CCS2 60kW"
            },
            "beckn:items": [
              "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
            ],
            "beckn:price": {
              "currency": "INR",
              "value": 18.5,
              "applicableQuantity": {
                "unitText": "Kilowatt Hour",
                "unitCode": "KWH",
                "unitQuantity": 1
              }
            },
            "beckn:validity": {
              "@type": "beckn:TimePeriod",
              "schema:startDate": "2025-10-20T00:00:00Z",
              "schema:endDate": "2026-04-20T23:59:59Z"
            },
            "beckn:acceptedPaymentMethod": [
              "UPI",
              "CREDIT_CARD"
            ],
            "beckn:offerAttributes": {
              "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingOffer/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingOffer/v1/context.jsonld)",
              "@type": "ChargingOffer",
              "tariffModel": "PER_KWH",
              "idleFeePolicy": {
                "currency": "INR",
                "value": 2,
                "applicableQuantity": {
                  "unitCode": "MIN",
                  "unitText": "minutes",
                  "unitQuantity": 10
                }
              }
            },
            "beckn:provider": "GoGreen-charging"
          }
        ]
      }
    ]
  }
}
```
</details>

**11.1.2.3. action: select**
* **Method:** POST
* **Use Cases:** Raghav selects a service offering from the options he gets. He chooses a 100 INR top-up.
<details>
<summary><a href="../Example-schemas/03_select/ev-charging-select.json">Example json :rocket:</a></summary>

```json
{
    "context": {
        "version": "2.0.0",
        "action": "select",
        "domain": "beckn.one:deg:ev-charging:*",
        "timestamp": "2024-01-15T10:30:00Z",
        "message_id": "bb9f86db-9a3d-4e9c-8c11-81c8f1a7b901",
        "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
        "bap_id": "example-bap.com",
        "bap_uri": "[https://api.example-bap.com/pilot/bap/energy/v2](https://api.example-bap.com/pilot/bap/energy/v2)",
        "bpp_id": "example-bpp.com",
        "bpp_uri": "[https://example-bpp.com/pilot/bap/energy/v2](https://example-bpp.com/pilot/bap/energy/v2)",
        "ttl": "PT30S"
    },
    "message": {
        "order": {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
            "@type": "beckn:Order",
            "beckn:orderStatus": "CREATED",
            "beckn:seller": "ecopower-charging",
            "beckn:buyer": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
                "@type": "beckn:Buyer",
                "beckn:id": "user-123",
                "beckn:role": "BUYER",
                "beckn:displayName": "Ravi Kumar",
                "beckn:telephone": "+91-9876543210",
                "beckn:email": "ravi.kumar@example.com",
                "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
            },
            "beckn:orderItems": [
                {
                    "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
                    "beckn:quantity": {
                        "unitText": "Kilowatt Hour",
                        "unitCode": "KWH",
                        "unitQuantity": 2.5
                    },
                    "beckn:acceptedOffer": {
                        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                        "@type": "beckn:Offer",
                        "beckn:id": "offer-ccs2-60kw-kwh",
                        "beckn:descriptor": {
                            "@type": "beckn:Descriptor",
                            "schema:name": "Per-kWh Tariff - CCS2 60kW"
                        },
                        "beckn:items": [
                            "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
                        ],
                        "beckn:provider": "ecopower-charging",
                        "beckn:price": {
                            "currency": "INR",
                            "value": 45.0,
                            "applicableQuantity": {
                                "unitText": "Kilowatt Hour",
                                "unitCode": "KWH",
                                "unitQuantity": 1
                            }
                        }
                    }
                }
            ],
            "beckn:orderAttributes": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld)",
                "@type": "ChargingSession",
                "buyerFinderFee": {
                    "feeType": "PERCENTAGE",
                    "feeValue": 2.5
                },
                "preferences": {
                    "startTime": "2025-12-20T10:00:00Z",
                    "endTime": "2025-12-20T11:30:00Z"
                }
            }
        }
    }
}
```
</details>

**11.1.2.4. action: on_select**
* **Method:** POST
* **Use Cases:** Raghav receives estimated quotations for the selected service.
<details>
<summary><a href="../Example-schemas/04_on_select/ev-charging-on_select.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "on_select",
    "domain": "beckn.one:deg:ev-charging:*",
    "timestamp": "2024-01-15T10:30:05Z",
    "message_id": "bb9f86db-9a3d-4e9c-8c11-81c8f1a7b901",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
    "ttl": "PT30S",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:orderStatus": "CREATED",
      "beckn:seller": "ecopower-charging",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123",
        "beckn:role": "BUYER",
        "beckn:displayName": "Ravi Kumar",
        "beckn:telephone": "+91-9876543210",
        "beckn:email": "ravi.kumar@example.com",
        "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
          "beckn:quantity": {
            "unitText": "Kilowatt Hour",
            "unitCode": "KWH",
            "unitQuantity": 2.5
          },
          "beckn:acceptedOffer": {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
            "@type": "beckn:Offer",
            "beckn:id": "offer-ccs2-60kw-kwh",
            "beckn:descriptor": {
              "@type": "beckn:Descriptor",
              "schema:name": "Per-kWh Tariff - CCS2 60kW"
            },
            "beckn:items": [
              "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
            ],
            "beckn:provider": "ecopower-charging",
            "beckn:price": {
              "currency": "INR",
              "value": 45.0,
              "applicableQuantity": {
                "unitText": "Kilowatt Hour",
                "unitCode": "KWH",
                "unitQuantity": 1
              }
            }
          },
          "beckn:price": {
            "currency": "INR",
            "value": 45.0,
            "applicableQuantity": {
              "unitText": "Kilowatt Hour",
              "unitCode": "KWH",
              "unitQuantity": 1
            }
          }
        }
      ],
      "beckn:orderValue": {
        "currency": "INR",
        "value": 143.95,
        "components": [
          {
            "type": "UNIT",
            "value": 112.5,
            "currency": "INR",
            "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
          },
          {
            "type": "SURCHARGE",
            "value": 20.0,
            "currency": "INR",
            "description": "Surge price (20%)"
          },
          {
            "type": "DISCOUNT",
            "value": -15.0,
            "currency": "INR",
            "description": "Offer discount (15%)"
          },
          {
            "type": "FEE",
            "value": 10.0,
            "currency": "INR",
            "description": "Service fee"
          },
          {
            "type": "FEE",
            "value": 13.64,
            "currency": "INR",
            "description": "Overcharge estimation"
          },
          {
            "type": "FEE",
            "value": 2.81,
            "currency": "INR",
            "description": "Buyer finder fee (2.5%)"
          }
        ]
      },
      "beckn:orderAttributes": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld)",
        "@type": "ChargingSession",
        "buyerFinderFee": {
          "feeType": "PERCENTAGE",
          "feeValue": 2.5
        },
        "preferences": {
          "startTime": "2025-12-20T10:00:00Z",
          "endTime": "2025-12-20T11:30:00Z"
        }
      }
    }
  }
}
```
</details>


**11.1.2.5. action: init**
* **Method:** POST
* **Use Cases:** Raghav provides his billing information.
<details>
<summary><a href="../Example-schemas/05_init/ev-charging-init-bpp.json">Example json :rocket:</a></summary>

```json
{
    "context": {
        "version": "2.0.0",
        "action": "init",
        "domain": "beckn.one:deg:ev-charging:*",
        "bpp_id": "example-bpp.com",
        "bpp_uri": "[https://example-bpp.com/pilot/bap/energy/v2](https://example-bpp.com/pilot/bap/energy/v2)",
        "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
        "message_id": "6743e9e2-4fb5-487c-92b7-13ba8018f176",
        "timestamp": "2025-01-27T10:00:00Z",
        "ttl": "PT30S",
        "bap_id": "example-bap.com",
        "bap_uri": "[https://api.example-bap.com/pilot/bap/energy/v2](https://api.example-bap.com/pilot/bap/energy/v2)"
    },
    "message": {
        "order": {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
            "@type": "beckn:Order",
            "beckn:orderStatus": "CREATED",
            "beckn:seller": "cpo1.com",
            "beckn:buyer": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Buyer",
                "beckn:id": "user-123",
                "beckn:role": "BUYER",
                "beckn:displayName": "Ravi Kumar",
                "beckn:telephone": "+91-9876543210",
                "beckn:email": "ravi.kumar@example.com",
                "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
            },
            "beckn:orderItems": [
                {
                    "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
                    "beckn:quantity": {
                        "unitText": "Kilowatt Hour",
                        "unitCode": "KWH",
                        "unitQuantity": 2.5
                    },
                    "beckn:price": {
                        "currency": "INR",
                        "value": 45.0,
                        "applicableQuantity": {
                            "unitText": "Kilowatt Hour",
                            "unitCode": "KWH",
                            "unitQuantity": 1
                        }
                    }
                }
            ],
            "beckn:orderValue": {
                "currency": "INR",
                "value": 143.95,
                "components": [
                    {
                        "type": "UNIT",
                        "value": 112.5,
                        "currency": "INR",
                        "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
                    },
                    {
                        "type": "SURCHARGE",
                        "value": 20.0,
                        "currency": "INR",
                        "description": "Surge price (20%)"
                    },
                    {
                        "type": "DISCOUNT",
                        "value": -15.0,
                        "currency": "INR",
                        "description": "Offer discount (15%)"
                    },
                    {
                        "type": "FEE",
                        "value": 10.0,
                        "currency": "INR",
                        "description": "Service fee"
                    },
                    {
                        "type": "FEE",
                        "value": 13.64,
                        "currency": "INR",
                        "description": "Overcharge estimation"
                    },
                    {
                        "type": "FEE",
                        "value": 2.81,
                        "currency": "INR",
                        "description": "Buyer finder fee (2.5%)"
                    }
                ]
            },
            "beckn:payment": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Payment",
                "beckn:amount": {
                    "currency": "INR",
                    "value": 143.95
                },
                "beckn:beneficiary": "BPP",
                "beckn:paymentStatus": "INITIATED",
                "beckn:paymentAttributes": {
                    "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/PaymentSettlement/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/PaymentSettlement/v1/context.jsonld)",
                    "@type": "PaymentSettlement",
                    "settlementAccounts": [
                        {
                            "beneficiaryType": "BAP",
                            "accountHolderName": "Example BAP Solutions Pvt Ltd",
                            "accountNumber": "9876543210123",
                            "ifscCode": "HDFC0009876",
                            "bankName": "HDFC Bank",
                            "vpa": "example-bap@paytm"
                        }
                    ]
                }
            }
        }
    }
}

```
</details>

**11.1.2.6. action: on_init**
* **Method:** POST
* **Use Cases:** Raghav receives the charging session terms (rate, idle fee window, cancellation rules, payment terms etc). He reviews the terms. He chooses UPI and authorizes payment.
<details>
<summary><a href="../Example-schemas/06_on_init/ev-charging-on_init-bpp.json">Example json :rocket:</a></summary>

```json
{
    "context": {
        "version": "2.0.0",
        "action": "on_init",
        "domain": "beckn.one:deg:ev-charging:*",
        "bap_id": "example-bap.com",
        "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
        "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
        "message_id": "6743e9e2-4fb5-487c-92b7-13ba8018f176",
        "timestamp": "2025-01-27T10:00:00Z",
        "ttl": "PT30S",
        "bpp_id": "example-bpp.com",
        "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
    },
    "message": {
        "order": {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
            "@type": "beckn:Order",
            "beckn:id": "order-ev-charging-001",
            "beckn:orderStatus": "CREATED",
            "beckn:seller": "cpo1.com",
            "beckn:buyer": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Buyer",
                "beckn:id": "user-123",
                "beckn:role": "BUYER",
                "beckn:displayName": "Ravi Kumar",
                "beckn:telephone": "+91-9876543210",
                "beckn:email": "ravi.kumar@example.com",
                "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
            },
            "beckn:orderItems": [
                {
                    "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
                    "beckn:quantity": {
                        "unitText": "Kilowatt Hour",
                        "unitCode": "KWH",
                        "unitQuantity": 2.5
                    },
                    "beckn:price": {
                        "currency": "INR",
                        "value": 45.0,
                        "applicableQuantity": {
                            "unitText": "Kilowatt Hour",
                            "unitCode": "KWH",
                            "unitQuantity": 1
                        }
                    }
                }
            ],
            "beckn:orderValue": {
                "currency": "INR",
                "value": 143.95,
                "components": [
                    {
                        "type": "UNIT",
                        "value": 112.5,
                        "currency": "INR",
                        "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
                    },
                    {
                        "type": "SURCHARGE",
                        "value": 20.0,
                        "currency": "INR",
                        "description": "Surge price (20%)"
                    },
                    {
                        "type": "DISCOUNT",
                        "value": -15.0,
                        "currency": "INR",
                        "description": "Offer discount (15%)"
                    },
                    {
                        "type": "FEE",
                        "value": 10.0,
                        "currency": "INR",
                        "description": "Service fee"
                    },
                    {
                        "type": "FEE",
                        "value": 13.64,
                        "currency": "INR",
                        "description": "Overcharge estimation"
                    },
                    {
                        "type": "FEE",
                        "value": 2.81,
                        "currency": "INR",
                        "description": "Buyer finder fee (2.5%)"
                    }
                ]
            },
            "beckn:payment": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Payment",
                "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
                "beckn:amount": {
                    "currency": "INR",
                    "value": 143.95
                },
                "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
                "beckn:txnRef": "TXN-123456789",
                "beckn:beneficiary": "BPP",
                "beckn:acceptedPaymentMethod": [
                    "BANK_TRANSFER",
                    "UPI",
                    "WALLET"
                ],
                "beckn:paymentStatus": "INITIATED",
                "beckn:paymentAttributes": {
                    "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/PaymentSettlement/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/PaymentSettlement/v1/context.jsonld)",
                    "@type": "PaymentSettlement",
                    "settlementAccounts": [
                        {
                            "beneficiaryType": "BAP",
                            "accountHolderName": "Example BAP Solutions Pvt Ltd",
                            "accountNumber": "9876543210123",
                            "ifscCode": "HDFC0009876",
                            "bankName": "HDFC Bank",
                            "vpa": "example-bap@paytm"
                        },
                        {
                            "beneficiaryType": "BPP",
                            "accountHolderName": "EcoPower Charging Solutions Pvt Ltd",
                            "accountNumber": "1234567890123",
                            "ifscCode": "HDFC0001234",
                            "bankName": "HDFC Bank",
                            "vpa": "ecopower@paytm"
                        }
                    ]
                }
            }
        }
    }
}
```
</details>

**11.1.2.6.1. action: on_status**
* **Method:** POST
* **Use Cases:** Application then receives a notification on the completed status of the payment for the charging session.
<details>
<summary><a href="../Example-schemas/06_on_status_1/ev-charging-on_status-bpp.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "on_status",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "d4da89d5-2e42-4c36-9139-7f5682d5f104",
    "timestamp": "2025-01-27T10:05:00Z",
    "ttl": "PT30S",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "PENDING",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123",
        "beckn:role": "BUYER",
        "beckn:displayName": "Ravi Kumar",
        "beckn:telephone": "+91-9876543210",
        "beckn:email": "ravi.kumar@example.com",
        "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
          "beckn:quantity": {
            "unitText": "Kilowatt Hour",
            "unitCode": "KWH",
            "unitQuantity": 2.5
          },
          "beckn:price": {
            "currency": "INR",
            "value": 45.0,
            "applicableQuantity": {
              "unitText": "Kilowatt Hour",
              "unitCode": "KWH",
              "unitQuantity": 1
            }
          }
        }
      ],
      "beckn:orderValue": {
        "currency": "INR",
        "value": 143.95,
        "components": [
          {
            "type": "UNIT",
            "value": 112.5,
            "currency": "INR",
            "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
          },
          {
            "type": "SURCHARGE",
            "value": 20.0,
            "currency": "INR",
            "description": "Surge price (20%)"
          },
          {
            "type": "DISCOUNT",
            "value": -15.0,
            "currency": "INR",
            "description": "Offer discount (15%)"
          },
          {
            "type": "FEE",
            "value": 10.0,
            "currency": "INR",
            "description": "Service fee"
          },
          {
            "type": "FEE",
            "value": 13.64,
            "currency": "INR",
            "description": "Overcharge estimation"
          },
          {
            "type": "FEE",
            "value": 2.81,
            "currency": "INR",
            "description": "Buyer finder fee (2.5%)"
          }
        ]
      },
      "beckn:payment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Payment",
        "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
        "beckn:amount": {
          "currency": "INR",
          "value": 143.95
        },
        "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
        "beckn:txnRef": "TXN-123456789",
        "beckn:paidAt": "2025-12-19T10:05:00Z",
        "beckn:beneficiary": "BPP",
        "beckn:paymentStatus": "COMPLETED"
      }
    }
  }
}
```
</details>

**11.1.2.7. action: confirm**
* **Method:** POST
* **Use Cases:** Raghav confirms the order.
<details>
<summary><a href="../Example-schemas/07_confirm/ev-charging-confirm.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "confirm",
    "domain": "beckn.one:deg:ev-charging:*",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bap/energy/v2](https://example-bpp.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "c69b4c1e-fb7e-469d-ae90-00f4d5e82b64",
    "timestamp": "2025-01-27T10:05:00Z",
    "ttl": "PT30S",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://api.example-bap.com/pilot/bap/energy/v2](https://api.example-bap.com/pilot/bap/energy/v2)"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "PENDING",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123",
        "beckn:role": "BUYER",
        "beckn:displayName": "Ravi Kumar",
        "beckn:telephone": "+91-9876543210",
        "beckn:email": "ravi.kumar@example.com",
        "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
          "beckn:quantity": {
            "unitText": "Kilowatt Hour",
            "unitCode": "KWH",
            "unitQuantity": 2.5
          },
          "beckn:price": {
            "currency": "INR",
            "value": 45.0,
            "applicableQuantity": {
              "unitText": "Kilowatt Hour",
              "unitCode": "KWH",
              "unitQuantity": 1
            }
          }
        }
      ],
      "beckn:orderValue": {
        "currency": "INR",
        "value": 143.95,
        "components": [
          {
            "type": "UNIT",
            "value": 112.5,
            "currency": "INR",
            "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
          },
          {
            "type": "SURCHARGE",
            "value": 20.0,
            "currency": "INR",
            "description": "Surge price (20%)"
          },
          {
            "type": "DISCOUNT",
            "value": -15.0,
            "currency": "INR",
            "description": "Offer discount (15%)"
          },
          {
            "type": "FEE",
            "value": 10.0,
            "currency": "INR",
            "description": "Service fee"
          },
          {
            "type": "FEE",
            "value": 13.64,
            "currency": "INR",
            "description": "Overcharge estimation"
          },
          {
            "type": "FEE",
            "value": 2.81,
            "currency": "INR",
            "description": "Buyer finder fee (2.5%)"
          }
        ]
      },
      "beckn:payment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Payment",
        "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
        "beckn:amount": {
          "currency": "INR",
          "value": 143.95
        },
        "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
        "beckn:txnRef": "TXN-123456789",
        "beckn:paidAt": "2025-12-19T10:05:00Z",
        "beckn:beneficiary": "BPP",
        "beckn:paymentStatus": "COMPLETED"
      }
    }
  }
}
```
</details>

**11.1.2.8. action: on_confirm**
* **Method:** POST
* **Use Cases:** The application then returns a booking/transaction ID along with the other charging session details.
<details>
<summary><a href="../Example-schemas/08_00_on_confirm/ev-charging-on_confirm.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "on_confirm",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "c69b4c1e-fb7e-469d-ae90-00f4d5e82b64",
    "timestamp": "2025-01-27T10:05:00Z",
    "ttl": "PT30S",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "CONFIRMED",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123",
        "beckn:role": "BUYER",
        "beckn:displayName": "Ravi Kumar",
        "beckn:telephone": "+91-9876543210",
        "beckn:email": "ravi.kumar@example.com",
        "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
          "beckn:quantity": {
            "unitText": "Kilowatt Hour",
            "unitCode": "KWH",
            "unitQuantity": 2.5
          },
          "beckn:price": {
            "currency": "INR",
            "value": 45.0,
            "applicableQuantity": {
              "unitText": "Kilowatt Hour",
              "unitCode": "KWH",
              "unitQuantity": 1
            }
          }
        }
      ],
      "beckn:orderValue": {
        "currency": "INR",
        "value": 143.95,
        "components": [
          {
            "type": "UNIT",
            "value": 112.5,
            "currency": "INR",
            "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
          },
          {
            "type": "SURCHARGE",
            "value": 20.0,
            "currency": "INR",
            "description": "Surge price (20%)"
          },
          {
            "type": "DISCOUNT",
            "value": -15.0,
            "currency": "INR",
            "description": "Offer discount (15%)"
          },
          {
            "type": "FEE",
            "value": 10.0,
            "currency": "INR",
            "description": "Service fee"
          },
          {
            "type": "FEE",
            "value": 13.64,
            "currency": "INR",
            "description": "Overcharge estimation"
          },
          {
            "type": "FEE",
            "value": 2.81,
            "currency": "INR",
            "description": "Buyer finder fee (2.5%)"
          }
        ]
      },
      "beckn:fulfillment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Fulfillment",
        "beckn:id": "fulfillment-001",
        "beckn:mode": "RESERVATION",
        "beckn:deliveryAttributes": {
          "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld)",
          "@type": "ChargingSession",
          "connectorType": "CCS2",
          "maxPowerKW": 50,
          "sessionStatus": "PENDING"
        }
      },
      "beckn:payment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Payment",
        "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
        "beckn:amount": {
          "currency": "INR",
          "value": 143.95
        },
        "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
        "beckn:txnRef": "TXN-123456789",
        "beckn:paidAt": "2025-12-19T10:05:00Z",
        "beckn:beneficiary": "BPP",
        "beckn:paymentStatus": "COMPLETED"
      }
    }
  }
}
```
</details>

**11.1.2.8.1 action: status**
* **Method:** GET
* **Use Cases:** Raghav is asked to plug in the charger by the application.
<details>
<summary><a href="../Example-schemas/08_01_status/ev-charging-connector-status.json">Example json :rocket:</a></summary>

```json
{
    "context": {
        "version": "2.0.0",
        "action": "status",
        "domain": "beckn.one:deg:ev-charging:*",
        "bap_id": "example-bap.com",
        "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
        "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
        "message_id": "c69b4c1e-fb7e-469d-ae90-00f4d5e82b64",
        "timestamp": "2025-01-27T10:05:00Z",
        "ttl": "PT30S",
        "bpp_id": "example-bpp.com",
        "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
    },
    "message": {
        "order": {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
            "@type": "beckn:Order",
            "beckn:id": "order-ev-charging-001",
            "beckn:orderStatus": "CONFIRMED",
            "beckn:seller": "cpo1.com",
            "beckn:buyer": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Buyer",
                "beckn:id": "user-123",
                "beckn:role": "BUYER",
                "beckn:displayName": "Ravi Kumar",
                "beckn:telephone": "+91-9876543210",
                "beckn:email": "ravi.kumar@example.com",
                "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
            },
            "beckn:orderItems": [
                {
                    "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
                    "beckn:quantity": {
                        "unitText": "Kilowatt Hour",
                        "unitCode": "KWH",
                        "unitQuantity": 2.5
                    },
                    "beckn:price": {
                        "currency": "INR",
                        "value": 45.0,
                        "applicableQuantity": {
                            "unitText": "Kilowatt Hour",
                            "unitCode": "KWH",
                            "unitQuantity": 1
                        }
                    }
                }
            ],
            "beckn:orderValue": {
                "currency": "INR",
                "value": 143.95,
                "components": [
                    {
                        "type": "UNIT",
                        "value": 112.5,
                        "currency": "INR",
                        "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
                    },
                    {
                        "type": "SURCHARGE",
                        "value": 20.0,
                        "currency": "INR",
                        "description": "Surge price (20%)"
                    },
                    {
                        "type": "DISCOUNT",
                        "value": -15.0,
                        "currency": "INR",
                        "description": "Offer discount (15%)"
                    },
                    {
                        "type": "FEE",
                        "value": 10.0,
                        "currency": "INR",
                        "description": "Service fee"
                    },
                    {
                        "type": "FEE",
                        "value": 13.64,
                        "currency": "INR",
                        "description": "Overcharge estimation"
                    },
                    {
                        "type": "FEE",
                        "value": 2.81,
                        "currency": "INR",
                        "description": "Buyer finder fee (2.5%)"
                    }
                ]
            },
            "beckn:fulfillment": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Fulfillment",
                "beckn:id": "fulfillment-001",
                "beckn:mode": "RESERVATION",
                "beckn:deliveryAttributes": {
                    "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld)",
                    "@type": "ChargingSession",
                    "connectorType": "CCS2",
                    "maxPowerKW": 50,
                    "sessionStatus": "PENDING"
                }
            },
            "beckn:payment": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Payment",
                "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
                "beckn:amount": {
                    "currency": "INR",
                    "value": 143.95
                },
                "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
                "beckn:txnRef": "TXN-123456789",
                "beckn:paidAt": "2025-12-19T10:05:00Z",
                "beckn:beneficiary": "BPP",
                "beckn:paymentStatus": "COMPLETED"
            }
        }
    }
}
```
</details>

**11.1.2.8.2 action: on_status**
* **Method:** POST
* **Use Cases:** The application recieves a notification that the gun is successfully connected to the vehicle.
<details>
<summary><a href="../Example-schemas/08_02_on_status/ev-charging-connector-on_status.json">Example json :rocket:</a></summary>

```json
{
    "context": {
        "version": "2.0.0",
        "action": "on_status",
        "domain": "beckn.one:deg:ev-charging:*",
        "bap_id": "example-bap.com",
        "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
        "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
        "message_id": "c69b4c1e-fb7e-469d-ae90-00f4d5e82b64",
        "timestamp": "2025-01-27T10:05:00Z",
        "ttl": "PT30S",
        "bpp_id": "example-bpp.com",
        "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
    },
    "message": {
        "order": {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
            "@type": "beckn:Order",
            "beckn:id": "order-ev-charging-001",
            "beckn:orderStatus": "CONFIRMED",
            "beckn:seller": "cpo1.com",
            "beckn:buyer": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Buyer",
                "beckn:id": "user-123",
                "beckn:role": "BUYER",
                "beckn:displayName": "Ravi Kumar",
                "beckn:telephone": "+91-9876543210",
                "beckn:email": "ravi.kumar@example.com",
                "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
            },
            "beckn:orderItems": [
                {
                    "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
                }
            ],
            "beckn:orderValue": {
                "currency": "INR",
                "value": 143.95,
                "components": [
                    {
                        "type": "UNIT",
                        "value": 112.5,
                        "currency": "INR",
                        "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
                    },
                    {
                        "type": "SURCHARGE",
                        "value": 20.0,
                        "currency": "INR",
                        "description": "Surge price (20%)"
                    },
                    {
                        "type": "DISCOUNT",
                        "value": -15.0,
                        "currency": "INR",
                        "description": "Offer discount (15%)"
                    },
                    {
                        "type": "FEE",
                        "value": 10.0,
                        "currency": "INR",
                        "description": "Service fee"
                    },
                    {
                        "type": "FEE",
                        "value": 13.64,
                        "currency": "INR",
                        "description": "Overcharge estimation"
                    },
                    {
                        "type": "FEE",
                        "value": 2.81,
                        "currency": "INR",
                        "description": "Buyer finder fee (2.5%)"
                    }
                ]
            },
            "beckn:fulfillment": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Fulfillment",
                "beckn:id": "fulfillment-001",
                "beckn:mode": "RESERVATION",
                "beckn:deliveryAttributes": {
                    "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld)",
                    "@type": "ChargingSession",
                    "connectorType": "CCS2",
                    "maxPowerKW": 50,
                    "sessionStatus": "PENDING",
                    "connectorStatus": "PREPARING"
                }
            },
            "beckn:payment": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Payment",
                "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
                "beckn:amount": {
                    "currency": "INR",
                    "value": 143.95
                },
                "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
                "beckn:txnRef": "TXN-123456789",
                "beckn:paidAt": "2025-12-19T10:05:00Z",
                "beckn:beneficiary": "BPP",
                "beckn:paymentStatus": "COMPLETED"
            }
        }
    }
}
```
</details>

**11.1.2.9. action: update (start charging)**
* **Method:** POST
* **Use Cases:** Raghav plugs in and starts the session from the app.
<details>
<summary><a href="../Example-schemas/09_update/ev-charging-start-update.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "update",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://api.example-bap.com/pilot/bap/energy/v2](https://api.example-bap.com/pilot/bap/energy/v2)",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bap/energy/v2](https://example-bpp.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "6bd7be5b-ac21-4a5c-a787-5ec6980317e6",
    "timestamp": "2025-01-27T10:15:00Z",
    "ttl": "PT30S"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "CONFIRMED",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123",
        "beckn:role": "BUYER",
        "beckn:displayName": "Ravi Kumar",
        "beckn:telephone": "+91-9876543210",
        "beckn:email": "ravi.kumar@example.com",
        "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
        }
      ],
      "beckn:orderValue": {
        "currency": "INR",
        "value": 143.95,
        "components": [
          {
            "type": "UNIT",
            "value": 112.5,
            "currency": "INR",
            "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
          },
          {
            "type": "SURCHARGE",
            "value": 20.0,
            "currency": "INR",
            "description": "Surge price (20%)"
          },
          {
            "type": "DISCOUNT",
            "value": -15.0,
            "currency": "INR",
            "description": "Offer discount (15%)"
          },
          {
            "type": "FEE",
            "value": 10.0,
            "currency": "INR",
            "description": "Service fee"
          },
          {
            "type": "FEE",
            "value": 13.64,
            "currency": "INR",
            "description": "Overcharge estimation"
          },
          {
            "type": "FEE",
            "value": 2.81,
            "currency": "INR",
            "description": "Buyer finder fee (2.5%)"
          }
        ]
      },
      "beckn:fulfillment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Fulfillment",
        "beckn:id": "fulfillment-001",
        "beckn:mode": "RESERVATION",
        "beckn:deliveryAttributes": {
          "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld)",
          "@type": "ChargingSession",
          "connectorType": "CCS2",
          "maxPowerKW": 50,
          "sessionStatus": "PENDING"
        }
      },
      "beckn:payment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Payment",
        "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
        "beckn:amount": {
          "currency": "INR",
          "value": 143.95
        },
        "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
        "beckn:txnRef": "TXN-123456789",
        "beckn:paidAt": "2025-12-19T10:05:00Z",
        "beckn:beneficiary": "BPP",
        "beckn:paymentStatus": "COMPLETED"
      }
    }
  }
}
```
</details>

**11.1.2.10. action: on_update (start charging)**
* **Method:** POST
* **Use Cases:** Response for the charging session initiation.
<details>
<summary><a href="../Example-schemas/10_on_update/ev-charging-start-on_update.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "on_update",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "6bd7be5b-ac21-4a5c-a787-5ec6980317e6",
    "timestamp": "2025-01-27T10:15:30Z",
    "ttl": "PT30S",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "INPROGRESS",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123",
        "beckn:role": "BUYER",
        "beckn:displayName": "Ravi Kumar",
        "beckn:telephone": "+91-9876543210",
        "beckn:email": "ravi.kumar@example.com",
        "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
        }
      ],
      "beckn:orderValue": {
        "currency": "INR",
        "value": 143.95,
        "components": [
          {
            "type": "UNIT",
            "value": 112.5,
            "currency": "INR",
            "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
          },
          {
            "type": "SURCHARGE",
            "value": 20.0,
            "currency": "INR",
            "description": "Surge price (20%)"
          },
          {
            "type": "DISCOUNT",
            "value": -15.0,
            "currency": "INR",
            "description": "Offer discount (15%)"
          },
          {
            "type": "FEE",
            "value": 10.0,
            "currency": "INR",
            "description": "Service fee"
          },
          {
            "type": "FEE",
            "value": 13.64,
            "currency": "INR",
            "description": "Overcharge estimation"
          },
          {
            "type": "FEE",
            "value": 2.81,
            "currency": "INR",
            "description": "Buyer finder fee (2.5%)"
          }
        ]
      },
      "beckn:fulfillment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Fulfillment",
        "beckn:id": "fulfillment-001",
        "beckn:mode": "RESERVATION",
        "beckn:deliveryAttributes": {
          "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld)",
          "@type": "ChargingSession",
          "sessionStatus": "ACTIVE",
          "connectorType": "CCS2",
          "maxPowerKW": 50
        }
      },
      "beckn:payment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Payment",
        "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
        "beckn:amount": {
          "currency": "INR",
          "value": 143.95
        },
        "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
        "beckn:txnRef": "TXN-123456789",
        "beckn:paidAt": "2025-12-19T10:05:00Z",
        "beckn:beneficiary": "BPP",
        "beckn:paymentStatus": "COMPLETED"
      }
    }
  }
}
```
</details>

**11.1.2.11. action: track (charging-session progress)**
* **Method:** POST
* **Use Cases:** Raghav requests to track the live status of the charging session. state of charge (how much charging has been done).
<details>
<summary><a href="../Example-schemas/11_track/ev-charging-track.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "track",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://api.example-bap.com/pilot/bap/energy/v2](https://api.example-bap.com/pilot/bap/energy/v2)",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "6ace310b-6440-4421-a2ed-b484c7548bd5",
    "timestamp": "2025-01-27T17:00:40.065Z",
    "ttl": "PT30S"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "INPROGRESS",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
        }
      ]
    }
  }
}
```
</details>

**11.1.2.12. action: on_track**
* **Method:** POST
* **Use Cases:** Raghav receives the state of charge (how much charging has been done) of the vehicle.
<details>
<summary><a href="../Example-schemas/12_on_track/ev-charging-on_track.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "on_track",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "6ace310b-6440-4421-a2ed-b484c7548bd5",
    "timestamp": "2025-01-27T17:00:40.065Z",
    "ttl": "PT30S",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "INPROGRESS",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
        }
      ],
      "beckn:fulfillment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Fulfillment",
        "beckn:id": "fulfillment-001",
        "beckn:mode": "RESERVATION",
        "trackingAction": {
          "@type": "beckn:TrackAction",
          "target": {
            "@type": "schema:EntryPoint",
            "url": "[https://track.bluechargenet-aggregator.io/session/SESSION-9876543210](https://track.bluechargenet-aggregator.io/session/SESSION-9876543210)"
          }
        },
        "sessionStatus": "ACTIVE",
        "beckn:deliveryAttributes": {
          "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld)",
          "@type": "ChargingSession",
          "chargingTelemetry": [
            {
              "eventTime": "2025-01-27T17:00:00Z",
              "metrics": [
                {
                  "name": "STATE_OF_CHARGE",
                  "value": 62.5,
                  "unitCode": "PERCENTAGE"
                },
                {
                  "name": "POWER",
                  "value": 18.4,
                  "unitCode": "KWH"
                },
                {
                  "name": "ENERGY",
                  "value": 10.2,
                  "unitCode": "KW"
                },
                {
                  "name": "VOLTAGE",
                  "value": 392,
                  "unitCode": "VLT"
                },
                {
                  "name": "CURRENT",
                  "value": 47.0,
                  "unitCode": "AMP"
                }
              ]
            },
            {
              "eventTime": "2025-01-27T17:05:00Z",
              "metrics": [
                {
                  "name": "STATE_OF_CHARGE",
                  "value": 65.0,
                  "unitCode": "PERCENTAGE"
                },
                {
                  "name": "POWER",
                  "value": 17.1,
                  "unitCode": "KWH"
                },
                {
                  "name": "ENERGY",
                  "value": 11.1,
                  "unitCode": "KW"
                },
                {
                  "name": "VOLTAGE",
                  "value": 388,
                  "unitCode": "VLT"
                },
                {
                  "name": "CURRENT",
                  "value": 44.2,
                  "unitCode": "AMP"
                }
              ]
            }
          ]
        }
      }
    }
  }
}
```
</details>

**11.1.2.13. async action: on_update (stop-charging)**
* **Method:** POST
* **Use Case:** For the paid amount the session stops (or notifies the EV user to unplug). He receives a digital invoice and session summary in-app. If anything went wrong (e.g., session interrupted, SOC reaches 100%, etc.), the app reconciles to bill only for energy delivered and issues any adjustment or refund automatically.
<details>
<summary><a href="../Example-schemas/14_02_on_update/ev-charging-completed-on_update.json">Example json :rocket:</a></summary>

```json
{
    "context": {
        "version": "2.0.0",
        "action": "on_update",
        "domain": "beckn.one:deg:ev-charging:*",
        "bap_id": "example-bap.com",
        "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
        "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
        "message_id": "32f67afe-3d8c-4faa-bc2e-93b0791dcb02",
        "timestamp": "2025-01-27T11:45:00Z",
        "ttl": "PT30S",
        "bpp_id": "example-bpp.com",
        "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
    },
    "message": {
        "order": {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
            "@type": "beckn:Order",
            "beckn:id": "order-ev-charging-001",
            "beckn:orderStatus": "COMPLETED",
            "beckn:seller": "cpo1.com",
            "beckn:buyer": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Buyer",
                "beckn:id": "user-123",
                "beckn:role": "BUYER",
                "beckn:displayName": "Ravi Kumar",
                "beckn:telephone": "+91-9876543210",
                "beckn:email": "ravi.kumar@example.com",
                "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
            },
            "beckn:orderItems": [
                {
                    "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
                }
            ],
            "beckn:orderValue": {
                "currency": "INR",
                "value": 143.95,
                "components": [
                    {
                        "type": "UNIT",
                        "value": 112.5,
                        "currency": "INR",
                        "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
                    },
                    {
                        "type": "SURCHARGE",
                        "value": 20.0,
                        "currency": "INR",
                        "description": "Surge price (20%)"
                    },
                    {
                        "type": "DISCOUNT",
                        "value": -15.0,
                        "currency": "INR",
                        "description": "Offer discount (15%)"
                    },
                    {
                        "type": "FEE",
                        "value": 10.0,
                        "currency": "INR",
                        "description": "Service fee"
                    },
                    {
                        "type": "FEE",
                        "value": 13.64,
                        "currency": "INR",
                        "description": "Overcharge estimation"
                    },
                    {
                        "type": "FEE",
                        "value": 2.81,
                        "currency": "INR",
                        "description": "Buyer finder fee (2.5%)"
                    }
                ]
            },
            "beckn:fulfillment": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Fulfillment",
                "beckn:id": "fulfillment-001",
                "beckn:mode": "RESERVATION",
                "beckn:deliveryAttributes": {
                    "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld)",
                    "@type": "ChargingSession",
                    "sessionStatus": "COMPLETED"
                }
            },
            "beckn:payment": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Payment",
                "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
                "beckn:amount": {
                    "currency": "INR",
                    "value": 143.95
                },
                "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
                "beckn:txnRef": "TXN-123456789",
                "beckn:paidAt": "2025-12-19T10:05:00Z",
                "beckn:beneficiary": "BPP",
                "beckn:paymentStatus": "COMPLETED"
            }
        }
    }
}
```
</details>

**11.1.2.14. action: rating**
* **Method:** POST
* **Use Cases:** Raghav provides rating for the charging session.
<details>
<summary><a href="../Example-schemas/15_rating/ev-charging-rating.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "rating",
    "domain": "beckn.one:deg:ev-charging:*",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bap/energy/v2](https://example-bpp.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "89ee20fe-b592-48b0-a5c5-e38f6b90e569",
    "timestamp": "2025-01-27T12:00:00Z",
    "ttl": "PT30S",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://api.example-bap.com/pilot/bap/energy/v2](https://api.example-bap.com/pilot/bap/energy/v2)"
  },
  "message": {
    "ratings": [
      {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:RatingInput",
        "beckn:id": "fulfillment-001",
        "beckn:ratingValue": 4,
        "beckn:bestRating": 5,
        "beckn:worstRating": 1,
        "beckn:category": "FULFILLMENT",
        "beckn:feedback": {
          "comments": "Excellent charging experience! The station was clean, easy to find, and the charging was fast and reliable. The staff was helpful and the payment process was smooth.",
          "tags": [
            "fast-charging",
            "easy-to-use",
            "clean-station",
            "helpful-staff",
            "smooth-payment"
          ]
        }
      }
    ]
  }
}
```
</details>

**11.1.2.15. action: on_rating**
* **Method:** POST
* **Use Cases:** Raghav receives an achievement after providing a rating.
<details>
<summary><a href="../Example-schemas/16_on_rating/ev-charging-on_rating.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "on_rating",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "89ee20fe-b592-48b0-a5c5-e38f6b90e569",
    "timestamp": "2025-01-27T12:00:30Z",
    "ttl": "PT30S",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
  },
  "message": {
    "received": true,
    "feedbackForm": {
      "url": "[https://example-bpp.com/feedback/portal](https://example-bpp.com/feedback/portal)",
      "mime_type": "application/xml",
      "submission_id": "feedback-123e4567-e89b-12d3-a456-426614174000"
    }
  }
}
```
</details>

**11.1.2.16. action: support**
* **Method:** POST
* **Use Cases:** Raghav reaches out for support.
<details>
<summary><a href="../Example-schemas/17_support/ev-charging-support.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "support",
    "domain": "beckn.one:deg:ev-charging:*",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bap/energy/v2](https://example-bpp.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "dee432d9-36c9-4146-ad21-2f5bcac9b6a9",
    "timestamp": "2025-01-27T12:15:00Z",
    "ttl": "PT30S",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://api.example-bap.com/pilot/bap/energy/v2](https://api.example-bap.com/pilot/bap/energy/v2)"
  },
  "message": {
    "refId": "order-ev-charging-001",
    "refType": "ORDER",
    "support": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:SupportInfo",
      "name": "Ravi Kumar",
      "phone": "+91-9876543210",
      "email": "ravi.kumar@example.com",
      "hours": "Mon\u2013Sun: 6:00 PM - 10:00 PM IST",
      "channels": [
        "PHONE",
        "WHATSAPP"
      ]
    }
  }
}
```
</details>

**11.1.2.17. action: on_support**
* **Method:** POST
* **Use Cases:** Raghav receives a response to his support request.
<details>
<summary><a href="../Example-schemas/18_on_support/ev-charging-on_support.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "on_support",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "dee432d9-36c9-4146-ad21-2f5bcac9b6a9",
    "timestamp": "2025-01-27T12:15:30Z",
    "ttl": "PT30S",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
  },
  "message": {
    "support": {
      "name": "BlueCharge Support Team",
      "phone": "18001080",
      "email": "support@bluechargenet-aggregator.io",
      "url": "[https://support.bluechargenet-aggregator.io/ticket/SUP-20250730-001](https://support.bluechargenet-aggregator.io/ticket/SUP-20250730-001)",
      "hours": "Mon\u2013Sun 24/7 IST",
      "channels": [
        "PHONE",
        "EMAIL",
        "WEB",
        "CHAT"
      ]
    }
  }
}
```
</details>

### 11.2. User Story – 2 - Reservation of an EV charging time slot
This section covers advance reservation of a charging slot where users discover and book a charger before driving to the location.

#### 11.2.1. Consumer User Journey
Aisha is driving her electric vehicle along the highway when she notices that her battery level is getting low. Using an EV Charging application (BAP), Aisha discovers nearby charging stations that are compatible with her vehicle. The application retrieves available slots and charger specifications from the available provider's (BPP). Aisha selects a preferred charger and books a slot through the application via Beckn APIs to avoid waiting on arrival.

**Discovery and Selection:**
Aisha opens her EV Charging BAP (powered by a Beckn-enabled discovery network). She filters for:
* **Connector Type:** CCS2
* **Location:** DC Fast chargers within 5 km
* **Amenities:** Restaurants or cafes
* **Tariff Model:** Per kWh

The app queries multiple charging providers and returns options showing:
* **ETA:** Estimated time from current location
* **Real-time Availability:** Status of slots
* **Tariff:** Cost per kWh
* **Active Offers:** Lunch-hour discounts (e.g., promotional pricing)

She compares them and selects "EcoPower Highway Hub – Mandya Food Court".

**Order and Reservation:**
Aisha taps "Reserve Slot" for the 12:45 PM – 1:15 PM window.
* **Session Review:** The app displays the session terms:
    * **Tariff:** ₹18 / kWh
    * **Grace Period:** 10 min post-session
    * **Idle Fee Policy:** ₹2/min after grace
    * **Cancellation Rules:** Free up to 15 min before
    * **Payment Options:** Hold, Pre-pay, Post-pay
* **Payment and Confirmation:** She pays ₹500 via her credit card. Upon confirmation of payment receipt, the provider returns a unique Reservation ID.

**Fulfilment and Real-time Monitoring:**
On arrival at the station, Aisha initiates "Start Charging" on her application.
* **Authentication:** The backend matches the request to her Reservation ID and instructs her to plug in the charging gun.
* **Session Start:** Once connected, charging begins.
* **Live Telemetry:** While she enjoys lunch, the app provides live tracking:
    * **Energy Dispensed:** kWh delivered
    * **Elapsed Time:** Duration of the session
    * **Running Cost:** Current bill amount (₹)
    * **Completion Estimate:** Time remaining until full/target

If she arrives a few minutes late, the charger holds the slot until the grace period expires.

**Post-Fulfilment and Reconciliation:**
Charging auto-stops when the requested amount (₹500) is reached or when she manually ends the session.
* **Session Stop:** The system terminates the power flow.
* **Digital Summary:** The system issues a digital invoice and reimburces back the amount to her account.
* **Feedback:** The app prompts for quick feedback:
    * Amenity rating (1–5)
    * Overall experience (1–5)
    * Optional text comments

Satisfied, Aisha resumes her trip with time to spare.

#### 11.2.2. API Calls and Schema
> **Note:** The API calls and schema for reservation follow a similar flow to walk-in but include specific checks for availability and slot booking.*

**11.2.2.1. action: discover**
* **Method:** POST
* **Use Cases:** Aisha searches for chargers with specific filters (Location, Connector type and a time slot).
<details>
<summary><a href="../Example-schemas/01_discover/discovery-within-a-timerange.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "discover",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "app.example.com",
    "bap_uri": "[https://app.example.com/bap](https://app.example.com/bap)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "a1eabf26-29f5-4a01-9d4e-4c5c9d1a3d02",
    "timestamp": "2025-10-14T07:31:00Z",
    "ttl": "PT30S",
    "schema_context": [
      "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld)"
    ]
  },
  "message": {
    "filters": {
      "type": "jsonpath",
      "expression": "$[?(@.beckn:itemAttributes.vehicleType == '4-WHEELER' && @.beckn:itemAttributes.connectorType == 'CCS2' && @.beckn:availabilityWindow.schema:startTime <= '11:30:00' && @.beckn:availabilityWindow.schema:endTime >= '14:30:00')]"
    },
    "spatial": [
      {
        "op": "s_dwithin",
        "targets": "$['beckn:itemAttributes.chargingStation.serviceLocation.geo']",
        "geometry": {
          "type": "Point",
          "coordinates": [
            77.59,
            12.94
          ]
        },
        "distanceMeters": 10000
      }
    ]
  }
}
```
</details>

**11.2.2.2. action: on_discover**
* **Method:** POST
* **Use Cases:** The app receives a list of charging stations matching criteria, including ETA, availability, and active offers.
<details>
<summary><a href="../Example-schemas/02_on_discover/ev-charging-on_discover.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "on_discover",
    "domain": "beckn.one:deg:ev-charging:*",
    "timestamp": "2024-01-15T10:30:05Z",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "a1eabf26-29f5-4a01-9d4e-4c5c9d1a3d02",
    "bap_id": "app.example.com",
    "bap_uri": "[https://app.example.com/bap](https://app.example.com/bap)",
    "ttl": "PT30S",
    "bpp_id": "example-cds.com",
    "bpp_uri": "[https://example-cds.com/pilot/cds/energy/v2](https://example-cds.com/pilot/cds/energy/v2)"
  },
  "message": {
    "catalogs": [
      {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
        "@type": "beckn:Catalog",
        "beckn:id": "catalog-ev-charging-001",
        "beckn:descriptor": {
          "@type": "beckn:Descriptor",
          "schema:name": "EV Charging Services Network",
          "beckn:shortDesc": "Comprehensive network of fast charging stations across Bengaluru"
        },
        "beckn:bppId": "bpp.ev-network.example.com",
        "beckn:bppUri": "[https://bpp.ev-network.example.com/bpp](https://bpp.ev-network.example.com/bpp)",
        "beckn:items": [
          {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
            "@type": "beckn:Item",
            "beckn:id": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
            "beckn:descriptor": {
              "@type": "beckn:Descriptor",
              "schema:name": "DC Fast Charger - CCS2 (60kW)",
              "beckn:shortDesc": "High-speed DC charging station with CCS2 connector",
              "beckn:longDesc": "Ultra-fast DC charging station supporting CCS2 connector type with 60kW maximum power output. Features advanced thermal management and smart charging capabilities."
            },
            "beckn:category": {
              "@type": "schema:CategoryCode",
              "schema:codeValue": "ev-charging",
              "schema:name": "EV Charging"
            },
            "beckn:availabilityWindow": [
              {
                "@type": "beckn:TimePeriod",
                "schema:startTime": "06:00:00",
                "schema:endTime": "22:00:00"
              }
            ],
            "beckn:rateable": true,
            "beckn:rating": {
              "@type": "beckn:Rating",
              "beckn:ratingValue": 4.5,
              "beckn:ratingCount": 128
            },
            "beckn:isActive": true,
            "beckn:provider": {
              "beckn:id": "ecopower-charging",
              "beckn:descriptor": {
                "@type": "beckn:Descriptor",
                "schema:name": "EcoPower Charging Pvt Ltd"
              }
            },
            "beckn:itemAttributes": {
              "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld)",
              "@type": "ChargingService",
              "connectorType": "CCS2",
              "maxPowerKW": 60,
              "minPowerKW": 5,
              "reservationSupported": true,
              "chargingStation": {
                "id": "IN-ECO-BTM-STATION-01",
                "serviceLocation": {
                  "@type": "beckn:Location",
                  "geo": {
                    "type": "Point",
                    "coordinates": [
                      77.5946,
                      12.9716
                    ]
                  },
                  "address": {
                    "streetAddress": "EcoPower BTM Hub, 100 Ft Rd",
                    "addressLocality": "Bengaluru",
                    "addressRegion": "Karnataka",
                    "postalCode": "560076",
                    "addressCountry": "IN"
                  }
                }
              },
              "amenityFeature": [
                "RESTAURANT",
                "RESTROOM",
                "WI-FI"
              ],
              "evseId": "IN*ECO*BTM*01*CCS2*A",
              "parkingType": "Mall",
              "powerType": "DC",
              "connectorFormat": "CABLE",
              "chargingSpeed": "FAST",
              "vehicleType": "4-WHEELER"
            }
          },
          {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
            "@type": "beckn:Item",
            "beckn:id": "IND*greencharge-koramangala*cs-02*IN*GC*KOR*01*CCS2*A*CCS2-B",
            "beckn:descriptor": {
              "@type": "beckn:Descriptor",
              "schema:name": "DC Fast Charger - CCS2 (120kW)",
              "beckn:shortDesc": "Ultra-fast DC charging station with CCS2 connector",
              "beckn:longDesc": "Ultra-fast DC charging station supporting CCS2 connector type with 120kW maximum power output. Features liquid cooling and advanced power management."
            },
            "beckn:category": {
              "@type": "schema:CategoryCode",
              "schema:codeValue": "ev-charging",
              "schema:name": "EV Charging"
            },
            "beckn:availabilityWindow": [
              {
                "@type": "beckn:TimePeriod",
                "schema:startTime": "00:00:00",
                "schema:endTime": "23:59:59"
              }
            ],
            "beckn:rateable": true,
            "beckn:rating": {
              "@type": "beckn:Rating",
              "beckn:ratingValue": 4.7,
              "beckn:ratingCount": 89
            },
            "beckn:isActive": true,
            "beckn:provider": {
              "beckn:id": "greencharge-koramangala",
              "beckn:descriptor": {
                "@type": "beckn:Descriptor",
                "schema:name": "GreenCharge Energy Solutions"
              }
            },
            "beckn:itemAttributes": {
              "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld)",
              "@type": "ChargingService",
              "connectorType": "CCS2",
              "maxPowerKW": 120,
              "minPowerKW": 10,
              "reservationSupported": true,
              "chargingStation": {
                "id": "cs-02",
                "serviceLocation": {
                  "@type": "beckn:Location",
                  "geo": {
                    "type": "Point",
                    "coordinates": [
                      77.6104,
                      12.9153
                    ]
                  },
                  "address": {
                    "streetAddress": "GreenCharge Koramangala, 80 Ft Rd",
                    "addressLocality": "Bengaluru",
                    "addressRegion": "Karnataka",
                    "postalCode": "560034",
                    "addressCountry": "IN"
                  }
                }
              },
              "amenityFeature": [
                "RESTAURANT",
                "RESTROOM",
                "WI-FI",
                "PARKING"
              ],
              "evseId": "IN*GC*KOR*01*CCS2*A",
              "parkingType": "OffStreet",
              "powerType": "DC",
              "connectorFormat": "CABLE",
              "chargingSpeed": "ULTRAFAST",
              "vehicleType": "3-WHEELER"
            }
          },
          {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
            "@type": "beckn:Item",
            "beckn:id": "IND*powergrid-indiranagar*cs-03*IN*PG*IND*01*TYPE2*A*TYPE2-A",
            "beckn:descriptor": {
              "@type": "beckn:Descriptor",
              "schema:name": "AC Fast Charger - Type 2 (22kW)",
              "beckn:shortDesc": "AC fast charging station with Type 2 connector",
              "beckn:longDesc": "AC fast charging station supporting Type 2 connector type with 22kW maximum power output. Ideal for overnight charging and workplace charging."
            },
            "beckn:category": {
              "@type": "schema:CategoryCode",
              "schema:codeValue": "ev-charging",
              "schema:name": "EV Charging"
            },
            "beckn:availabilityWindow": [
              {
                "@type": "beckn:TimePeriod",
                "schema:startTime": "08:00:00",
                "schema:endTime": "20:00:00"
              }
            ],
            "beckn:rateable": true,
            "beckn:rating": {
              "@type": "beckn:Rating",
              "beckn:ratingValue": 4.3,
              "beckn:ratingCount": 156
            },
            "beckn:isActive": true,
            "beckn:provider": {
              "beckn:id": "powergrid-indiranagar",
              "beckn:descriptor": {
                "@type": "beckn:Descriptor",
                "schema:name": "PowerGrid Charging Solutions"
              }
            },
            "beckn:itemAttributes": {
              "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld)",
              "@type": "ChargingService",
              "connectorType": "Type2",
              "maxPowerKW": 22,
              "minPowerKW": 3,
              "reservationSupported": true,
              "chargingStation": {
                "id": "cs-03",
                "serviceLocation": {
                  "@type": "beckn:Location",
                  "geo": {
                    "type": "Point",
                    "coordinates": [
                      77.6254,
                      12.9716
                    ]
                  },
                  "address": {
                    "streetAddress": "PowerGrid Indiranagar, 100 Ft Rd",
                    "addressLocality": "Bengaluru",
                    "addressRegion": "Karnataka",
                    "postalCode": "560008",
                    "addressCountry": "IN"
                  }
                }
              },
              "amenityFeature": [
                "RESTROOM",
                "WI-FI",
                "PARKING"
              ],
              "evseId": "IN*PG*IND*01*TYPE2*A",
              "parkingType": "Office",
              "powerType": "AC_3_PHASE",
              "connectorFormat": "SOCKET",
              "chargingSpeed": "NORMAL",
              "vehicleType": "4-WHEELER"
            }
          }
        ],
        "beckn:offers": [
          {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
            "@type": "beckn:Offer",
            "beckn:id": "offer-ccs2-60kw-kwh",
            "beckn:descriptor": {
              "@type": "beckn:Descriptor",
              "schema:name": "Per-kWh Tariff - CCS2 60kW"
            },
            "beckn:items": [
              "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
            ],
            "beckn:price": {
              "currency": "INR",
              "value": 45.0,
              "applicableQuantity": {
                "unitText": "Kilowatt Hour",
                "unitCode": "KWH",
                "unitQuantity": 1
              }
            },
            "beckn:validity": {
              "@type": "beckn:TimePeriod",
              "schema:startDate": "2025-10-01T00:00:00Z",
              "schema:endDate": "2026-03-31T23:59:59Z"
            },
            "beckn:acceptedPaymentMethod": [
              "UPI",
              "CREDIT_CARD",
              "WALLET"
            ],
            "beckn:offerAttributes": {
              "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingOffer/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingOffer/v1/context.jsonld)",
              "@type": "ChargingOffer",
              "tariffModel": "PER_KWH",
              "idleFeePolicy": {
                "currency": "INR",
                "value": 2,
                "applicableQuantity": {
                  "unitCode": "MIN",
                  "unitText": "minutes",
                  "unitQuantity": 10
                }
              }
            },
            "beckn:provider": "ecopower-charging"
          },
          {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
            "@type": "beckn:Offer",
            "beckn:id": "offer-ccs2-120kw-kwh",
            "beckn:descriptor": {
              "@type": "beckn:Descriptor",
              "schema:name": "Per-kWh Tariff - CCS2 120kW"
            },
            "beckn:items": [
              "IND*greencharge-koramangala*cs-02*IN*GC*KOR*01*CCS2*A*CCS2-B"
            ],
            "beckn:price": {
              "currency": "INR",
              "value": 22.0,
              "applicableQuantity": {
                "unitText": "Kilowatt Hour",
                "unitCode": "KWH",
                "unitQuantity": 1
              }
            },
            "beckn:validity": {
              "@type": "beckn:TimePeriod",
              "schema:startDate": "2025-10-15T00:00:00Z",
              "schema:endDate": "2026-04-15T23:59:59Z"
            },
            "beckn:acceptedPaymentMethod": [
              "UPI",
              "CREDIT_CARD",
              "WALLET",
              "BANK_TRANSFER"
            ],
            "beckn:offerAttributes": {
              "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingOffer/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingOffer/v1/context.jsonld)",
              "@type": "ChargingOffer",
              "tariffModel": "PER_KWH",
              "idleFeePolicy": {
                "currency": "INR",
                "value": 3,
                "applicableQuantity": {
                  "unitCode": "MIN",
                  "unitText": "minutes",
                  "unitQuantity": 15
                }
              }
            },
            "beckn:provider": "greencharge-koramangala"
          },
          {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
            "@type": "beckn:Offer",
            "beckn:id": "offer-type2-22kw-kwh",
            "beckn:descriptor": {
              "@type": "beckn:Descriptor",
              "schema:name": "Per-kWh Tariff - Type 2 22kW"
            },
            "beckn:items": [
              "IND*powergrid-indiranagar*cs-03*IN*PG*IND*01*TYPE2*A*TYPE2-A"
            ],
            "beckn:price": {
              "currency": "INR",
              "value": 15.0,
              "applicableQuantity": {
                "unitText": "Kilowatt Hour",
                "unitCode": "KWH",
                "unitQuantity": 1
              }
            },
            "beckn:validity": {
              "@type": "beckn:TimePeriod",
              "schema:startDate": "2025-10-20T00:00:00Z",
              "schema:endDate": "2026-04-20T23:59:59Z"
            },
            "beckn:acceptedPaymentMethod": [
              "UPI",
              "CREDIT_CARD",
              "WALLET",
              "BANK_TRANSFER"
            ],
            "beckn:offerAttributes": {
              "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingOffer/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingOffer/v1/context.jsonld)",
              "@type": "ChargingOffer",
              "tariffModel": "PER_KWH",
              "idleFeePolicy": {
                "currency": "INR",
                "value": 1,
                "applicableQuantity": {
                  "unitCode": "MIN",
                  "unitText": "minutes",
                  "unitQuantity": 30
                }
              }
            },
            "beckn:provider": "powergrid-indiranagar"
          }
        ]
      }
    ]
  }
}
```
</details>

**11.2.2.3. action: select**
* **Method:** POST
* **Use Cases:** Aisha selects "EcoPower Highway Hub" and chooses a time slot (12:45–1:15 PM).
<details>
<summary><a href="../Example-schemas/03_select/ev-charging-on_select.json">Example json :rocket:</a></summary>

```json
{
    "context": {
        "version": "2.0.0",
        "action": "select",
        "domain": "beckn.one:deg:ev-charging:*",
        "timestamp": "2024-01-15T10:30:00Z",
        "message_id": "bb9f86db-9a3d-4e9c-8c11-81c8f1a7b901",
        "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
        "bap_id": "example-bap.com",
        "bap_uri": "[https://api.example-bap.com/pilot/bap/energy/v2](https://api.example-bap.com/pilot/bap/energy/v2)",
        "bpp_id": "example-bpp.com",
        "bpp_uri": "[https://example-bpp.com/pilot/bap/energy/v2](https://example-bpp.com/pilot/bap/energy/v2)",
        "ttl": "PT30S"
    },
    "message": {
        "order": {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
            "@type": "beckn:Order",
            "beckn:orderStatus": "CREATED",
            "beckn:seller": "ecopower-charging",
            "beckn:buyer": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
                "@type": "beckn:Buyer",
                "beckn:id": "user-123",
                "beckn:role": "BUYER",
                "beckn:displayName": "Ravi Kumar",
                "beckn:telephone": "+91-9876543210",
                "beckn:email": "ravi.kumar@example.com",
                "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
            },
            "beckn:orderItems": [
                {
                    "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
                    "beckn:quantity": {
                        "unitText": "Kilowatt Hour",
                        "unitCode": "KWH",
                        "unitQuantity": 2.5
                    },
                    "beckn:acceptedOffer": {
                        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                        "@type": "beckn:Offer",
                        "beckn:id": "offer-ccs2-60kw-kwh",
                        "beckn:descriptor": {
                            "@type": "beckn:Descriptor",
                            "schema:name": "Per-kWh Tariff - CCS2 60kW"
                        },
                        "beckn:items": [
                            "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
                        ],
                        "beckn:provider": "ecopower-charging",
                        "beckn:price": {
                            "currency": "INR",
                            "value": 45.0,
                            "applicableQuantity": {
                                "unitText": "Kilowatt Hour",
                                "unitCode": "KWH",
                                "unitQuantity": 1
                            }
                        }
                    }
                }
            ],
            "beckn:orderAttributes": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld)",
                "@type": "ChargingSession",
                "buyerFinderFee": {
                    "feeType": "PERCENTAGE",
                    "feeValue": 2.5
                },
                "preferences": {
                    "startTime": "2025-12-20T10:00:00Z",
                    "endTime": "2025-12-20T11:30:00Z"
                }
            }
        }
    }
}
```
</details>

**11.2.2.4. action: on_select**
* **Method:** POST
* **Use Cases:** The app returns the specific terms for that slot (Tariff, Grace Period, Cancellation Rules).
<details>
<summary><a href="../Example-schemas/04_on_select/ev-charging-select.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "on_select",
    "domain": "beckn.one:deg:ev-charging:*",
    "timestamp": "2024-01-15T10:30:05Z",
    "message_id": "bb9f86db-9a3d-4e9c-8c11-81c8f1a7b901",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
    "ttl": "PT30S",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:orderStatus": "CREATED",
      "beckn:seller": "ecopower-charging",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/draft/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123",
        "beckn:role": "BUYER",
        "beckn:displayName": "Ravi Kumar",
        "beckn:telephone": "+91-9876543210",
        "beckn:email": "ravi.kumar@example.com",
        "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
          "beckn:quantity": {
            "unitText": "Kilowatt Hour",
            "unitCode": "KWH",
            "unitQuantity": 2.5
          },
          "beckn:acceptedOffer": {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
            "@type": "beckn:Offer",
            "beckn:id": "offer-ccs2-60kw-kwh",
            "beckn:descriptor": {
              "@type": "beckn:Descriptor",
              "schema:name": "Per-kWh Tariff - CCS2 60kW"
            },
            "beckn:items": [
              "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
            ],
            "beckn:provider": "ecopower-charging",
            "beckn:price": {
              "currency": "INR",
              "value": 45.0,
              "applicableQuantity": {
                "unitText": "Kilowatt Hour",
                "unitCode": "KWH",
                "unitQuantity": 1
              }
            }
          },
          "beckn:price": {
            "currency": "INR",
            "value": 45.0,
            "applicableQuantity": {
              "unitText": "Kilowatt Hour",
              "unitCode": "KWH",
              "unitQuantity": 1
            }
          }
        }
      ],
      "beckn:orderValue": {
        "currency": "INR",
        "value": 143.95,
        "components": [
          {
            "type": "UNIT",
            "value": 112.5,
            "currency": "INR",
            "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
          },
          {
            "type": "SURCHARGE",
            "value": 20.0,
            "currency": "INR",
            "description": "Surge price (20%)"
          },
          {
            "type": "DISCOUNT",
            "value": -15.0,
            "currency": "INR",
            "description": "Offer discount (15%)"
          },
          {
            "type": "FEE",
            "value": 10.0,
            "currency": "INR",
            "description": "Service fee"
          },
          {
            "type": "FEE",
            "value": 13.64,
            "currency": "INR",
            "description": "Overcharge estimation"
          },
          {
            "type": "FEE",
            "value": 2.81,
            "currency": "INR",
            "description": "Buyer finder fee (2.5%)"
          }
        ]
      },
      "beckn:orderAttributes": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld)",
        "@type": "ChargingSession",
        "buyerFinderFee": {
          "feeType": "PERCENTAGE",
          "feeValue": 2.5
        },
        "preferences": {
          "startTime": "2025-12-20T10:00:00Z",
          "endTime": "2025-12-20T11:30:00Z"
        }
      }
    }
  }
}
```
</details>

**11.2.2.5. action: init**
* **Method:** POST
* **Use Cases:** Aisha provides her billing information (Credit Card details) for the ₹500 payment.
<details>
<summary><a href="../Example-schemas/05_init/ev-charging-init-bpp.json">Example json :rocket:</a></summary>

```json
{
    "context": {
        "version": "2.0.0",
        "action": "init",
        "domain": "beckn.one:deg:ev-charging:*",
        "bpp_id": "example-bpp.com",
        "bpp_uri": "[https://example-bpp.com/pilot/bap/energy/v2](https://example-bpp.com/pilot/bap/energy/v2)",
        "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
        "message_id": "6743e9e2-4fb5-487c-92b7-13ba8018f176",
        "timestamp": "2025-01-27T10:00:00Z",
        "ttl": "PT30S",
        "bap_id": "example-bap.com",
        "bap_uri": "[https://api.example-bap.com/pilot/bap/energy/v2](https://api.example-bap.com/pilot/bap/energy/v2)"
    },
    "message": {
        "order": {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
            "@type": "beckn:Order",
            "beckn:orderStatus": "CREATED",
            "beckn:seller": "cpo1.com",
            "beckn:buyer": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Buyer",
                "beckn:id": "user-123",
                "beckn:role": "BUYER",
                "beckn:displayName": "Ravi Kumar",
                "beckn:telephone": "+91-9876543210",
                "beckn:email": "ravi.kumar@example.com",
                "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
            },
            "beckn:orderItems": [
                {
                    "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
                    "beckn:quantity": {
                        "unitText": "Kilowatt Hour",
                        "unitCode": "KWH",
                        "unitQuantity": 2.5
                    },
                    "beckn:price": {
                        "currency": "INR",
                        "value": 45.0,
                        "applicableQuantity": {
                            "unitText": "Kilowatt Hour",
                            "unitCode": "KWH",
                            "unitQuantity": 1
                        }
                    }
                }
            ],
            "beckn:orderValue": {
                "currency": "INR",
                "value": 143.95,
                "components": [
                    {
                        "type": "UNIT",
                        "value": 112.5,
                        "currency": "INR",
                        "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
                    },
                    {
                        "type": "SURCHARGE",
                        "value": 20.0,
                        "currency": "INR",
                        "description": "Surge price (20%)"
                    },
                    {
                        "type": "DISCOUNT",
                        "value": -15.0,
                        "currency": "INR",
                        "description": "Offer discount (15%)"
                    },
                    {
                        "type": "FEE",
                        "value": 10.0,
                        "currency": "INR",
                        "description": "Service fee"
                    },
                    {
                        "type": "FEE",
                        "value": 13.64,
                        "currency": "INR",
                        "description": "Overcharge estimation"
                    },
                    {
                        "type": "FEE",
                        "value": 2.81,
                        "currency": "INR",
                        "description": "Buyer finder fee (2.5%)"
                    }
                ]
            },
            "beckn:payment": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Payment",
                "beckn:amount": {
                    "currency": "INR",
                    "value": 143.95
                },
                "beckn:beneficiary": "BPP",
                "beckn:paymentStatus": "INITIATED",
                "beckn:paymentAttributes": {
                    "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/PaymentSettlement/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/PaymentSettlement/v1/context.jsonld)",
                    "@type": "PaymentSettlement",
                    "settlementAccounts": [
                        {
                            "beneficiaryType": "BAP",
                            "accountHolderName": "Example BAP Solutions Pvt Ltd",
                            "accountNumber": "9876543210123",
                            "ifscCode": "HDFC0009876",
                            "bankName": "HDFC Bank",
                            "vpa": "example-bap@paytm"
                        }
                    ]
                }
            }
        }
    }
}

```
</details>

**11.2.2.6. action: on_init**
* **Method:** POST
* **Use Cases:** The app presents the final payment terms and awaits authorization.
<details>
<summary><a href="../Example-schemas/06_on_init/ev-charging-on_init-bpp.json">Example json :rocket:</a></summary>

```json
{
    "context": {
        "version": "2.0.0",
        "action": "on_init",
        "domain": "beckn.one:deg:ev-charging:*",
        "bap_id": "example-bap.com",
        "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
        "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
        "message_id": "6743e9e2-4fb5-487c-92b7-13ba8018f176",
        "timestamp": "2025-01-27T10:00:00Z",
        "ttl": "PT30S",
        "bpp_id": "example-bpp.com",
        "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
    },
    "message": {
        "order": {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
            "@type": "beckn:Order",
            "beckn:id": "order-ev-charging-001",
            "beckn:orderStatus": "CREATED",
            "beckn:seller": "cpo1.com",
            "beckn:buyer": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Buyer",
                "beckn:id": "user-123",
                "beckn:role": "BUYER",
                "beckn:displayName": "Ravi Kumar",
                "beckn:telephone": "+91-9876543210",
                "beckn:email": "ravi.kumar@example.com",
                "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
            },
            "beckn:orderItems": [
                {
                    "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
                    "beckn:quantity": {
                        "unitText": "Kilowatt Hour",
                        "unitCode": "KWH",
                        "unitQuantity": 2.5
                    },
                    "beckn:price": {
                        "currency": "INR",
                        "value": 45.0,
                        "applicableQuantity": {
                            "unitText": "Kilowatt Hour",
                            "unitCode": "KWH",
                            "unitQuantity": 1
                        }
                    }
                }
            ],
            "beckn:orderValue": {
                "currency": "INR",
                "value": 143.95,
                "components": [
                    {
                        "type": "UNIT",
                        "value": 112.5,
                        "currency": "INR",
                        "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
                    },
                    {
                        "type": "SURCHARGE",
                        "value": 20.0,
                        "currency": "INR",
                        "description": "Surge price (20%)"
                    },
                    {
                        "type": "DISCOUNT",
                        "value": -15.0,
                        "currency": "INR",
                        "description": "Offer discount (15%)"
                    },
                    {
                        "type": "FEE",
                        "value": 10.0,
                        "currency": "INR",
                        "description": "Service fee"
                    },
                    {
                        "type": "FEE",
                        "value": 13.64,
                        "currency": "INR",
                        "description": "Overcharge estimation"
                    },
                    {
                        "type": "FEE",
                        "value": 2.81,
                        "currency": "INR",
                        "description": "Buyer finder fee (2.5%)"
                    }
                ]
            },
            "beckn:payment": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Payment",
                "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
                "beckn:amount": {
                    "currency": "INR",
                    "value": 143.95
                },
                "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
                "beckn:txnRef": "TXN-123456789",
                "beckn:beneficiary": "BPP",
                "beckn:acceptedPaymentMethod": [
                    "BANK_TRANSFER",
                    "UPI",
                    "WALLET"
                ],
                "beckn:paymentStatus": "INITIATED",
                "beckn:paymentAttributes": {
                    "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/PaymentSettlement/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/PaymentSettlement/v1/context.jsonld)",
                    "@type": "PaymentSettlement",
                    "settlementAccounts": [
                        {
                            "beneficiaryType": "BAP",
                            "accountHolderName": "Example BAP Solutions Pvt Ltd",
                            "accountNumber": "9876543210123",
                            "ifscCode": "HDFC0009876",
                            "bankName": "HDFC Bank",
                            "vpa": "example-bap@paytm"
                        },
                        {
                            "beneficiaryType": "BPP",
                            "accountHolderName": "EcoPower Charging Solutions Pvt Ltd",
                            "accountNumber": "1234567890123",
                            "ifscCode": "HDFC0001234",
                            "bankName": "HDFC Bank",
                            "vpa": "ecopower@paytm"
                        }
                    ]
                }
            }
        }
    }
}
```
</details>

**11.2.2.6.1. action: on_status**
* **Method:** POST
* **Use Cases:** Application receives a notification on the completed status of the payment for the reservation.
<details>
<summary><a href="../Example-schemas/06_on_status_1/ev-charging-on_status-bpp.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "on_status",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "d4da89d5-2e42-4c36-9139-7f5682d5f104",
    "timestamp": "2025-01-27T10:05:00Z",
    "ttl": "PT30S",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "PENDING",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123",
        "beckn:role": "BUYER",
        "beckn:displayName": "Ravi Kumar",
        "beckn:telephone": "+91-9876543210",
        "beckn:email": "ravi.kumar@example.com",
        "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
          "beckn:quantity": {
            "unitText": "Kilowatt Hour",
            "unitCode": "KWH",
            "unitQuantity": 2.5
          },
          "beckn:price": {
            "currency": "INR",
            "value": 45.0,
            "applicableQuantity": {
              "unitText": "Kilowatt Hour",
              "unitCode": "KWH",
              "unitQuantity": 1
            }
          }
        }
      ],
      "beckn:orderValue": {
        "currency": "INR",
        "value": 143.95,
        "components": [
          {
            "type": "UNIT",
            "value": 112.5,
            "currency": "INR",
            "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
          },
          {
            "type": "SURCHARGE",
            "value": 20.0,
            "currency": "INR",
            "description": "Surge price (20%)"
          },
          {
            "type": "DISCOUNT",
            "value": -15.0,
            "currency": "INR",
            "description": "Offer discount (15%)"
          },
          {
            "type": "FEE",
            "value": 10.0,
            "currency": "INR",
            "description": "Service fee"
          },
          {
            "type": "FEE",
            "value": 13.64,
            "currency": "INR",
            "description": "Overcharge estimation"
          },
          {
            "type": "FEE",
            "value": 2.81,
            "currency": "INR",
            "description": "Buyer finder fee (2.5%)"
          }
        ]
      },
      "beckn:payment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Payment",
        "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
        "beckn:amount": {
          "currency": "INR",
          "value": 143.95
        },
        "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
        "beckn:txnRef": "TXN-123456789",
        "beckn:paidAt": "2025-12-19T10:05:00Z",
        "beckn:beneficiary": "BPP",
        "beckn:paymentStatus": "COMPLETED"
      }
    }
  }
}
```
</details>

**11.2.2.7. action: confirm**
* **Method:** POST
* **Use Cases:** Aisha confirms the reservation order.
<details>
<summary><a href="../Example-schemas/07_confirm/ev-charging-confirm.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "confirm",
    "domain": "beckn.one:deg:ev-charging:*",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bap/energy/v2](https://example-bpp.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "c69b4c1e-fb7e-469d-ae90-00f4d5e82b64",
    "timestamp": "2025-01-27T10:05:00Z",
    "ttl": "PT30S",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://api.example-bap.com/pilot/bap/energy/v2](https://api.example-bap.com/pilot/bap/energy/v2)"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "PENDING",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123",
        "beckn:role": "BUYER",
        "beckn:displayName": "Ravi Kumar",
        "beckn:telephone": "+91-9876543210",
        "beckn:email": "ravi.kumar@example.com",
        "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
          "beckn:quantity": {
            "unitText": "Kilowatt Hour",
            "unitCode": "KWH",
            "unitQuantity": 2.5
          },
          "beckn:price": {
            "currency": "INR",
            "value": 45.0,
            "applicableQuantity": {
              "unitText": "Kilowatt Hour",
              "unitCode": "KWH",
              "unitQuantity": 1
            }
          }
        }
      ],
      "beckn:orderValue": {
        "currency": "INR",
        "value": 143.95,
        "components": [
          {
            "type": "UNIT",
            "value": 112.5,
            "currency": "INR",
            "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
          },
          {
            "type": "SURCHARGE",
            "value": 20.0,
            "currency": "INR",
            "description": "Surge price (20%)"
          },
          {
            "type": "DISCOUNT",
            "value": -15.0,
            "currency": "INR",
            "description": "Offer discount (15%)"
          },
          {
            "type": "FEE",
            "value": 10.0,
            "currency": "INR",
            "description": "Service fee"
          },
          {
            "type": "FEE",
            "value": 13.64,
            "currency": "INR",
            "description": "Overcharge estimation"
          },
          {
            "type": "FEE",
            "value": 2.81,
            "currency": "INR",
            "description": "Buyer finder fee (2.5%)"
          }
        ]
      },
      "beckn:payment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Payment",
        "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
        "beckn:amount": {
          "currency": "INR",
          "value": 143.95
        },
        "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
        "beckn:txnRef": "TXN-123456789",
        "beckn:paidAt": "2025-12-19T10:05:00Z",
        "beckn:beneficiary": "BPP",
        "beckn:paymentStatus": "COMPLETED"
      }
    }
  }
}
```
</details>

**11.2.2.8. action: on_confirm**
* **Method:** POST
* **Use Cases:** The application returns a unique Reservation ID confirming the slot is booked.
<details>
<summary><a href="../Example-schemas/08_00_on_confirm/ev-charging-on_confirm.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "on_confirm",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "c69b4c1e-fb7e-469d-ae90-00f4d5e82b64",
    "timestamp": "2025-01-27T10:05:00Z",
    "ttl": "PT30S",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "CONFIRMED",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123",
        "beckn:role": "BUYER",
        "beckn:displayName": "Ravi Kumar",
        "beckn:telephone": "+91-9876543210",
        "beckn:email": "ravi.kumar@example.com",
        "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
          "beckn:quantity": {
            "unitText": "Kilowatt Hour",
            "unitCode": "KWH",
            "unitQuantity": 2.5
          },
          "beckn:price": {
            "currency": "INR",
            "value": 45.0,
            "applicableQuantity": {
              "unitText": "Kilowatt Hour",
              "unitCode": "KWH",
              "unitQuantity": 1
            }
          }
        }
      ],
      "beckn:orderValue": {
        "currency": "INR",
        "value": 143.95,
        "components": [
          {
            "type": "UNIT",
            "value": 112.5,
            "currency": "INR",
            "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
          },
          {
            "type": "SURCHARGE",
            "value": 20.0,
            "currency": "INR",
            "description": "Surge price (20%)"
          },
          {
            "type": "DISCOUNT",
            "value": -15.0,
            "currency": "INR",
            "description": "Offer discount (15%)"
          },
          {
            "type": "FEE",
            "value": 10.0,
            "currency": "INR",
            "description": "Service fee"
          },
          {
            "type": "FEE",
            "value": 13.64,
            "currency": "INR",
            "description": "Overcharge estimation"
          },
          {
            "type": "FEE",
            "value": 2.81,
            "currency": "INR",
            "description": "Buyer finder fee (2.5%)"
          }
        ]
      },
      "beckn:fulfillment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Fulfillment",
        "beckn:id": "fulfillment-001",
        "beckn:mode": "RESERVATION",
        "beckn:deliveryAttributes": {
          "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld)",
          "@type": "ChargingSession",
          "connectorType": "CCS2",
          "maxPowerKW": 50,
          "sessionStatus": "PENDING"
        }
      },
      "beckn:payment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Payment",
        "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
        "beckn:amount": {
          "currency": "INR",
          "value": 143.95
        },
        "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
        "beckn:txnRef": "TXN-123456789",
        "beckn:paidAt": "2025-12-19T10:05:00Z",
        "beckn:beneficiary": "BPP",
        "beckn:paymentStatus": "COMPLETED"
      }
    }
  }
}
```
</details>

**11.2.2.9. action: status**
* **Method:** POST
* **Use Cases:** Upon arrival, Aisha confirms she is at the right charger, the application checks the status of the reserved charger.
<details>
<summary><a href="../Example-schemas/08_01_status/ev-charging-connector-status.json">Example json :rocket:</a></summary>

```json
{
    "context": {
        "version": "2.0.0",
        "action": "status",
        "domain": "beckn.one:deg:ev-charging:*",
        "bap_id": "example-bap.com",
        "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
        "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
        "message_id": "c69b4c1e-fb7e-469d-ae90-00f4d5e82b64",
        "timestamp": "2025-01-27T10:05:00Z",
        "ttl": "PT30S",
        "bpp_id": "example-bpp.com",
        "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
    },
    "message": {
        "order": {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
            "@type": "beckn:Order",
            "beckn:id": "order-ev-charging-001",
            "beckn:orderStatus": "CONFIRMED",
            "beckn:seller": "cpo1.com",
            "beckn:buyer": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Buyer",
                "beckn:id": "user-123",
                "beckn:role": "BUYER",
                "beckn:displayName": "Ravi Kumar",
                "beckn:telephone": "+91-9876543210",
                "beckn:email": "ravi.kumar@example.com",
                "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
            },
            "beckn:orderItems": [
                {
                    "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
                    "beckn:quantity": {
                        "unitText": "Kilowatt Hour",
                        "unitCode": "KWH",
                        "unitQuantity": 2.5
                    },
                    "beckn:price": {
                        "currency": "INR",
                        "value": 45.0,
                        "applicableQuantity": {
                            "unitText": "Kilowatt Hour",
                            "unitCode": "KWH",
                            "unitQuantity": 1
                        }
                    }
                }
            ],
            "beckn:orderValue": {
                "currency": "INR",
                "value": 143.95,
                "components": [
                    {
                        "type": "UNIT",
                        "value": 112.5,
                        "currency": "INR",
                        "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
                    },
                    {
                        "type": "SURCHARGE",
                        "value": 20.0,
                        "currency": "INR",
                        "description": "Surge price (20%)"
                    },
                    {
                        "type": "DISCOUNT",
                        "value": -15.0,
                        "currency": "INR",
                        "description": "Offer discount (15%)"
                    },
                    {
                        "type": "FEE",
                        "value": 10.0,
                        "currency": "INR",
                        "description": "Service fee"
                    },
                    {
                        "type": "FEE",
                        "value": 13.64,
                        "currency": "INR",
                        "description": "Overcharge estimation"
                    },
                    {
                        "type": "FEE",
                        "value": 2.81,
                        "currency": "INR",
                        "description": "Buyer finder fee (2.5%)"
                    }
                ]
            },
            "beckn:fulfillment": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Fulfillment",
                "beckn:id": "fulfillment-001",
                "beckn:mode": "RESERVATION",
                "beckn:deliveryAttributes": {
                    "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld)",
                    "@type": "ChargingSession",
                    "connectorType": "CCS2",
                    "maxPowerKW": 50,
                    "sessionStatus": "PENDING"
                }
            },
            "beckn:payment": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Payment",
                "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
                "beckn:amount": {
                    "currency": "INR",
                    "value": 143.95
                },
                "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
                "beckn:txnRef": "TXN-123456789",
                "beckn:paidAt": "2025-12-19T10:05:00Z",
                "beckn:beneficiary": "BPP",
                "beckn:paymentStatus": "COMPLETED"
            }
        }
    }
}
```
</details>

**11.2.2.10. action: on_status**
* **Method:** POST
* **Use Cases:** The application confirms the charger is ready and prompts Aisha to "Start Charging" in the app.
<details>
<summary><a href="../Example-schemas/08_02_on_status/ev-charging-connector-on_status.json">Example json :rocket:</a></summary>

```json
{
    "context": {
        "version": "2.0.0",
        "action": "on_status",
        "domain": "beckn.one:deg:ev-charging:*",
        "bap_id": "example-bap.com",
        "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
        "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
        "message_id": "c69b4c1e-fb7e-469d-ae90-00f4d5e82b64",
        "timestamp": "2025-01-27T10:05:00Z",
        "ttl": "PT30S",
        "bpp_id": "example-bpp.com",
        "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
    },
    "message": {
        "order": {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
            "@type": "beckn:Order",
            "beckn:id": "order-ev-charging-001",
            "beckn:orderStatus": "CONFIRMED",
            "beckn:seller": "cpo1.com",
            "beckn:buyer": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Buyer",
                "beckn:id": "user-123",
                "beckn:role": "BUYER",
                "beckn:displayName": "Ravi Kumar",
                "beckn:telephone": "+91-9876543210",
                "beckn:email": "ravi.kumar@example.com",
                "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
            },
            "beckn:orderItems": [
                {
                    "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
                }
            ],
            "beckn:orderValue": {
                "currency": "INR",
                "value": 143.95,
                "components": [
                    {
                        "type": "UNIT",
                        "value": 112.5,
                        "currency": "INR",
                        "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
                    },
                    {
                        "type": "SURCHARGE",
                        "value": 20.0,
                        "currency": "INR",
                        "description": "Surge price (20%)"
                    },
                    {
                        "type": "DISCOUNT",
                        "value": -15.0,
                        "currency": "INR",
                        "description": "Offer discount (15%)"
                    },
                    {
                        "type": "FEE",
                        "value": 10.0,
                        "currency": "INR",
                        "description": "Service fee"
                    },
                    {
                        "type": "FEE",
                        "value": 13.64,
                        "currency": "INR",
                        "description": "Overcharge estimation"
                    },
                    {
                        "type": "FEE",
                        "value": 2.81,
                        "currency": "INR",
                        "description": "Buyer finder fee (2.5%)"
                    }
                ]
            },
            "beckn:fulfillment": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Fulfillment",
                "beckn:id": "fulfillment-001",
                "beckn:mode": "RESERVATION",
                "beckn:deliveryAttributes": {
                    "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld)",
                    "@type": "ChargingSession",
                    "connectorType": "CCS2",
                    "maxPowerKW": 50,
                    "sessionStatus": "PENDING",
                    "connectorStatus": "PREPARING"
                }
            },
            "beckn:payment": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Payment",
                "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
                "beckn:amount": {
                    "currency": "INR",
                    "value": 143.95
                },
                "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
                "beckn:txnRef": "TXN-123456789",
                "beckn:paidAt": "2025-12-19T10:05:00Z",
                "beckn:beneficiary": "BPP",
                "beckn:paymentStatus": "COMPLETED"
            }
        }
    }
}
```
</details>

**11.2.2.11. action: update (start charging)**
* **Method:** POST
* **Use Cases:** Aisha taps "Start Charging" and the app instructs the backend to energize the gun.
<details>
<summary><a href="../Example-schemas/09_update/ev-charging-start-update.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "update",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://api.example-bap.com/pilot/bap/energy/v2](https://api.example-bap.com/pilot/bap/energy/v2)",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bap/energy/v2](https://example-bpp.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "6bd7be5b-ac21-4a5c-a787-5ec6980317e6",
    "timestamp": "2025-01-27T10:15:00Z",
    "ttl": "PT30S"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "CONFIRMED",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123",
        "beckn:role": "BUYER",
        "beckn:displayName": "Ravi Kumar",
        "beckn:telephone": "+91-9876543210",
        "beckn:email": "ravi.kumar@example.com",
        "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
        }
      ],
      "beckn:orderValue": {
        "currency": "INR",
        "value": 143.95,
        "components": [
          {
            "type": "UNIT",
            "value": 112.5,
            "currency": "INR",
            "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
          },
          {
            "type": "SURCHARGE",
            "value": 20.0,
            "currency": "INR",
            "description": "Surge price (20%)"
          },
          {
            "type": "DISCOUNT",
            "value": -15.0,
            "currency": "INR",
            "description": "Offer discount (15%)"
          },
          {
            "type": "FEE",
            "value": 10.0,
            "currency": "INR",
            "description": "Service fee"
          },
          {
            "type": "FEE",
            "value": 13.64,
            "currency": "INR",
            "description": "Overcharge estimation"
          },
          {
            "type": "FEE",
            "value": 2.81,
            "currency": "INR",
            "description": "Buyer finder fee (2.5%)"
          }
        ]
      },
      "beckn:fulfillment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Fulfillment",
        "beckn:id": "fulfillment-001",
        "beckn:mode": "RESERVATION",
        "beckn:deliveryAttributes": {
          "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld)",
          "@type": "ChargingSession",
          "connectorType": "CCS2",
          "maxPowerKW": 50,
          "sessionStatus": "PENDING"
        }
      },
      "beckn:payment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Payment",
        "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
        "beckn:amount": {
          "currency": "INR",
          "value": 143.95
        },
        "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
        "beckn:txnRef": "TXN-123456789",
        "beckn:paidAt": "2025-12-19T10:05:00Z",
        "beckn:beneficiary": "BPP",
        "beckn:paymentStatus": "COMPLETED"
      }
    }
  }
}
```
</details>

**11.2.2.12. action: on_update (start charging)**
* **Method:** POST
* **Use Cases:** Response confirming the session has started successfully.
<details>
<summary><a href="../Example-schemas/10_on_update/ev-charging-start-on_update.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "on_update",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "6bd7be5b-ac21-4a5c-a787-5ec6980317e6",
    "timestamp": "2025-01-27T10:15:30Z",
    "ttl": "PT30S",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "INPROGRESS",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123",
        "beckn:role": "BUYER",
        "beckn:displayName": "Ravi Kumar",
        "beckn:telephone": "+91-9876543210",
        "beckn:email": "ravi.kumar@example.com",
        "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
        }
      ],
      "beckn:orderValue": {
        "currency": "INR",
        "value": 143.95,
        "components": [
          {
            "type": "UNIT",
            "value": 112.5,
            "currency": "INR",
            "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
          },
          {
            "type": "SURCHARGE",
            "value": 20.0,
            "currency": "INR",
            "description": "Surge price (20%)"
          },
          {
            "type": "DISCOUNT",
            "value": -15.0,
            "currency": "INR",
            "description": "Offer discount (15%)"
          },
          {
            "type": "FEE",
            "value": 10.0,
            "currency": "INR",
            "description": "Service fee"
          },
          {
            "type": "FEE",
            "value": 13.64,
            "currency": "INR",
            "description": "Overcharge estimation"
          },
          {
            "type": "FEE",
            "value": 2.81,
            "currency": "INR",
            "description": "Buyer finder fee (2.5%)"
          }
        ]
      },
      "beckn:fulfillment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Fulfillment",
        "beckn:id": "fulfillment-001",
        "beckn:mode": "RESERVATION",
        "beckn:deliveryAttributes": {
          "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld)",
          "@type": "ChargingSession",
          "sessionStatus": "ACTIVE",
          "connectorType": "CCS2",
          "maxPowerKW": 50
        }
      },
      "beckn:payment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Payment",
        "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
        "beckn:amount": {
          "currency": "INR",
          "value": 143.95
        },
        "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
        "beckn:txnRef": "TXN-123456789",
        "beckn:paidAt": "2025-12-19T10:05:00Z",
        "beckn:beneficiary": "BPP",
        "beckn:paymentStatus": "COMPLETED"
      }
    }
  }
}
```
</details>

**11.2.2.13. action: track (charging-session progress)**
* **Method:** POST
* **Use Cases:** Aisha requests live telemetry (Energy dispensed, running cost) while at lunch.
<details>
<summary><a href="../Example-schemas/11_track/ev-charging-track.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "track",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://api.example-bap.com/pilot/bap/energy/v2](https://api.example-bap.com/pilot/bap/energy/v2)",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "6ace310b-6440-4421-a2ed-b484c7548bd5",
    "timestamp": "2025-01-27T17:00:40.065Z",
    "ttl": "PT30S"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "INPROGRESS",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
        }
      ]
    }
  }
}
```
</details>

**11.2.2.14. action: on_track**
* **Method:** POST
* **Use Cases:** The app receives real-time updates on the charging progress.
<details>
<summary><a href="../Example-schemas/12_on_track/ev-charging-on_track.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "on_track",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "6ace310b-6440-4421-a2ed-b484c7548bd5",
    "timestamp": "2025-01-27T17:00:40.065Z",
    "ttl": "PT30S",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "INPROGRESS",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
        }
      ],
      "beckn:fulfillment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Fulfillment",
        "beckn:id": "fulfillment-001",
        "beckn:mode": "RESERVATION",
        "trackingAction": {
          "@type": "beckn:TrackAction",
          "target": {
            "@type": "schema:EntryPoint",
            "url": "[https://track.bluechargenet-aggregator.io/session/SESSION-9876543210](https://track.bluechargenet-aggregator.io/session/SESSION-9876543210)"
          }
        },
        "sessionStatus": "ACTIVE",
        "beckn:deliveryAttributes": {
          "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingService/v1/context.jsonld)",
          "@type": "ChargingSession",
          "chargingTelemetry": [
            {
              "eventTime": "2025-01-27T17:00:00Z",
              "metrics": [
                {
                  "name": "STATE_OF_CHARGE",
                  "value": 62.5,
                  "unitCode": "PERCENTAGE"
                },
                {
                  "name": "POWER",
                  "value": 18.4,
                  "unitCode": "KWH"
                },
                {
                  "name": "ENERGY",
                  "value": 10.2,
                  "unitCode": "KW"
                },
                {
                  "name": "VOLTAGE",
                  "value": 392,
                  "unitCode": "VLT"
                },
                {
                  "name": "CURRENT",
                  "value": 47.0,
                  "unitCode": "AMP"
                }
              ]
            },
            {
              "eventTime": "2025-01-27T17:05:00Z",
              "metrics": [
                {
                  "name": "STATE_OF_CHARGE",
                  "value": 65.0,
                  "unitCode": "PERCENTAGE"
                },
                {
                  "name": "POWER",
                  "value": 17.1,
                  "unitCode": "KWH"
                },
                {
                  "name": "ENERGY",
                  "value": 11.1,
                  "unitCode": "KW"
                },
                {
                  "name": "VOLTAGE",
                  "value": 388,
                  "unitCode": "VLT"
                },
                {
                  "name": "CURRENT",
                  "value": 44.2,
                  "unitCode": "AMP"
                }
              ]
            }
          ]
        }
      }
    }
  }
}
```
</details>

**11.2.2.15. async action: on_update (stop-charging)**
* **Method:** POST
* **Use Case:** The session terminates. Aisha receives the digital invoice and updated wallet balance.
<details>
<summary><a href="../Example-schemas/14_02_on_update/ev-charging-completed-on_update.json">Example json :rocket:</a></summary>

```json
{
    "context": {
        "version": "2.0.0",
        "action": "on_update",
        "domain": "beckn.one:deg:ev-charging:*",
        "bap_id": "example-bap.com",
        "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
        "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
        "message_id": "32f67afe-3d8c-4faa-bc2e-93b0791dcb02",
        "timestamp": "2025-01-27T11:45:00Z",
        "ttl": "PT30S",
        "bpp_id": "example-bpp.com",
        "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
    },
    "message": {
        "order": {
            "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
            "@type": "beckn:Order",
            "beckn:id": "order-ev-charging-001",
            "beckn:orderStatus": "COMPLETED",
            "beckn:seller": "cpo1.com",
            "beckn:buyer": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Buyer",
                "beckn:id": "user-123",
                "beckn:role": "BUYER",
                "beckn:displayName": "Ravi Kumar",
                "beckn:telephone": "+91-9876543210",
                "beckn:email": "ravi.kumar@example.com",
                "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
            },
            "beckn:orderItems": [
                {
                    "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
                }
            ],
            "beckn:orderValue": {
                "currency": "INR",
                "value": 143.95,
                "components": [
                    {
                        "type": "UNIT",
                        "value": 112.5,
                        "currency": "INR",
                        "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
                    },
                    {
                        "type": "SURCHARGE",
                        "value": 20.0,
                        "currency": "INR",
                        "description": "Surge price (20%)"
                    },
                    {
                        "type": "DISCOUNT",
                        "value": -15.0,
                        "currency": "INR",
                        "description": "Offer discount (15%)"
                    },
                    {
                        "type": "FEE",
                        "value": 10.0,
                        "currency": "INR",
                        "description": "Service fee"
                    },
                    {
                        "type": "FEE",
                        "value": 13.64,
                        "currency": "INR",
                        "description": "Overcharge estimation"
                    },
                    {
                        "type": "FEE",
                        "value": 2.81,
                        "currency": "INR",
                        "description": "Buyer finder fee (2.5%)"
                    }
                ]
            },
            "beckn:fulfillment": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Fulfillment",
                "beckn:id": "fulfillment-001",
                "beckn:mode": "RESERVATION",
                "beckn:deliveryAttributes": {
                    "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld)",
                    "@type": "ChargingSession",
                    "sessionStatus": "COMPLETED"
                }
            },
            "beckn:payment": {
                "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
                "@type": "beckn:Payment",
                "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
                "beckn:amount": {
                    "currency": "INR",
                    "value": 143.95
                },
                "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
                "beckn:txnRef": "TXN-123456789",
                "beckn:paidAt": "2025-12-19T10:05:00Z",
                "beckn:beneficiary": "BPP",
                "beckn:paymentStatus": "COMPLETED"
            }
        }
    }
}
```
</details>

**11.2.2.16. action: rating**
* **Method:** POST
* **Use Cases:** Aisha provides a rating for the amenities and experience.
<details>
<summary><a href="../Example-schemas/15_rating/ev-charging-rating.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "rating",
    "domain": "beckn.one:deg:ev-charging:*",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bap/energy/v2](https://example-bpp.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "89ee20fe-b592-48b0-a5c5-e38f6b90e569",
    "timestamp": "2025-01-27T12:00:00Z",
    "ttl": "PT30S",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://api.example-bap.com/pilot/bap/energy/v2](https://api.example-bap.com/pilot/bap/energy/v2)"
  },
  "message": {
    "ratings": [
      {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:RatingInput",
        "beckn:id": "fulfillment-001",
        "beckn:ratingValue": 4,
        "beckn:bestRating": 5,
        "beckn:worstRating": 1,
        "beckn:category": "FULFILLMENT",
        "beckn:feedback": {
          "comments": "Excellent charging experience! The station was clean, easy to find, and the charging was fast and reliable. The staff was helpful and the payment process was smooth.",
          "tags": [
            "fast-charging",
            "easy-to-use",
            "clean-station",
            "helpful-staff",
            "smooth-payment"
          ]
        }
      }
    ]
  }
}
```
</details>

**11.2.2.17. action: on_rating**
* **Method:** POST
* **Use Cases:** Aisha receives an acknowledgement for her feedback.
<details>
<summary><a href="../Example-schemas/16_on_rating/ev-charging-on_rating.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "on_rating",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "89ee20fe-b592-48b0-a5c5-e38f6b90e569",
    "timestamp": "2025-01-27T12:00:30Z",
    "ttl": "PT30S",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
  },
  "message": {
    "received": true,
    "feedbackForm": {
      "url": "[https://example-bpp.com/feedback/portal](https://example-bpp.com/feedback/portal)",
      "mime_type": "application/xml",
      "submission_id": "feedback-123e4567-e89b-12d3-a456-426614174000"
    }
  }
}
```
</details>

**11.2.2.18. action: support**
* **Method:** POST
* **Use Cases:** Aisha reaches out for support if needed.
<details>
<summary><a href="../Example-schemas/17_support/ev-charging-support.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "support",
    "domain": "beckn.one:deg:ev-charging:*",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bap/energy/v2](https://example-bpp.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "dee432d9-36c9-4146-ad21-2f5bcac9b6a9",
    "timestamp": "2025-01-27T12:15:00Z",
    "ttl": "PT30S",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://api.example-bap.com/pilot/bap/energy/v2](https://api.example-bap.com/pilot/bap/energy/v2)"
  },
  "message": {
    "refId": "order-ev-charging-001",
    "refType": "ORDER",
    "support": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:SupportInfo",
      "name": "Ravi Kumar",
      "phone": "+91-9876543210",
      "email": "ravi.kumar@example.com",
      "hours": "Mon\u2013Sun: 6:00 PM - 10:00 PM IST",
      "channels": [
        "PHONE",
        "WHATSAPP"
      ]
    }
  }
}
```
</details>

**11.2.2.19. action: on_support**
* **Method:** POST
* **Use Cases:** Aisha receives a response to her support request.
<details>
<summary><a href="../Example-schemas/18_on_support/ev-charging-on_support.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "on_support",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "dee432d9-36c9-4146-ad21-2f5bcac9b6a9",
    "timestamp": "2025-01-27T12:15:30Z",
    "ttl": "PT30S",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
  },
  "message": {
    "support": {
      "name": "BlueCharge Support Team",
      "phone": "18001080",
      "email": "support@bluechargenet-aggregator.io",
      "url": "[https://support.bluechargenet-aggregator.io/ticket/SUP-20250730-001](https://support.bluechargenet-aggregator.io/ticket/SUP-20250730-001)",
      "hours": "Mon\u2013Sun 24/7 IST",
      "channels": [
        "PHONE",
        "EMAIL",
        "WEB",
        "CHAT"
      ]
    }
  }
}
```
</details>

## 12. Special Corner Cases:

This section details various corner cases and special scenarios that may arise during the fulfillment lifecycle.

### 12.0 BAP Led Payment:

The network architecture empowers all Network Participants (NPs) to function as the beneficiary and facilitate payment collection for an underlying order. While previous sections demonstrated scenarios where the BPP acts as the beneficiary, the network also supports BAP-led payment collection. The example schema below illustrates how an application structures the `init` request to express intent to serve as the payment collector.

> **Note:** The `beneficiary` field serves as a negotiation parameter within the `init` and `on_init` API calls. Designating the beneficiary as 'BAP' within the `init` request constitutes a proposal to the BPP regarding the payment terms. If the provider designates the beneficiary as 'BAP' within the subsequent `on_init` response, the application is authorized to collect the payment. However, if the beneficiary is designated as 'BPP' within the `on_init` response, the BPP retains the responsibility for payment collection.

**12.0.1. action: init**
* **Method:** POST
<details>
<summary><a href="../Example-schemas/05_init/ev-charging-init-bap.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "init",
    "domain": "beckn.one:deg:ev-charging:*",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bap/energy/v2](https://example-bpp.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "6743e9e2-4fb5-487c-92b7-13ba8018f176",
    "timestamp": "2025-01-27T10:00:00Z",
    "ttl": "PT30S",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://api.example-bap.com/pilot/bap/energy/v2](https://api.example-bap.com/pilot/bap/energy/v2)"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "CREATED",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123",
        "beckn:role": "BUYER",
        "beckn:displayName": "Ravi Kumar",
        "beckn:telephone": "+91-9876543210",
        "beckn:email": "ravi.kumar@example.com",
        "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
          "beckn:quantity": {
            "unitText": "Kilowatt Hour",
            "unitCode": "KWH",
            "unitQuantity": 2.5
          },
          "beckn:price": {
            "currency": "INR",
            "value": 45.0,
            "applicableQuantity": {
              "unitText": "Kilowatt Hour",
              "unitCode": "KWH",
              "unitQuantity": 1
            }
          }
        }
      ],
      "beckn:orderValue": {
        "currency": "INR",
        "value": 143.95,
        "components": [
          {
            "type": "UNIT",
            "value": 112.5,
            "currency": "INR",
            "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
          },
          {
            "type": "SURCHARGE",
            "value": 20.0,
            "currency": "INR",
            "description": "Surge price (20%)"
          },
          {
            "type": "DISCOUNT",
            "value": -15.0,
            "currency": "INR",
            "description": "Offer discount (15%)"
          },
          {
            "type": "FEE",
            "value": 10.0,
            "currency": "INR",
            "description": "Service fee"
          },
          {
            "type": "FEE",
            "value": 13.64,
            "currency": "INR",
            "description": "Overcharge estimation"
          },
          {
            "type": "FEE",
            "value": 2.81,
            "currency": "INR",
            "description": "Buyer finder fee (2.5%)"
          }
        ]
      },
      "beckn:payment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Payment",
        "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
        "beckn:amount": {
          "currency": "INR",
          "value": 143.95
        },
        "beckn:beneficiary": "BAP",
        "beckn:paymentStatus": "INITIATED",
        "beckn:paymentAttributes": {
          "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/PaymentSettlement/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/PaymentSettlement/v1/context.jsonld)",
          "@type": "PaymentSettlement",
          "settlementAccounts": [
            {
              "beneficiaryType": "BAP",
              "accountHolderName": "Example BAP Solutions Pvt Ltd",
              "accountNumber": "9876543210123",
              "ifscCode": "HDFC0009876",
              "bankName": "HDFC Bank",
              "vpa": "example-bap@paytm"
            }
          ]
        }
      }
    }
  }
}
```
</details>

**12.0.1. action: on_init**
* **Method:** POST
<details>
<summary><a href="../Example-schemas/06_on_init/ev-charging-on-init-bap.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "on_init",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "6743e9e2-4fb5-487c-92b7-13ba8018f176",
    "timestamp": "2025-01-27T10:00:00Z",
    "ttl": "PT30S",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "CREATED",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123",
        "beckn:role": "BUYER",
        "beckn:displayName": "Ravi Kumar",
        "beckn:telephone": "+91-9876543210",
        "beckn:email": "ravi.kumar@example.com",
        "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
          "beckn:quantity": {
            "unitText": "Kilowatt Hour",
            "unitCode": "KWH",
            "unitQuantity": 2.5
          },
          "beckn:price": {
            "currency": "INR",
            "value": 45.0,
            "applicableQuantity": {
              "unitText": "Kilowatt Hour",
              "unitCode": "KWH",
              "unitQuantity": 1
            }
          }
        }
      ],
      "beckn:orderValue": {
        "currency": "INR",
        "value": 143.95,
        "components": [
          {
            "type": "UNIT",
            "value": 112.5,
            "currency": "INR",
            "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
          },
          {
            "type": "SURCHARGE",
            "value": 20.0,
            "currency": "INR",
            "description": "Surge price (20%)"
          },
          {
            "type": "DISCOUNT",
            "value": -15.0,
            "currency": "INR",
            "description": "Offer discount (15%)"
          },
          {
            "type": "FEE",
            "value": 10.0,
            "currency": "INR",
            "description": "Service fee"
          },
          {
            "type": "FEE",
            "value": 13.64,
            "currency": "INR",
            "description": "Overcharge estimation"
          },
          {
            "type": "FEE",
            "value": 2.81,
            "currency": "INR",
            "description": "Buyer finder fee (2.5%)"
          }
        ]
      },
      "beckn:payment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Payment",
        "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
        "beckn:amount": {
          "currency": "INR",
          "value": 143.95
        },
        "beckn:beneficiary": "BAP",
        "beckn:paymentStatus": "INITIATED",
        "beckn:paymentAttributes": {
          "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/PaymentSettlement/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/PaymentSettlement/v1/context.jsonld)",
          "@type": "PaymentSettlement",
          "settlementAccounts": [
            {
              "beneficiaryType": "BAP",
              "accountHolderName": "Example BAP Solutions Pvt Ltd",
              "accountNumber": "9876543210123",
              "ifscCode": "HDFC0009876",
              "bankName": "HDFC Bank",
              "vpa": "example-bap@paytm"
            },
            {
              "beneficiaryType": "BPP",
              "accountHolderName": "EcoPower Charging Solutions Pvt Ltd",
              "accountNumber": "1234567890123",
              "ifscCode": "HDFC0001234",
              "bankName": "HDFC Bank",
              "vpa": "ecopower@paytm"
            }
          ]
        }
      }
    }
  }
}
```
</details>

### 12.1 Cancellation of an Order:

Cancellation scenarios represent critical edge cases within the fulfillment lifecycle that require robust handling to ensure state consistency across the network. A cancellation event may originate from either the User, who opts to discontinue the service, or the Charging Point Operator (CPO), who may be unable to facilitate or fulfill the order due to operational constraints or unforeseen circumstances.



#### 12.1.1. User-Initiated Cancellation

In instances where the User initiates the cancellation of an existing reservation or confirmed order, the BAP initiates the workflow by transmitting the `cancel` API request. This signals to the BPP that the User no longer requires the service, allowing the CPO to release the reserved inventory.

**12.1.1.1. action: cancel**
* **Method:** POST

<details>
<summary><a href="../Example-schemas/19_cancel/cancel-a-reserved-slot.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "domain": "beckn.one:deg:ev-charging:*",
    "action": "cancel",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://api.example-bap.com/pilot/bap/energy/v2](https://api.example-bap.com/pilot/bap/energy/v2)",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "4a736341-8897-4e5a-9873-53533691f42d",
    "timestamp": "2025-01-27T12:15:30Z",
    "ttl": "PT30S"
  },
  "message": {
    "order": [
      {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Order",
        "beckn:id": "order-ev-charging-001",
        "beckn:orderStatus": "CONFIRMED",
        "beckn:seller": "cpo1.com",
        "beckn:buyer": {
          "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
          "@type": "beckn:Buyer",
          "beckn:id": "user-123"
        },
        "beckn:orderItems": [
          {
            "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A",
            "beckn:quantity": {
              "unitText": "Kilowatt Hour",
              "unitCode": "KWH",
              "unitQuantity": 2.5
            }
          }
        ]
      }
    ]
  }
}
```
</details>

#### Provider-Initiated Cancellation

Conversely, in scenarios where the Provider is unable to fulfill the obligation, the BPP communicates the cancellation by transmitting an unsolicited `on_cancel` callback. This notifies the BAP that the order status has been updated to `CANCELLED`, often accompanied by the processing of a refund where applicable.

**12.1.1.1. action: on_cancel**
* **Method:** POST

<details>
<summary><a href="../Example-schemas/20_on_cancel/cpo-cancels-reservation.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "domain": "beckn.one:deg:ev-charging:*",
    "action": "on_cancel",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "4a736341-8897-4e5a-9873-53533691f42d",
    "timestamp": "2025-01-27T10:05:00Z",
    "ttl": "PT30S",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "CANCELLED",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123",
        "beckn:role": "BUYER",
        "beckn:displayName": "Ravi Kumar",
        "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "pe-charging-01",
          "beckn:quantity": {
            "unitText": "Kilowatt Hour",
            "unitCode": "KWH",
            "unitQuantity": 2.5
          },
          "beckn:price": {
            "currency": "INR",
            "value": 45.0,
            "applicableQuantity": {
              "unitText": "Kilowatt Hour",
              "unitCode": "KWH",
              "unitQuantity": 1
            }
          }
        }
      ],
      "beckn:orderValue": {
        "currency": "INR",
        "value": 143.95,
        "components": [
          {
            "type": "UNIT",
            "value": 112.5,
            "currency": "INR",
            "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
          },
          {
            "type": "SURCHARGE",
            "value": 20.0,
            "currency": "INR",
            "description": "Surge price (20%)"
          },
          {
            "type": "DISCOUNT",
            "value": -15.0,
            "currency": "INR",
            "description": "Offer discount (15%)"
          },
          {
            "type": "FEE",
            "value": 10.0,
            "currency": "INR",
            "description": "Service fee"
          },
          {
            "type": "FEE",
            "value": 13.64,
            "currency": "INR",
            "description": "Overcharge estimation"
          },
          {
            "type": "FEE",
            "value": 2.81,
            "currency": "INR",
            "description": "Buyer finder fee (2.5%)"
          }
        ]
      },
      "beckn:payment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Payment",
        "beckn:id": "payment-987e6543-e21b-34c5-b567-537725285111",
        "beckn:amount": {
          "currency": "INR",
          "value": 143.95
        },
        "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
        "beckn:txnRef": "TXN-987654321",
        "beckn:paidAt": "2025-12-19T17:35:00Z",
        "beckn:beneficiary": "BUYER",
        "beckn:paymentStatus": "REFUNDED"
      }
    }
  }
}
```
</details>

> **Note:** The cancellation of an order is only possible until the fulfilment status is in "PENDING" state. Once the fulfilment status turns to "ACTIVE" cancellation wouldnt be plausible.

### 12.2 Interruption in Charging Process:

Operational anomalies or technical faults at the charging station may occasionally result in the premature termination or interruption of an active charging session. To maintain state synchronization, such events trigger an immediate, unsolicited `on_status` callback from the Provider (BPP). This communication ensures the BAP is promptly notified of the service interruption, allowing for appropriate user notification and subsequent remediation steps.

**12.2.1. action: on_status**
* **Method:** POST

<details>
<summary><a href="../Example-schemas/13_on_status/ev-charging-session-interupt-on_status.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "on_status",
    "domain": "beckn.one:deg:ev-charging:*",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://example-bap.com/pilot/bap/energy/v2](https://example-bap.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "6743e9e2-4fb5-487c-92b7-13ba8018f176",
    "timestamp": "2025-01-27T13:07:02Z",
    "ttl": "PT30S",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bpp/energy/v2](https://example-bpp.com/pilot/bpp/energy/v2)"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "INPROGRESS",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
        }
      ],
      "beckn:orderValue": {
        "currency": "INR",
        "value": 143.95,
        "components": [
          {
            "type": "UNIT",
            "value": 112.5,
            "currency": "INR",
            "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
          },
          {
            "type": "SURCHARGE",
            "value": 20.0,
            "currency": "INR",
            "description": "Surge price (20%)"
          },
          {
            "type": "DISCOUNT",
            "value": -15.0,
            "currency": "INR",
            "description": "Offer discount (15%)"
          },
          {
            "type": "FEE",
            "value": 10.0,
            "currency": "INR",
            "description": "Service fee"
          },
          {
            "type": "FEE",
            "value": 13.64,
            "currency": "INR",
            "description": "Overcharge estimation"
          },
          {
            "type": "FEE",
            "value": 2.81,
            "currency": "INR",
            "description": "Buyer finder fee (2.5%)"
          }
        ]
      },
      "beckn:fulfillment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Fulfillment",
        "beckn:id": "fulfillment-001",
        "beckn:mode": "RESERVATION",
        "beckn:deliveryAttributes": {
          "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld)",
          "@type": "ChargingSession",
          "sessionStatus": "INTERRUPTED"
        }
      },
      "beckn:payment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Payment",
        "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
        "beckn:amount": {
          "currency": "INR",
          "value": 143.95
        },
        "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
        "beckn:txnRef": "TXN-123456789",
        "beckn:paidAt": "2025-12-19T10:05:00Z",
        "beckn:beneficiary": "BPP",
        "beckn:paymentStatus": "COMPLETED"
      }
    }
  }
}
```
</details>

### 12.3 User-Initiated Session Termination:

During an active charging session, the user may elect to voluntarily terminate the service prior to the completion of the charge or the scheduled time. To facilitate this request, the application (BAP) triggers an `update` API call. Within this request, the `fulfillment` object must explicitly specify the `sessionStatus` as "STOP" within the delivery attributes. This signal instructs the Provider to cease the energy flow immediately. Subsequently, the Provider (BPP) will transmit an `on_update` callback containing the finalized Call Detail Record (CDR) reflecting the actual energy consumed up to the point of termination.

**12.3.1. action: update**
* **Method:** POST
<details>
<summary><a href="../Example-schemas/14_01_update/ev-charging-stop-update.json">Example json :rocket:</a></summary>

```json
{
  "context": {
    "version": "2.0.0",
    "action": "update",
    "domain": "beckn.one:deg:ev-charging:*",
    "bpp_id": "example-bpp.com",
    "bpp_uri": "[https://example-bpp.com/pilot/bap/energy/v2](https://example-bpp.com/pilot/bap/energy/v2)",
    "transaction_id": "2b4d69aa-22e4-4c78-9f56-5a7b9e2b2002",
    "message_id": "6bd7be5b-ac21-4a5c-a787-5ec6980317e6",
    "timestamp": "2025-01-27T10:15:00Z",
    "ttl": "PT30S",
    "bap_id": "example-bap.com",
    "bap_uri": "[https://api.example-bap.com/pilot/bap/energy/v2](https://api.example-bap.com/pilot/bap/energy/v2)"
  },
  "message": {
    "order": {
      "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
      "@type": "beckn:Order",
      "beckn:id": "order-ev-charging-001",
      "beckn:orderStatus": "INPROGRESS",
      "beckn:seller": "cpo1.com",
      "beckn:buyer": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Buyer",
        "beckn:id": "user-123",
        "beckn:role": "BUYER",
        "beckn:displayName": "Ravi Kumar",
        "beckn:telephone": "+91-9876543210",
        "beckn:email": "ravi.kumar@example.com",
        "beckn:taxID": "GSTIN29ABCDE1234F1Z5"
      },
      "beckn:orderItems": [
        {
          "beckn:orderedItem": "IND*ecopower-charging*cs-01*IN*ECO*BTM*01*CCS2*A*CCS2-A"
        }
      ],
      "beckn:orderValue": {
        "currency": "INR",
        "value": 143.95,
        "components": [
          {
            "type": "UNIT",
            "value": 112.5,
            "currency": "INR",
            "description": "Base charging session cost (45 INR/kWh × 2.5 kWh)"
          },
          {
            "type": "SURCHARGE",
            "value": 20.0,
            "currency": "INR",
            "description": "Surge price (20%)"
          },
          {
            "type": "DISCOUNT",
            "value": -15.0,
            "currency": "INR",
            "description": "Offer discount (15%)"
          },
          {
            "type": "FEE",
            "value": 10.0,
            "currency": "INR",
            "description": "Service fee"
          },
          {
            "type": "FEE",
            "value": 13.64,
            "currency": "INR",
            "description": "Overcharge estimation"
          },
          {
            "type": "FEE",
            "value": 2.81,
            "currency": "INR",
            "description": "Buyer finder fee (2.5%)"
          }
        ]
      },
      "beckn:fulfillment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Fulfillment",
        "beckn:id": "fulfillment-001",
        "beckn:mode": "RESERVATION",
        "beckn:deliveryAttributes": {
          "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/EvChargingSession/v1/context.jsonld)",
          "@type": "ChargingSession",
          "sessionStatus": "STOP"
        }
      },
      "beckn:payment": {
        "@context": "[https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld](https://raw.githubusercontent.com/beckn/protocol-specifications-new/refs/heads/main/schema/core/v2/context.jsonld)",
        "@type": "beckn:Payment",
        "beckn:id": "payment-123e4567-e89b-12d3-a456-426614174000",
        "beckn:amount": {
          "currency": "INR",
          "value": 143.95
        },
        "beckn:paymentURL": "[https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount](https://payments.bluechargenet-aggregator.io/pay?transaction_id=$transaction_id&amount=$amount)",
        "beckn:txnRef": "TXN-123456789",
        "beckn:paidAt": "2025-12-19T10:05:00Z",
        "beckn:beneficiary": "BPP",
        "beckn:paymentStatus": "COMPLETED"
      }
    }
  }
}
```
</details>

## 13. Conclusion

This Technical Specification Document serves as the foundational blueprint for a unified, interoperable electric vehicle charging ecosystem. By leveraging the decentralized nature of the Beckn Protocol, we are moving beyond fragmented, siloed networks toward a user-centric model where discovery, booking, and payment are seamless across all service providers.

For Consumer Application Developers (BAPs) and Charge Point Operators (BPPs), this framework offers the technical agility to innovate without the constraints of proprietary integrations. By adhering to these standards, we not only solve complex challenges like range anxiety and payment friction but also lay the groundwork for a scalable digital public infrastructure for energy.

We invite all stakeholders to adopt these specifications, contribute to the network's growth, and collaborate with us in driving the mass adoption of electric mobility. As the ecosystem evolves, we remain committed to refining these standards to ensure they meet the dynamic needs of the industry.

Happy Building!

**Team NBSL ❤️**



