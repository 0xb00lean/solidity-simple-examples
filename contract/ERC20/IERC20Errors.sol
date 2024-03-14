// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20Errors {
    // 余额不足
    error ERC20InsufficientBalance(
        address sender,
        uint256 balance,
        uint256 needed
    );

    // 发送者错误
    error ERC20InvalidSender(address sender);

    // 接收者错误
    error ERC20InvalidReceiver(address receiver);

    // 被授权余额不足
    error ERC20InsufficientAllowance(
        address spender,
        uint256 allowance,
        uint256 needed
    );

    // 授权人错误
    error ERC20InvalidApprover(address approver);

    // 被授权人错误
    error ERC20InvalidSpender(address spender);

    // 非合约 owner
    error OwnableUnauthorizedAccount(address account);
}
