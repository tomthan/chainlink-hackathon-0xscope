// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IWallet {
    function Revoke(address token, address spender) external returns (bool);
}
