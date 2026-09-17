package policy

import rego.v1

# BPP Receiver Policy — validates forward actions arriving FROM BAP to BPP.
# These are requests the BAP sends into the network to initiate a flow.
# Rules here protect the BPP application from receiving incomplete/invalid requests.
# Field paths use Beckn v2 schema convention (namespaced keys like "beckn:*").

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

# ============================================================================
# discover
# ============================================================================

# BAP must provide at least one of: spatial filter or filters object.
# Some variants (along-a-route, within-a-boundary) use "spatial".
# Others (by-EVSE, by-a-CPO, by-a-station, QR) use "filters".
# Both may be present simultaneously.

violations contains "discover: missing spatial or filters in message" if {
    input.context.action == "discover"
    not input.message.spatial
    not input.message.filters
}

# ============================================================================
# select
# ============================================================================

# BAP must specify which items it wants to select (Beckn v2: beckn:orderItems).

violations contains "select: missing order in message" if {
    input.context.action == "select"
    not input.message.order
}

violations contains "select: missing order items" if {
    input.context.action == "select"
    input.message.order
    not input.message.order["beckn:orderItems"]
}

# ============================================================================
# init
# ============================================================================

# BAP must provide buyer and payment details to draft an order (Beckn v2).
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

# ============================================================================
# confirm
# ============================================================================

# BAP must provide complete order details to confirm the booking (Beckn v2).
# Postman confirm has: beckn:seller, beckn:buyer, beckn:payment (no beckn:fulfillment).

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

# ============================================================================
# update
# ============================================================================

# BAP must provide a valid order with an id to update (Beckn v2: beckn:id).

violations contains "update: missing order in message" if {
    input.context.action == "update"
    not input.message.order
}

violations contains "update: missing order id" if {
    input.context.action == "update"
    input.message.order
    not input.message.order["beckn:id"]
}

# ============================================================================
# status / track
# ============================================================================

# BAP must provide order id to reference an existing order (Beckn v2: beckn:id).

violations contains "status: missing order in message" if {
    input.context.action == "status"
    not input.message.order
}

violations contains "status: missing order id" if {
    input.context.action == "status"
    input.message.order
    not input.message.order["beckn:id"]
}

violations contains "track: missing order in message" if {
    input.context.action == "track"
    not input.message.order
}

violations contains "track: missing order id" if {
    input.context.action == "track"
    input.message.order
    not input.message.order["beckn:id"]
}

# ============================================================================
# cancel
# ============================================================================

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
