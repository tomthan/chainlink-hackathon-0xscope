// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./RevokeWallet.sol";

struct RevekeData {
    address wallet;
    address token;
    address spender;
    bool isused;
}

contract RevokeRouter {
    event RevokeForEvent(bytes32 indexed id);
    event WalletIDEvent(
        bytes32 indexed id,
        address indexed wallet,
        address indexed token
    );
    event WalletCreateEvent(address indexed owner, address indexed wallet);

    mapping(bytes32 => RevekeData) public revokeMap;

    constructor() {}

    function RevokeFor(bytes32 wid) external returns (bool) {
        if (!revokeMap[wid].isused) {
            return false;
        }

        RevekeData memory _data = revokeMap[wid];

        emit RevokeForEvent(wid);

        return IWallet(_data.wallet).Revoke(_data.token, _data.spender);
    }

    function createWallet() external returns (address) {
        RevokeWallet wallet = new RevokeWallet(msg.sender, address(this));
        emit WalletCreateEvent(msg.sender, address(wallet));
        return address(wallet);
    }

    function register(
        address _wallet,
        address _token,
        address _spender
    ) public returns (bytes32) {
        bytes32 wid = sha256(abi.encode(_wallet, _token, _spender));
        RevekeData memory _data = RevekeData(_wallet, _token, _spender, true);

        revokeMap[wid] = _data;

        emit WalletIDEvent(wid, _wallet, _token);

        return wid;
    }

    function getRegisters(
        bytes32 wid
    ) external view returns (address, address, address) {
        RevekeData memory _data = revokeMap[wid];
        return (_data.wallet, _data.token, _data.spender);
    }

    function getWalletID(
        address _wallet,
        address _token,
        address _spender
    ) public pure returns (bytes32) {
        bytes32 wid = sha256(abi.encode(_wallet, _token, _spender));
        return wid;
    }
}
