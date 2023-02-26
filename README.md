# The Counter Exploit Toolkit

> NOTICE: FOR RESEARCH PURPOSES ONLY.

## Overiew

This repository contains the contract `CounterExploit`, which contains all of the logic needed for
an upgradeable proxy-based counter exploit.

It provides arbitrary storage write access, arbitrary token withdrawal access, ether withdrawal
access, an ether deposit honeypot, and, provided the attacker has sufficient balance and allowance
for the proxy contract, it has the ability to take tokens directly from the attacker.

Each function includes a batchable interface for executing multiple operations in the same
transaction.

It may be upgraded to, then upgraded from once the counter exploit is complete.

## Who Is This For?

This contract is for two kinds of actors. First is the institutional actors that intend to follow
the demands or requests of law enforcement to counter exploit the attacker. Second is for users of
protocols with upgradeable proxies that may not be aware of the implications of such technology.

### For Institutional Actors

This contract will have a canonical deployment that may be delecatecalled. All you need to do is
send a transaction from the current proxy's authorized address that upgrades the current
implementation address to the `CounterExploit` address and call `initialize()`
_IN THE SAME TRANSACTION_. It is important to note that not atomically upgradingn and initializing
will open a front-running opportunity that will give the attacker full control over your contract.
This is the most crucial step, do not get this wrong.

Once upgraded and initialized, you may step on your technology accelerationist gas pedal and see
upradeable proxies through to their end; controlled by coercive, powerful actors for any purpose
they see fit.

See the API section below for more about specifics.

### For Users of Protocols with Upgradeable Proxies

It is important to know exactly what you, a user, are getting into when interacting with protocols
that use upgradeable proxies. Any contract that has an authorized address to upgrade the proxy has
the ability to do this, regardless of whether the controller is a EOA, multisig, DAO, or an
attacker through some other potential exploit in the protocol.

Definitions:

**Arbitrary storage write access**: Any storage slot within the contract may be overwritten. This
includes, but is not limited to recordings of deposits, internal permissions, and authorized
addresses.

**Arbitrary token withdrawal access**: Any tokens that are in the contract may be withdrawn from
the contract itself. This includes up to the full amount but may be more precise by targeting
attackers in particular. Note that this will likely need to be used in parallel with storage writes.
For example, if an attacker's funds need to be taken, the protocol must both take the tokens from
the contract itself and overwrite the attacker's deposit slot to ensure they may not withdraw any
other tokens from the protocol.

**Ether withdrawal access**: Similar to arbitrary token withdrawal access, any ether that the
contract holds may be withdrawn.

**Steal token access**: This is likely the most important to understand. Protocols often require
some kind of ERC20 token approval to act on the user's behalf, particularly with things like
deposits and swaps. It is a common user experience pattern to ask the user to give "infinite"
approval to the contract to prevent the user from having to run redundant transactions. However,
combining this with upgradeable proxies means that not only can tokens be withdrawn from the proxy
itself, but they may also be taken **from the user**, provided they have sufficient allowance
granted to the contract. This may be useful to recover an attacker's stolen funds, but this is not
enforceable to limit it to just the attacker. If you want to see and potentially revoke your token
allowances, you may do so from here https://revoke.cash/

## API

The following methods are implemented on the `CounterExploit` contract.

### Write Access

```solidity
/// @notice Writes a value to storage.
/// @dev Reverts if caller is not admin.
/// @param slot The storage slot to write to.
/// @param value The value to write.
function write(bytes32 slot, bytes32 value);

/// @notice Batch writes values to storage.
/// @dev Reverts if caller is not admin.
/// @param slots The storage slots to write to.
/// @param values The values to write.
function writeBatch(bytes32[] calldata slots, bytes32[] calldata values);
```

### Token Withdrawal Access

```solidity
/// @notice Transfers tokens from this address to a receiver.
/// @dev Reverts if caller is not admin.
/// @param receiver The address to transfer tokens to.
/// @param token The token to transfer.
/// @param amount The amount of tokens to transfer.
function takeToken(address receiver, ERC20 token, uint256 amount);

/// @notice Batch transfers tokens from this address to a receiver.
/// @dev Reverts if caller is not admin.
/// @param receiver The address to transfer tokens to.
/// @param tokens The tokens to transfer.
/// @param amounts The amounts of tokens to transfer.
function takeTokenBatch(address receiver, ERC20[] calldata tokens, uint256[] calldata amounts);
```


### Ether Withdrawal Access

```solidity
/// @notice Transfers ether to a receiver.
/// @dev Reverts if caller is not admin.
/// @param receiver The address to transfer ether to.
/// @param amount The amount of ether to transfer.
/// @return success True if the transfer succeeded (used to remove solc warning).
function takeEther(address receiver, uint256 amount)
```

### Steal Token Access

```solidity
/// @notice Transfers tokens from the attacker to a receiver.
/// @dev Reverts if caller is not admin. Gets the attacker's balance and allowance and transfers
/// the lesser of the two.
/// @param attacker The address to trasnfer tokens from.
/// @param receiver The address to transfer tokens to.
/// @param token The token to transfer.
/// @param amount The amount of tokens to transfer.
function stealToken(
    address attacker,
    address receiver,
    ERC20 token,
    uint256 amount
);

/// @notice Batch transfers tokens from the attacker to a receiver.
/// @dev Reverts if caller is not admin.
/// @param receiver The address to transfer tokens to.
/// @param tokens The tokens to transfer.
/// @param amounts The amounts of tokens to transfer.
function stealTokenBatch(
    address attacker,
    address receiver,
    ERC20[] calldata tokens,
    uint256[] calldata amounts
);
```

### Ether Receive Honeypot

```solidity
/// @notice Receives any amount of Ether without taking action.
receive() external payable {}
```
