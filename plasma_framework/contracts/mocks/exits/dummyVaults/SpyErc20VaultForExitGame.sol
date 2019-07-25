pragma solidity ^0.5.0;

import "../../../src/vaults/Erc20Vault.sol";
import "../../../src/framework/PlasmaFramework.sol";

contract SpyErc20VaultForExitGame is Erc20Vault {
    event DummyErc20Withdraw(
        address target,
        address token,
        uint256 amount
    );

    constructor(PlasmaFramework _framework) public Erc20Vault(_framework) {}

    /** override for test */
    function withdraw(address payable _target, address _token, uint256 _amount) external {
        emit DummyErc20Withdraw(_target, _token, _amount);
    }
}