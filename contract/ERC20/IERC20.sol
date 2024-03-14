// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    // 转账时 emit
    event Transfer(address indexed from, address indexed to, uint256 value);

    // 授权转账时 emit
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    // 获取当前 token 总数
    function totalSupply() external view returns (uint256);

    // 获取 account 的余额
    function balanceOf(address account) external view returns (uint256);

    // 转账
    function transfer(address to, uint256 value) external returns (bool);

    // 获取 owner 授权给 spender 的余额
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    // 授权给 spender
    function approve(address spender, uint256 value) external returns (bool);

    // spender 转账时使用
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}
