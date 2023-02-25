// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "lib/solmate/src/tokens/ERC20.sol";

contract VaultMock {
    mapping(address => uint256) public etherDeposit;
    mapping(address => mapping(ERC20 => uint256)) public tokenDeposit;

    function deposit(ERC20 token, uint256 amount) public {
        token.transferFrom(msg.sender, address(this), amount);
        tokenDeposit[msg.sender][token] += amount;
    }

    function depositEther() public payable {
        etherDeposit[msg.sender] += msg.value;
    }
}
