// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface ILBRToken is IERC20 {
    function burn(uint256 amount) external;
    function burnFrom(address account, uint256 amount) external;
}

contract LBRTreasury is Ownable {
    ILBRToken public LBR;
    address public stakingContract;

    uint256 public constant DAILY_BURN_LIMIT_PERCENT = 5; // 0.05% of total supply
    uint256 public burnedToday;
    uint256 public lastBurnDate;

    event TokensDeposited(address indexed from, uint256 amount);
    event TokensWithdrawn(address indexed to, uint256 amount);
    event TokensBurned(uint256 amount);
    event TokensDistributed(address indexed to, uint256 amount);

    constructor(address _lbrToken, address initialOwner) Ownable(initialOwner) {
        LBR = ILBRToken(_lbrToken);
    }

    function setStakingContract(address _stakingContract) external onlyOwner {
        require(_stakingContract != address(0), "Invalid address");
        stakingContract = _stakingContract;
    }

    modifier onlyStaking() {
        require(msg.sender == stakingContract, "Caller is not staking contract");
        _;
    }

    function deposit(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be > 0");
        require(LBR.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        emit TokensDeposited(msg.sender, amount);
    }

    function withdraw(address to, uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be > 0");
        require(LBR.transfer(to, amount), "Transfer failed");
        emit TokensWithdrawn(to, amount);
    }

    function distribute(address to, uint256 amount) external onlyStaking {
        require(amount > 0, "Amount must be > 0");
        require(LBR.transfer(to, amount), "Transfer failed");
        emit TokensDistributed(to, amount);
    }

    function burn(uint256 amount) external onlyStaking {
        uint256 today = block.timestamp / 86400; // UTC days since epoch
        if (lastBurnDate < today) {
            burnedToday = 0;
            lastBurnDate = today;
        }

        uint256 maxBurn = (LBR.totalSupply() * DAILY_BURN_LIMIT_PERCENT) / 10000;
        require(burnedToday + amount <= maxBurn, "Exceeds daily burn limit");

        LBR.burn(amount);
        burnedToday += amount;
        emit TokensBurned(amount);
    }
}