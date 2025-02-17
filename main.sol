// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

interface IWAVAX {
    function deposit() payable external;
    function withdraw(uint256) external;
}

contract CannaCoinPaper is ERC20, ERC20Burnable, ERC20Capped, Ownable, ReentrancyGuard, Pausable, ERC20Permit {
    uint256 public constant TOTAL_SUPPLY = 1_000_000_000_420 * 10 ** 18;
    uint256 public constant MINING_RESERVE = TOTAL_SUPPLY * 10 / 100; // 10%
    uint256 public constant AVAILABLE_SUPPLY = TOTAL_SUPPLY - MINING_RESERVE;
    
    address public miningReserveAddress;
    uint256 public unlockTimestamp;
    
    // Price parameters
    uint256 public initialPrice = 0.00001 * 10 ** 18; // Initial price: 0.00001 AVAX
    uint256 public constant K = 1e9; // Constant for price curve
    uint256 public constant MAX_PURCHASE_AMOUNT = TOTAL_SUPPLY / 25; // 4% of total supply per transaction
    
    IUniswapV2Router02 public uniswapV2Router;
    address public pairAddress;
    IWAVAX public WAVAX;
    
    // Circuit breaker
    uint256 public lastPriceUpdate;
    uint256 public constant MAX_PRICE_CHANGE_PERCENTAGE = 30; // 30% max price change
    uint256 public constant PRICE_UPDATE_INTERVAL = 30 minutes;
    
    mapping(address => bool) public blacklisted;
    
    event TokensPurchased(address indexed buyer, uint256 amount, uint256 tokensReceived, uint256 pricePerToken);
    event AVAXWithdrawn(address indexed to, uint256 amount);
    event InitialPriceSet(uint256 newPrice);
    event PairAddressSet(address newPairAddress);
    event MiningReserveReleased(uint256 amount);
    event MiningReserveAddressSet(address newAddress);
    event AddressBlacklisted(address indexed account, bool status);
    event SlippageExceeded(uint256 expected, uint256 actual);
    
    constructor(
        address _uniswapV2Router,
        address _WAVAX,
        address _initialMiningReserveAddress
    )
        ERC20("Cannacoin Paper", "PAPER")
        ERC20Capped(TOTAL_SUPPLY)
        ERC20Permit("Cannacoin Paper")
    {
        require(_initialMiningReserveAddress != address(0), "Invalid mining reserve address");
        miningReserveAddress = _initialMiningReserveAddress;
        _mint(miningReserveAddress, MINING_RESERVE);
        
        unlockTimestamp = block.timestamp + 2 * 365 days; // 2 years from deployment
        uniswapV2Router = IUniswapV2Router02(_uniswapV2Router);
        WAVAX = IWAVAX(_WAVAX);
        lastPriceUpdate = block.timestamp;
    }
    
    modifier notBlacklisted() {
        require(!blacklisted[msg.sender], "Address is blacklisted");
        _;
    }
    
    modifier validPriceChange(uint256 newPrice) {
        if (block.timestamp >= lastPriceUpdate + PRICE_UPDATE_INTERVAL) {
            uint256 currentPrice = getCurrentPrice();
            uint256 maxChange = (currentPrice * MAX_PRICE_CHANGE_PERCENTAGE) / 100;
            require(
                newPrice >= currentPrice - maxChange && 
                newPrice <= currentPrice + maxChange,
                "Price change exceeds allowed percentage"
            );
            lastPriceUpdate = block.timestamp;
        }
        _;
    }
    
    function getCurrentPrice() public view returns (uint256) {
        uint256 adjustedSupply = totalSupply();
        if (adjustedSupply == 0) return initialPrice;
        return initialPrice + (K * adjustedSupply / 1e18);
    }
    
    function purchaseTokens(uint256 minTokensExpected) public payable nonReentrant whenNotPaused notBlacklisted {
        require(msg.value > 0, "AVAX amount must be greater than zero");
        
        uint256 currentPrice = getCurrentPrice();
        uint256 tokensToPurchase = (msg.value * 1e18) / currentPrice;
        
        require(tokensToPurchase > 0, "Not enough AVAX for even 1 token");
        require(tokensToPurchase <= MAX_PURCHASE_AMOUNT, "Purchase exceeds maximum allowed");
        require(totalSupply() + tokensToPurchase <= TOTAL_SUPPLY, "Purchase would exceed total supply");
        require(tokensToPurchase >= minTokensExpected, "Slippage too high");
        
        // Calculate liquidity amounts
        uint256 avaxToAdd = msg.value;
        uint256 tokensToAdd = tokensToPurchase;
        
        // Approve exact amount for router
        _approve(address(this), address(uniswapV2Router), tokensToAdd);
        
        // Handle WAVAX conversion
        WAVAX.deposit{value: avaxToAdd}();
        
        // Add liquidity with minimum amounts
        uint256 minTokenLiquidity = (tokensToAdd * 95) / 100; // 5% max slippage
        uint256 minAVAXLiquidity = (avaxToAdd * 95) / 100; // 5% max slippage
        
        try uniswapV2Router.addLiquidityAVAX{value: avaxToAdd}(
            address(this),
            tokensToAdd,
            minTokenLiquidity,
            minAVAXLiquidity,
            address(this),
            block.timestamp + 15 minutes
        ) {
            // Mint tokens only after successful liquidity addition
            _mint(msg.sender, tokensToPurchase);
            emit TokensPurchased(msg.sender, msg.value, tokensToPurchase, currentPrice);
        } catch {
            emit SlippageExceeded(tokensToPurchase, 0);
            revert("Liquidity addition failed");
        }
    }
    
    function setMiningReserveAddress(address _newAddress) public onlyOwner {
        require(_newAddress != address(0), "Invalid address");
        require(getMiningReserveStatus(), "Mining reserve already unlocked");
        miningReserveAddress = _newAddress;
        emit MiningReserveAddressSet(_newAddress);
    }
    
    function withdrawAVAX(uint256 amount) public onlyOwner {
        require(address(this).balance >= amount, "Not enough AVAX to withdraw");
        payable(msg.sender).transfer(amount);
        emit AVAXWithdrawn(msg.sender, amount);
    }
    
    function getMiningReserveStatus() public view returns (bool locked) {
        return block.timestamp < unlockTimestamp;
    }
    
    function releaseMiningReserve() public {
        require(block.timestamp >= unlockTimestamp, "Mining reserve is still locked");
        uint256 amount = balanceOf(miningReserveAddress);
        _transfer(miningReserveAddress, msg.sender, amount);
        emit MiningReserveReleased(amount);
    }
    
    function setPairAddress(address _pairAddress) public onlyOwner {
        require(_pairAddress != address(0), "Invalid pair address");
        pairAddress = _pairAddress;
        emit PairAddressSet(_pairAddress);
    }
    
    function setInitialPrice(uint256 _initialPrice) public onlyOwner validPriceChange(_initialPrice) {
        initialPrice = _initialPrice;
        emit InitialPriceSet(_initialPrice);
    }
    
    function setBlacklist(address _account, bool _status) public onlyOwner {
        blacklisted[_account] = _status;
        emit AddressBlacklisted(_account, _status);
    }
    
    function pause() public onlyOwner {
        _pause();
    }
    
    function unpause() public onlyOwner {
        _unpause();
    }
    
    function _mint(address account, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
        ERC20Capped._mint(account, amount);
    }
    
    receive() external payable {}
}
