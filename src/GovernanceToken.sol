// SPDX-License-Identifier: MIT
// Verified on Sepolia: https://sepolia.etherscan.io/address/ 0xdDF4861863F6Be4d168F5Fd42D3f7fd8642bc097
pragma solidity ^0.8.30;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import { ERC20Burnable } from "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";

contract GovernanceToken is ERC20, ERC20Burnable, Ownable {

    event TokensMinted(address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);

    constructor(uint256 initialSupply) ERC20("Governance Token", "GOV") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply * (10 ** decimals()));
    }

    function decimals() public pure override returns (uint8) {
        return 18;
    }

    function mintToken(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount * (10 ** decimals()));
        emit TokensMinted(_to, _amount);
    }

    function burnToken(uint256 _amount) public {
        _burn(msg.sender, _amount * (10 ** decimals()));
        emit TokensBurned(msg.sender, _amount);
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        require(balanceOf(msg.sender) >= 50 * 10**decimals(), "You must hold at least 100 GOV tokens to transfer.");
        return super.transfer(to, amount);
    }

}

