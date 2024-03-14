// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "../ERC20/IERC20.sol";

contract Faucet {
    event SendToken(address indexed receiver, uint256 indexed amount);
    error AlreadyWithdraw(address receiver);
    error FaucetIsEmpty(uint256 balance);

    // 每次允许领取代币数量
    uint256 private _amountAllowed = 100;
    // 代币合约地址
    address private immutable _tokenContract;
    // 记录领取过代币的地址
    mapping(address => bool) private _requestedAddress;

    constructor(address tokenContract_) {
        _tokenContract = tokenContract_;
    }

    // 查询每次允许领取代币数量
    function amountAllowed() public view returns (uint256) {
        return _amountAllowed;
    }

    // 查询某个地址是否已领取
    function queryRequestedStatus(address receiver_)
        public
        view
        returns (bool)
    {
        return _requestedAddress[receiver_];
    }

    // 领取代币
    function withdraw() public {
        address receiver_ = msg.sender;
        if (_requestedAddress[receiver_]) {
            revert AlreadyWithdraw(receiver_);
        }
        IERC20 token_ = IERC20(_tokenContract);
        if (token_.balanceOf(address(this)) < _amountAllowed) {
            revert FaucetIsEmpty(token_.balanceOf(address(this)));
        }
        token_.transfer(receiver_, _amountAllowed);
        _requestedAddress[receiver_] = true;
        emit SendToken(receiver_, _amountAllowed);
    }
}
