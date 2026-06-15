package policy

import rego.v1

# =============================================================================
# EV Charging Policy — Combined BAP & BPP Receiver Validation
# =============================================================================
# This file contains two logical layers of policy:
#
#   1. BAP Receiver Policy  — validates ON_* callbacks arriving FROM BPP to BAP.
#      These are responses the BPP sends back after the BAP initiated a flow.
#      Rules here protect the BAP application from incomplete/invalid responses.
#
#   2. BPP Receiver Policy  — validates forward actions arriving FROM BAP to BPP.
#      These are requests the BAP sends into the network to initiate a flow.
#      Rules here protect the BPP application from incomplete/invalid requests.
#
# Field paths use Beckn v2 schema convention (namespaced keys like "beckn:*").
# =============================================================================

# Default result: valid with no violations.
default result := {
    "valid": true,
    "violations": [],
}

# Compute result from collected violations.
result := {
    "valid": count(violations) == 0,
    "violations": violations,
}

# =============================================================================
# BAP RECEIVER POLICY  —  ON_* callbacks (BPP → BAP)
# =============================================================================

# ----------------------------------------------------------------------------
# on_discover
# ----------------------------------------------------------------------------
# CDS/BPP must return a catalogs array with at least one entry.

violations contains "on_discover: missing catalogs in response" if {
    input.context.action == "on_discover"
    not input.message.catalogs
}

# ----------------------------------------------------------------------------
# on_select
# ----------------------------------------------------------------------------
# BPP must return an order with orderValue (beckn:orderValue) so the BAP
# knows the price before proceeding to init.

violations contains "on_select: missing order in response" if {
    input.context.action == "on_select"
    not input.message.order
}

violations contains "on_select: missing order value in response" if {
    input.context.action == "on_select"
    input.message.order
    not input.message.order["beckn:orderValue"]
}

# ----------------------------------------------------------------------------
# on_init
# ----------------------------------------------------------------------------
# BPP must return an order with payment terms (beckn:payment) so the BAP
# can proceed to confirm.

violations contains "on_init: missing order in response" if {
    input.context.action == "on_init"
    not input.message.order
}

violations contains "on_init: missing payment terms in order" if {
    input.context.action == "on_init"
    input.message.order
    not input.message.order["beckn:payment"]
}

# ----------------------------------------------------------------------------
# on_confirm
# ----------------------------------------------------------------------------
# BPP must return a confirmed order with an id and status — the booking reference.

violations contains "on_confirm: missing order in response" if {
    input.context.action == "on_confirm"
    not input.message.order
}

violations contains "on_confirm: missing order id" if {
    input.context.action == "on_confirm"
    input.message.order
    not input.message.order["beckn:id"]
}

violations contains "on_confirm: missing order status" if {
    input.context.action == "on_confirm"
    input.message.order
    not input.message.order["beckn:orderStatus"]
}

# ----------------------------------------------------------------------------
# on_update
# ----------------------------------------------------------------------------
# BPP must return an updated order with id and status.

violations contains "on_update: missing order in response" if {
    input.context.action == "on_update"
    not input.message.order
}

violations contains "on_update: missing order id" if {
    input.context.action == "on_update"
    input.message.order
    not input.message.order["beckn:id"]
}

# ----------------------------------------------------------------------------
# on_status
# ----------------------------------------------------------------------------
# BPP must return the current order status (beckn:orderStatus) so the BAP
# knows the charging session status.

violations contains "on_status: missing order in response" if {
    input.context.action == "on_status"
    not input.message.order
}

violations contains "on_status: missing order status" if {
    input.context.action == "on_status"
    input.message.order
    not input.message.order["beckn:orderStatus"]
}

# ----------------------------------------------------------------------------
# on_track
# ----------------------------------------------------------------------------
# BPP must return an order with fulfillment details (beckn:fulfillment).

violations contains "on_track: missing order in response" if {
    input.context.action == "on_track"
    not input.message.order
}

violations contains "on_track: missing fulfillment in order" if {
    input.context.action == "on_track"
    input.message.order
    not input.message.order["beckn:fulfillment"]
}

# ----------------------------------------------------------------------------
# on_cancel
# ----------------------------------------------------------------------------
# BPP must confirm the cancellation with an order id and status.

violations contains "on_cancel: missing order in response" if {
    input.context.action == "on_cancel"
    not input.message.order
}

violations contains "on_cancel: missing order id" if {
    input.context.action == "on_cancel"
    input.message.order
    not input.message.order["beckn:id"]
}

violations contains "on_cancel: missing order status" if {
    input.context.action == "on_cancel"
    input.message.order
    not input.message.order["beckn:orderStatus"]
}

