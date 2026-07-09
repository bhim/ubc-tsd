package policy

import rego.v1

# BAP Receiver Policy — validates ON_* callbacks arriving FROM BPP to BAP.
# These are responses the BPP sends back after BAP initiated a flow.
# Rules here protect the BAP application from receiving incomplete/invalid responses.
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
# on_discover
# ============================================================================

# CDS/BPP must return catalogs array with at least one entry.

violations contains "on_discover: missing catalogs in response" if {
    input.context.action == "on_discover"
    not input.message.catalogs
}

# ============================================================================
# on_select
# ============================================================================

# BPP must return order with orderValue (Beckn v2: beckn:orderValue) so BAP
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

# ============================================================================
# on_init
# ============================================================================

# BPP must return order with payment terms (Beckn v2: beckn:payment) so BAP
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

# ============================================================================
# on_confirm
# ============================================================================

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

# ============================================================================
# on_update
# ============================================================================

# BPP must return updated order with id and status.

violations contains "on_update: missing order in response" if {
    input.context.action == "on_update"
    not input.message.order
}

violations contains "on_update: missing order id" if {
    input.context.action == "on_update"
    input.message.order
    not input.message.order["beckn:id"]
}

# ============================================================================
# on_status
# ============================================================================

# BPP must return current order status (Beckn v2: beckn:orderStatus) so BAP
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

# ============================================================================
# on_track
# ============================================================================

# BPP must return order with fulfillment details (Beckn v2: beckn:fulfillment).

violations contains "on_track: missing order in response" if {
    input.context.action == "on_track"
    not input.message.order
}

violations contains "on_track: missing fulfillment in order" if {
    input.context.action == "on_track"
    input.message.order
    not input.message.order["beckn:fulfillment"]
}

# ============================================================================
# on_cancel
# ============================================================================

# BPP must confirm the cancellation with order id and status.

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
