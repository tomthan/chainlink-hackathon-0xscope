// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./IRevokeWallet.sol";

contract RevokeWallet is IWallet {
    event RevokedNotify(address indexed token, address indexed spender);
    address public router;
    address public owner;

    constructor(address _owner, address _router) {
        owner = _owner;
        router = _router;
    }

    function Approve(
        address token,
        address _spender,
        uint256 amount
    ) external onlyOwner returns (bool) {
        return IERC20(token).approve(_spender, amount);
    }

    function Revoke(address _token, address _spender) external returns (bool) {
        require(msg.sender == router, "sender must be router contract");
        bool isok = IERC20(_token).approve(_spender, 0);

        if (isok) {
            emit RevokedNotify(_token, _spender);
        }

        return isok;
    }

    function getAllowance(
        address _token,
        address _spender
    ) external view returns (uint256) {
        return IERC20(_token).allowance(address(this), _spender);
    }

    function setRouter(address _router) public onlyOwner {
        router = _router;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        owner = newOwner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }
}
