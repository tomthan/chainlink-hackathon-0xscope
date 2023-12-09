// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract RevokeEmitLog {
    event RevokeNotify(bytes32 indexed id);

    constructor() {}

    function emitRevokeLog(bytes32 _id) public {
        emit RevokeNotify(_id);
    }
}
