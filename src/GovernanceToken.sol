// SPDX-License-Identifier: MIT
// Verified on Sepolia: https://sepolia.etherscan.io/address/0xdDF4861863F6Be4d168F5Fd42D3f7fd8642bc097
pragma solidity ^0.8.30;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title Governance Token
 * @notice This contract implements an ERC20-compatible governance token with minting and burning functionalities.
 * @dev Inherits from OpenZeppelin's ERC20, ERC20Burnable, and Ownable for token logic, burning, and access control.
 * @custom:verified Verified on Sepolia Testnet at 0xdDF4861863F6Be4d168F5Fd42D3f7fd8642bc097
 */
contract GovernanceToken is ERC20, ERC20Burnable, Ownable {

    /// @notice Emitted when new tokens are minted.
    /// @param to The address receiving the newly minted tokens.
    /// @param amount The number of tokens minted (in base units, before applying decimals).
    event TokensMinted(address indexed to, uint256 amount);

    /// @notice Emitted when tokens are burned.
    /// @param from The address from which tokens were burned.
    /// @param amount The number of tokens burned (in base units, before applying decimals).
    event TokensBurned(address indexed from, uint256 amount);

    /**
     * @notice Initializes the governance token with a specified initial supply.
     * @dev The deployer becomes the initial owner and receives the full supply.
     * @param initialSupply The initial supply of tokens (without considering decimals).
     */
    constructor(uint256 initialSupply)
        ERC20("Governance Token", "GOV")
        Ownable(msg.sender)
    {
        _mint(msg.sender, initialSupply * (10 ** decimals()));
    }

    /**
     * @notice Returns the number of decimal places used by the token.
     * @dev This overrides the default ERC20 decimals function to explicitly set it to 18.
     * @return uint8 Always returns 18.
     */
    function decimals() public pure override returns (uint8) {
        return 18;
    }

    /**
     * @notice Allows the owner to mint new tokens to a specific address.
     * @dev Only callable by the contract owner. Emits a {TokensMinted} event.
     * @param _to The recipient address for the newly minted tokens.
     * @param _amount The amount of tokens to mint (before applying decimals).
     */
    function mintToken(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount * (10 ** decimals()));
        emit TokensMinted(_to, _amount);
    }

    /**
     * @notice Allows any user to burn their own tokens.
     * @dev The specified amount is multiplied by the token's decimals to match ERC20 standards.
     * Emits a {TokensBurned} event.
     * @param _amount The amount of tokens to burn (before applying decimals).
     */
    function burnToken(uint256 _amount) public {
        _burn(msg.sender, _amount * (10 ** decimals()));
        emit TokensBurned(msg.sender, _amount);
    }

    /**
     * @notice Transfers tokens to another address, subject to a minimum balance requirement.
     * @dev Overrides the ERC20 `transfer` function. The sender must hold at least 50 GOV tokens to transfer.
     * @param to The address receiving the tokens.
     * @param amount The amount of tokens to transfer.
     * @return bool Returns true if the transfer is successful.
     */
    function transfer(address to, uint256 amount) public override returns (bool) {
        require(
            balanceOf(msg.sender) >= 50 * 10**decimals(),
            "You must hold at least 100 GOV tokens to transfer."
        );
        return super.transfer(to, amount);
    }
}
