a new coin from the people at cannacoin.org
# CannaCoin Paper ($PAPER)

## Overview
CannaCoin Paper ($PAPER) is an ERC-20 token designed with a fixed supply cap, burn functionality, and decentralized ownership. The token operates on the Ethereum blockchain, leveraging OpenZeppelin's battle-tested libraries for security and efficiency.

## Contract Details
- **Token Name:** Cannacoin Paper
- **Symbol:** PAPER
- **Decimals:** 18
- **Total Supply:** 1,000,000,000,420 ($PAPER)
- **Initial Recipient:** `0x8114BeC86C8F56c1014f590E05cD7826054EcBdE`
- **Ownership Renounced:** Yes (No central control after deployment)

## Features
- **Fixed Supply:** The total supply is capped at 1,000,000,000,420 tokens, ensuring no additional minting beyond the initial allocation.
- **Burnable:** Token holders can burn their tokens, reducing the circulating supply.
- **Decentralized Ownership:** The contract transfers ownership to the zero address upon deployment, preventing any further administrative control.

## Smart Contract Implementation
The contract inherits from:
- [`ERC20`](https://docs.openzeppelin.com/contracts/4.x/api/token/erc20): Standard implementation of an ERC-20 token.
- [`ERC20Burnable`](https://docs.openzeppelin.com/contracts/4.x/api/token/erc20#ERC20Burnable): Enables token burning functionality.
- [`ERC20Capped`](https://docs.openzeppelin.com/contracts/4.x/api/token/erc20#ERC20Capped): Ensures the supply cannot exceed the predefined cap.
- [`Ownable`](https://docs.openzeppelin.com/contracts/4.x/api/access#Ownable): Initially provides ownership control but is renounced upon deployment.

## Deployment
The contract deploys with the full supply minted to the initial recipient:
```solidity
constructor()
    ERC20("Cannacoin Paper", "PAPER")
    ERC20Capped(TOTAL_SUPPLY)
{
    _mint(initialRecipient, TOTAL_SUPPLY);
    _transferOwnership(address(0));
}
```

## Usage
- **Transferring Tokens:** Standard ERC-20 transfer functions apply.
- **Burning Tokens:** Users can call `burn(amount)` to reduce their token balance and the total supply.
- **Decentralized Governance:** Since ownership is renounced, no centralized authority can modify or control the token contract.

## Security Considerations
- The contract is immutable after deployment due to ownership renouncement.
- Supply is hard-capped, preventing inflation.
- The contract utilizes OpenZeppelin's well-audited security standards.

## License
This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).


![image](https://github.com/user-attachments/assets/9526c0dc-4a82-47ef-912b-ba367cf6e30a)


