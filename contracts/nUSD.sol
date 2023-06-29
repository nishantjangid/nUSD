// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract nUSD is ERC20, ERC20Burnable, Ownable {
    AggregatorV3Interface public ethPriceFeed;
    event Deposit(address indexed from, uint256 ethAmount, uint256 nusdAmount);
    event Redeem(address indexed from, uint256 nusdAmount, uint256 ethAmount);
    mapping (address=>uint256) public userEthBalance;
    
    constructor() ERC20("nUSD Stablecoin", "nUSD") {        
        ethPriceFeed = AggregatorV3Interface(0x2514895c72f50D8bd4B4F9b1110F0D6bD2c97526);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function deposit() external payable {
        require(msg.value > 0,"Amount must be greater then zero");
        uint256 ethAmount = msg.value * getETHPrice();        
        uint256 nusdAmount = ethAmount / 2;
        userEthBalance[msg.sender] += msg.value;
        _mint(msg.sender,nusdAmount);        
        emit Deposit(msg.sender, ethAmount, nusdAmount);
    }
    
    function redeem(uint256 nusdAmount) external {
        require(balanceOf(msg.sender) >= nusdAmount, "Insufficient nUSD balance");
        uint256 currentPrice = getETHPrice();
        uint256 userEthAmount = userEthBalance[msg.sender];
        uint256 nUSDPay = (currentPrice * userEthAmount) * 2;
        require(nusdAmount == nUSDPay,"Amount must be double of your deposited eth price");
        
        burnFrom(msg.sender,nUSDPay);
        
        (bool success, ) = msg.sender.call{value: userEthAmount}("");
        require(success, "ETH transfer failed");
        
        emit Redeem(msg.sender, nUSDPay, userEthAmount);
    }

    function getETHPrice() public view returns (uint256) {
        (, int256 price, , , ) = ethPriceFeed.latestRoundData();
        return uint256(price) / 1e8;
    }
}

