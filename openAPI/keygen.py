#!/usr/bin/env python3
"""
Key Generation Script for DeDi Registry
Generates Ed25519 signing keys and X25519 encryption keys
"""

import base64
from cryptography.hazmat.primitives.asymmetric import ed25519, x25519
from cryptography.hazmat.primitives import serialization

def main():
    # Generate Ed25519 signing key pair
    signing_private = ed25519.Ed25519PrivateKey.generate()
    signing_public = signing_private.public_key()
    
    # Get the seed (first 32 bytes of private key) - this is what Go returns
    signing_private_bytes = signing_private.private_bytes(
        encoding=serialization.Encoding.Raw,
        format=serialization.PrivateFormat.Raw,
        encryption_algorithm=serialization.NoEncryption()
    )
    signing_public_bytes = signing_public.public_bytes(
        encoding=serialization.Encoding.Raw,
        format=serialization.PublicFormat.Raw
    )
    
    # Generate X25519 encryption key pair
    encr_private = x25519.X25519PrivateKey.generate()
    encr_public = encr_private.public_key()
    
    encr_private_bytes = encr_private.private_bytes(
        encoding=serialization.Encoding.Raw,
        format=serialization.PrivateFormat.Raw,
        encryption_algorithm=serialization.NoEncryption()
    )
    encr_public_bytes = encr_public.public_bytes(
        encoding=serialization.Encoding.Raw,
        format=serialization.PublicFormat.Raw
    )
    
    # Output in same format as the Go script
    print("=== Complete Keyset for DeDi Registry ===")
    print(f"signingPrivateKey: {base64.b64encode(signing_private_bytes).decode('utf-8')}")
    print(f"signingPublicKey: {base64.b64encode(signing_public_bytes).decode('utf-8')}")
    print(f"encrPrivateKey: {base64.b64encode(encr_private_bytes).decode('utf-8')}")
    print(f"encrPublicKey: {base64.b64encode(encr_public_bytes).decode('utf-8')}")

if __name__ == "__main__":
    main()