# =============================================================================
# BPP RECEIVER POLICY  —  forward actions (BAP → BPP)
# =============================================================================

# ----------------------------------------------------------------------------
# discover
# ----------------------------------------------------------------------------
# Rules:
#   1. QR flow  — if filters.expression contains "beckn:itemAttributes.qrIdentifier",
#                 spatial is NOT required. The QR identifier is a precise enough
#                 target that a radius search is unnecessary.
#   2. All other flows — spatial MUST be present (filters alone is insufficient
#                        without a QR identifier in the expression).
#   3. For any spatial entry that IS provided, distanceMeters must not exceed
#      10 000 m (10 km) to prevent unbounded area queries.

# Helper: true when the filters expression targets a QR identifier.
discover_is_qr_flow if {
    input.context.action == "discover"
    input.message.filters.expression
    contains(input.message.filters.expression, "beckn:itemAttributes.qrIdentifier")
}

# Non-QR requests must carry a spatial block.
violations contains "discover: non-QR request missing spatial in message" if {
    input.context.action == "discover"
    not discover_is_qr_flow
    not input.message.spatial
}

# Every spatial entry must have distanceMeters ≤ 10 000.
violations contains "discover: spatial distanceMeters exceeds maximum of 10000" if {
    input.context.action == "discover"
    some entry in input.message.spatial
    entry.distanceMeters > 10000
}

# ----------------------------------------------------------------------------
# select
# ----------------------------------------------------------------------------
# BAP must specify which items it wants to select (beckn:orderItems).

violations contains "select: missing order in message" if {
    input.context.action == "select"
    not input.message.order
}

violations contains "select: missing order items" if {
    input.context.action == "select"
    input.message.order
    not input.message.order["beckn:orderItems"]
}

# ----------------------------------------------------------------------------
# init
# ----------------------------------------------------------------------------
# BAP must provide buyer and payment details to draft an order.
# Note: Postman init payload has beckn:payment but NOT beckn:fulfillment.

violations contains "init: missing order in message" if {
    input.context.action == "init"
    not input.message.order
}

violations contains "init: missing buyer info" if {
    input.context.action == "init"
    input.message.order
    not input.message.order["beckn:buyer"]
}

violations contains "init: missing payment info" if {
    input.context.action == "init"
    input.message.order
    not input.message.order["beckn:payment"]
}

# ----------------------------------------------------------------------------
# confirm
# ----------------------------------------------------------------------------
# BAP must provide complete order details to confirm the booking.
# Postman confirm has: beckn:seller, beckn:buyer, beckn:payment
# (no beckn:fulfillment).

violations contains "confirm: missing order in message" if {
    input.context.action == "confirm"
    not input.message.order
}

violations contains "confirm: missing seller in order" if {
    input.context.action == "confirm"
    input.message.order
    not input.message.order["beckn:seller"]
}

violations contains "confirm: missing buyer info" if {
    input.context.action == "confirm"
    input.message.order
    not input.message.order["beckn:buyer"]
}

violations contains "confirm: missing payment info" if {
    input.context.action == "confirm"
    input.message.order
    not input.message.order["beckn:payment"]
}

# ----------------------------------------------------------------------------
# update
# ----------------------------------------------------------------------------
# BAP must provide a valid order with an id to update (beckn:id).

violations contains "update: missing order in message" if {
    input.context.action == "update"
    not input.message.order
}

violations contains "update: missing order id" if {
    input.context.action == "update"
    input.message.order
    not input.message.order["beckn:id"]
}

# ----------------------------------------------------------------------------
# status
# ----------------------------------------------------------------------------
# BAP must provide an order id to reference an existing order (beckn:id).

violations contains "status: missing order in message" if {
    input.context.action == "status"
    not input.message.order
}

violations contains "status: missing order id" if {
    input.context.action == "status"
    input.message.order
    not input.message.order["beckn:id"]
}

# ----------------------------------------------------------------------------
# track
# ----------------------------------------------------------------------------
# BAP must provide an order id to reference an existing order (beckn:id).

violations contains "track: missing order in message" if {
    input.context.action == "track"
    not input.message.order
}

violations contains "track: missing order id" if {
    input.context.action == "track"
    input.message.order
    not input.message.order["beckn:id"]
}

# ----------------------------------------------------------------------------
# cancel
# ----------------------------------------------------------------------------
# Postman cancel sends message.order as a JSON ARRAY of order objects.
# We only require the array to be present and non-empty.

violations contains "cancel: missing order in message" if {
    input.context.action == "cancel"
    not input.message.order
}

violations contains "cancel: order list is empty" if {
    input.context.action == "cancel"
    input.message.order
    count(input.message.order) == 0
}
