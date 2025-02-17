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
