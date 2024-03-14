// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "./IERC20.sol";
import {IERC20Errors} from "./IERC20Errors.sol";

contract ERC20 is IERC20, IERC20Errors {
    // 存储地址对应的 token 数量
    mapping(address => uint256) private _balance;

    // 存储用户授权给 spender 的 token 数
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    uint8 private _decimals;
    address private _owner;
    string private _name;
    string private _symbol;

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) {
        // 设置 token 名、token 符号、token 小数位数以及合约 owner
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _owner = msg.sender;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balance[account];
    }

    function _update(
        address from,
        address to,
        uint256 value
    ) private {
        if (from == address(0)) {
            _totalSupply += value;
        } else {
            uint256 fromBalance = _balance[from];
            if (fromBalance < value) {
                revert ERC20InsufficientBalance(from, fromBalance, value);
            }
            unchecked {
                _balance[from] = fromBalance - value;
            }
        }
        if (to == address(0)) {
            unchecked {
                _totalSupply -= value;
            }
        } else {
            unchecked {
                _balance[to] += value;
            }
        }
        emit Transfer(from, to, value);
    }

    function _transfer(
        address from,
        address to,
        uint256 value
    ) private {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(from, to, value);
    }

    function transfer(address to, uint256 value) public returns (bool) {
        address from = msg.sender;
        _transfer(from, to, value);
        return true;
    }

    function allowance(address owner_, address spender_)
        public
        view
        returns (uint256)
    {
        return _allowances[owner_][spender_];
    }

    function _approve(
        address owner_,
        address spender_,
        uint256 value_,
        bool emitEvent_
    ) private {
        if (owner_ == address(0)) {
            revert ERC20InvalidApprover(address(0));
        }
        if (spender_ == address(0)) {
            revert ERC20InvalidSpender(address(0));
        }
        _allowances[owner_][spender_] = value_;
        if (emitEvent_) {
            emit Approval(owner_, spender_, value_);
        }
    }

    function _approve(
        address owner_,
        address spender_,
        uint256 value_
    ) private {
        _approve(owner_, spender_, value_, true);
    }

    function approve(address spender_, uint256 value_) public returns (bool) {
        address owner_ = msg.sender;
        _approve(owner_, spender_, value_);
        return true;
    }

    function _spendAllowance(
        address owner_,
        address spender_,
        uint256 value_
    ) private {
        uint256 currentAllowance = allowance(owner_, spender_);
        if (currentAllowance != type(uint256).max) {
            if (currentAllowance < value_) {
                revert ERC20InsufficientAllowance(
                    spender_,
                    currentAllowance,
                    value_
                );
            }
            unchecked {
                _approve(owner_, spender_, currentAllowance - value_, false);
            }
        }
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool) {
        address spender_ = msg.sender;
        _spendAllowance(from, spender_, value);
        _transfer(from, to, value);
        return true;
    }

    modifier onlyOwner() {
        address account = msg.sender;
        if (owner() != account) {
            revert OwnableUnauthorizedAccount(account);
        }
        _;
    }

    // 铸造
    function mint(address account, uint256 value) public onlyOwner {
        if (account == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(address(0), account, value);
    }

    // 销毁
    function burn(uint256 value) public onlyOwner {
        address account = msg.sender;
        _update(account, address(0), value);
    }

    // 放弃合约 owner
    function renounceOwnerShip() public onlyOwner {
        _owner = address(0);
    }
}
