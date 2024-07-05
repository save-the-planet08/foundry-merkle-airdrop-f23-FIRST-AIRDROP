# Foundry Merkle Airdrop

## Overview

The Foundry Merkle Airdrop project is designed to distribute ERC-20 tokens efficiently and securely using Merkle tree proofs. This ensures that only eligible addresses can claim their tokens and prevents duplicate claims.

## Features

- **Merkle Tree Proofs:** Efficient verification of eligible claims.
- **Secure Claims:** Ensures each address can only claim once.
- **EIP-712 Integration:** Utilizes EIP-712 for structured data hashing and signing.

## Contract Details

### MerkleAirdrop.sol

The core contract of the project is `MerkleAirdrop.sol`, which handles the airdrop functionality. Key components include:

- **Constructor:** Initializes the contract with the Merkle root and the ERC-20 token to be airdropped.
- **createLeaf:** Creates a Merkle tree leaf from an address and amount.
- **claim:** Allows an eligible address to claim their tokens if they provide a valid Merkle proof and signature.
- **getMessageHash:** Returns the hash of the claim message.
- **getAirDropToken:** Returns the token being airdropped.
- **getMerkleRoot:** Returns the Merkle root used for the airdrop.
- **_isValidSignature:** Validates the signature of the claim.

## Errors

- **MerkleAridrop__InvalidProof:** Thrown when an invalid Merkle proof is provided.
- **MerkleAridrop__AlreadyClaimed:** Thrown when an address tries to claim tokens more than once.
- **MerkleAirdrop__InvalidSignature:** Thrown when an invalid signature is provided.

## Events

- **Claim:** Emitted when a successful claim is made.

## Setup and Installation

1. **Clone the Repository:**
    ```sh
    git clone https://github.com/your-username/foundry-merkle-airdrop.git
    cd foundry-merkle-airdrop
    ```

2. **Install Foundry:**
    Follow the instructions to install Foundry from the [official Foundry repository](https://github.com/foundry-rs/foundry).

3. **Build the Project:**
    ```sh
    forge build
    ```

## Testing

To run the tests, use the following command:

```sh
forge test
