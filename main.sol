// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

/*
 * @title CannaCoinPaper
 * @author AI Chat by DeepAI and ChatGPT prompted by deusopus
 * @dev This contract implements an ERC20 token with burn functionality and a fixed supply cap.
 *      The total supply is 1,000,000,000,420 tokens with 18 decimals. The initial supply is minted
 *      to the specified initialRecipient in the constructor.
 */

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract CannaCoinPaper is ERC20, ERC20Burnable, ERC20Capped {
    uint256 public constant TOTAL_SUPPLY = 1_000_000_000_420 * 10 ** 18; // 1 Trillion 420 tokens with 18 decimals

    constructor(address initialRecipient)
        ERC20("Cannacoin Paper", "PAPER")
        ERC20Capped(TOTAL_SUPPLY)
    {
        _mint(initialRecipient, TOTAL_SUPPLY);
    }

    function _burn(address account, uint256 amount)
        public
        override(ERC20Burnable, ERC20)
    {
        super._burn(account, amount);
    }
}
