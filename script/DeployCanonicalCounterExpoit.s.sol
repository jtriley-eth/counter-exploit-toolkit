// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "lib/forge-std/src/Script.sol";
import "src/CounterExploit.sol";

contract DeployCanonicalCounterExploitScript is Script {
    function run() public {
        bytes32 slot = bytes32(uint256(keccak256("counter-exploit-toolkit.admin")) - 1);
        bytes32 admin = 0x0000000000000000000000000000000000000000000000000000000000000001;

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        CounterExploit ce = new CounterExploit();
        ce.initialize();
        ce.write(slot, admin);
        vm.stopBroadcast();
    }
}
