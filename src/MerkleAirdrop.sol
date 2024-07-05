// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract MerkleAirdrop is EIP712{
    using SafeERC20 for IERC20;

    error MerkleAridrop__InvalidProof();
    error MerkleAridrop__AlreadyClaimed();
    error MerkleAirdrop__InvalidSignature();

    address[] claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airdropToken;
    mapping(address claimer => bool claimed) private s_hasClaimed;

    bytes32 private constant MESSAGE_TYPEHASH = keccak256("AirdropClaim(address account, uint256 amount)");

    struct AirdropClaim {
        address account;
        uint256 amount;
    }

    event Claim(address account, uint256 amount);

    constructor(bytes32 merkleRoot, IERC20 airdropToken) EIP712 ("MerkleAirdrop", "1"){
        i_merkleRoot = merkleRoot;
        i_airdropToken = airdropToken;
    }



    function createLeaf(address _address, uint256 _amount) public pure returns (bytes32) {
        bytes memory encoded = abi.encode(_address, _amount);
        return keccak256(abi.encodePacked(keccak256(encoded)));
    }




    function claim(address account, uint256 amount, bytes32[] calldata merkeProof, uint8 v, bytes32 r, bytes32 s) external {
        if (s_hasClaimed[account]) {
            revert MerkleAridrop__AlreadyClaimed();
        }
        if (!_isValidSignature(account, getMessageHash(account, amount), v, r, s)){
            revert MerkleAirdrop__InvalidSignature();
        }
        bytes32 leaf = createLeaf(account, amount);
        if (!MerkleProof.verify(merkeProof, i_merkleRoot, leaf)) {
            revert MerkleAridrop__InvalidProof();
        }
        s_hasClaimed[account] = true;
        emit Claim(account, amount);
        i_airdropToken.safeTransfer(account, amount);
    }

    function getMessageHash(address account, uint256 amount) public view returns (bytes32) {
        return _hashTypedDataV4(
            keccak256(abi.encode(MESSAGE_TYPEHASH, AirdropClaim({account: account, amount: amount})))
        );
    }

    function getAirDropToken() external view returns (IERC20) {
        return i_airdropToken;
    }

    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }

    function _isValidSignature(address account, bytes32 digest, uint8 v, bytes32 r, bytes32 s) internal pure returns (bool) {
        (address actualSigner, ,) = ECDSA.tryRecover(digest, v, r, s);
        return actualSigner == account;
    }
}
