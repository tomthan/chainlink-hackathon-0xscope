// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

struct Log {
    uint256 index; // Index of the log in the block
    uint256 timestamp; // Timestamp of the block containing the log
    bytes32 txHash; // Hash of the transaction containing the log
    uint256 blockNumber; // Number of the block containing the log
    bytes32 blockHash; // Hash of the block containing the log
    address source; // Address of the contract that emitted the log
    bytes32[] topics; // Indexed topics of the log
    bytes data; // Data of the log
}

interface ILogAutomation {
    function checkLog(
        Log calldata log,
        bytes memory checkData
    ) external returns (bool upkeepNeeded, bytes memory performData);

    function performUpkeep(bytes calldata performData) external;
}

interface IRevokeFor {
    function RevokeFor(bytes32 wid) external returns (bool);
}

contract RevokeWithLog is ILogAutomation {
    event RevokedBy(bytes32 indexed msgSender);

    IRevokeFor public _router;

    constructor(IRevokeFor router) {
        _router = router;
    }

    function checkLog(
        Log calldata log,
        bytes memory
    ) external pure returns (bool upkeepNeeded, bytes memory performData) {
        upkeepNeeded = true;
        bytes32 lid = log.topics[1];
        performData = abi.encode(lid);
    }

    function performUpkeep(bytes calldata performData) external override {
        bytes32 lid = abi.decode(performData, (bytes32));
        _router.RevokeFor(lid);
        emit RevokedBy(lid);
    }
}
