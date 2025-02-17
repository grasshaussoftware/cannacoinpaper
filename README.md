<<<<<<< HEAD
# CannaCoin Paper Smart Contract

CannaCoin Paper (PAPER) is an affordable ERC20 token built on Avalanche, featuring a gentle bonding curve mechanism and automated liquidity provision through Uniswap V2. With an extremely low initial price point of 0.00001 AVAX, it's designed for broad accessibility while maintaining price stability through advanced tokenomics.

## Core Features

- 💰 **Ultra-Low Entry Price**: Starting at just 0.00001 AVAX
- 📈 **Gentle Bonding Curve**: Gradual price appreciation with supply
- 💧 **Auto-Liquidity**: Instant liquidity provision via Uniswap V2
- 🏦 **Mining Reserve**: 10% of supply locked for 2 years
- 🛡️ **Comprehensive Security**: Multiple protection layers
- ⚡ **AVAX Native**: Built for the Avalanche ecosystem

## Technical Specifications

- **Token Name**: Cannacoin Paper
- **Symbol**: PAPER
- **Decimals**: 18
- **Total Supply**: 1,000,000,000,420 PAPER
- **Initial Price**: 0.00001 AVAX
- **Price Curve Constant (K)**: 1e9
- **Mining Reserve**: 100,000,000,042 PAPER (10%)
- **Max Transaction**: 4% of total supply

## Price Mechanism

The token implements a bonding curve with the following characteristics:

```
Price = InitialPrice + (K * CurrentSupply / 1e18)
```

Example price points:
- Launch: 0.00001 AVAX
- 10% Supply: ~0.00002 AVAX
- 25% Supply: ~0.00003 AVAX
- 50% Supply: ~0.00005 AVAX

## Security Features

### Price Protection
- 4% max purchase per transaction
- 30% max price change per update
- 30-minute price update interval
- Slippage protection on purchases

### Liquidity Protection
- 5% maximum slippage on liquidity addition
- 15-minute transaction deadline
- Protected liquidity pool creation

### Access Control
- Contract pausable by owner
- Blacklist functionality
- Reentrancy protection
- Secure mining reserve management

## Smart Contract Implementation

```solidity
contract CannaCoinPaper is ERC20, ERC20Burnable, ERC20Capped, Ownable, 
    ReentrancyGuard, Pausable, ERC20Permit {
    // Implementation details in contract file
}
```

### Key Functions

#### Token Purchase
```solidity
function purchaseTokens(uint256 minTokensExpected) public payable
```
Buy tokens with AVAX, specifying minimum tokens expected for slippage protection.

#### Price Checking
```solidity
function getCurrentPrice() public view returns (uint256)
```
Get current token price based on supply and bonding curve.

#### Mining Reserve
```solidity
function getMiningReserveStatus() public view returns (bool)
function releaseMiningReserve() public
```
Check and manage the locked mining reserve.

## Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/cannacoin-paper.git
```

2. Install dependencies
```bash
npm install
```

3. Create environment file
```bash
cp .env.example .env
# Edit .env with your configuration
```

## Deployment

Deploy to Avalanche network:
```bash
npx hardhat run scripts/deploy.js --network avalanche
```

Required constructor parameters:
```javascript
const UNISWAP_ROUTER = "0x..."; // Uniswap V2 Router
const WAVAX = "0x...";          // Wrapped AVAX
const MINING_RESERVE = "0x...";  // Mining Reserve Address
```

## Testing

Run the test suite:
```bash
npx hardhat test
```

Generate coverage report:
```bash
npx hardhat coverage
```

## Contract Interaction

### For Users

1. Purchase tokens:
```javascript
const minTokensExpected = ethers.utils.parseEther("1000");
await contract.purchaseTokens(minTokensExpected, {
    value: ethers.utils.parseEther("0.0001")
});
```

2. Check current price:
```javascript
const price = await contract.getCurrentPrice();
```

### For Administrators

1. Emergency pause:
```javascript
await contract.pause();
await contract.unpause();
```

2. Manage blacklist:
```javascript
await contract.setBlacklist(address, true/false);
```

## Events

```solidity
event TokensPurchased(address indexed buyer, uint256 amount, uint256 tokensReceived, uint256 pricePerToken)
event AVAXWithdrawn(address indexed to, uint256 amount)
event InitialPriceSet(uint256 newPrice)
event PairAddressSet(address newPairAddress)
event MiningReserveReleased(uint256 amount)
event MiningReserveAddressSet(address newAddress)
event AddressBlacklisted(address indexed account, bool status)
event SlippageExceeded(uint256 expected, uint256 actual)
```

## Development Status

- [x] Smart Contract Implementation
- [x] Security Features
- [x] Price Mechanism
- [ ] Audit Completion
- [ ] Mainnet Deployment
- [ ] Liquidity Pool Creation

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Security

This contract includes multiple security features but should undergo a professional audit before mainnet deployment.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This smart contract is provided as-is. Users should perform their own security assessment before use.

## Contact

Project Link: [https://github.com/yourusername/cannacoin-paper](https://github.com/yourusername/cannacoin-paper)
=======
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


>>>>>>> b8dc15d0eff2048887100f222976e614ac0afa05
