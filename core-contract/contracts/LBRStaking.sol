// SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

pragma solidity ^0.8.20;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

pragma solidity ^0.8.20;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

// File: LBRTreasury.sol


pragma solidity ^0.8.20;



interface ILBRToken is IERC20 {
    function burn(uint256 amount) external;
    function burnFrom(address account, uint256 amount) external;
}

contract LBRTreasury is Ownable {
    ILBRToken public immutable LBR;
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
// File: LBRStaking.sol


pragma solidity ^0.8.20;





interface IlbrETH is IERC20 {}

contract LBRStaking is Ownable, ReentrancyGuard {
    IlbrETH public lbrETH;
    ILBRToken public LBR;
    LBRTreasury public treasury;

    uint256 public stakingRewardRate = 1736111111111111;
    uint256 public burnRewardRate = 11000;
    mapping(uint256 => uint256) public lockDurations;

    uint256 public totalStaked;
    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored;

    uint256 public constant FEE_DENOMINATOR = 10000;
    uint256 public stakeFee = 50; // 0.5%
    uint256 public unstakeFee = 100; // 1%
    uint256 public lockFee = 50; // 0.5%
    uint256 public earlyUnlockPenalty = 2000; // 20%

    struct StakeInfo {
        uint256 amount;
        uint256 rewardPerTokenStored;
        uint256 lastClaimed;
    }

    struct LockInfo {
        uint256 amount;
        uint256 unlockTime;
        uint256 apy;
        bool claimed;
    }

    mapping(address => StakeInfo) public stakes;
    mapping(address => LockInfo[]) public locks;

    event Staked(address indexed user, uint256 amount, uint256 fee);
    event Unstaked(address indexed user, uint256 amount, uint256 fee);
    event RewardClaimed(address indexed user, uint256 amount);
    event Locked(address indexed user, uint256 amount, uint256 duration, uint256 apy);
    event Unlocked(address indexed user, uint256 amount, uint256 penalty);
    event BurnedForReward(address indexed user, uint256 burned, uint256 reward);

    constructor(
        address _lbrETH,
        address _lbrToken,
        address _treasury,
        address initialOwner
    ) Ownable(initialOwner) {
        lbrETH = IlbrETH(_lbrETH);
        LBR = ILBRToken(_lbrToken);
        treasury = LBRTreasury(_treasury);

        lockDurations[30 days] = 1000; // 10% APY
        lockDurations[90 days] = 3000; // 30% APY
        lockDurations[180 days] = 6000; // 60% APY
        lockDurations[365 days] = 12000; // 120% APY
    }
	
	function setLbrETH(address _lbrETH) external onlyOwner {
        require(_lbrETH != address(0), "Invalid address");
        lbrETH = IlbrETH(_lbrETH);
    }

    function setLBRToken(address _lbrToken) external onlyOwner {
        require(_lbrToken != address(0), "Invalid address");
        LBR = ILBRToken(_lbrToken);
    }

    function setTreasury(address _treasury) external onlyOwner {
        require(_treasury != address(0), "Invalid address");
        treasury = LBRTreasury(_treasury);
    }

    function setStakingRewardRate(uint256 _stakingRewardRate) external onlyOwner {
        stakingRewardRate = _stakingRewardRate;
    }

    function setBurnRewardRate(uint256 _burnRewardRate) external onlyOwner {
        require(_burnRewardRate >= 10000, "Rate must be >= 100%");
        burnRewardRate = _burnRewardRate;
    }

    function setLockDurationAPY(uint256 duration, uint256 apyBasisPoints) external onlyOwner {
        lockDurations[duration] = apyBasisPoints;
    }

    function stake(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be > 0");
        _updateReward(msg.sender);

        uint256 fee = (amount * stakeFee) / FEE_DENOMINATOR;
        uint256 amountAfterFee = amount - fee;

        // Optimized single transfer with fee deduction
        bool success = lbrETH.transferFrom(
            msg.sender,
            address(this),
            amount
        );
        require(success, "Transfer failed");

        if (fee > 0) {
            success = lbrETH.transfer(owner(), fee);
            require(success, "Fee transfer failed");
        }

        StakeInfo storage userStake = stakes[msg.sender];
        userStake.amount += amountAfterFee;
        totalStaked += amountAfterFee;
        
        emit Staked(msg.sender, amountAfterFee, fee);
    }

    function unstake(uint256 amount) external nonReentrant {
        require(amount > 0 && stakes[msg.sender].amount >= amount, "Invalid amount");
        _updateReward(msg.sender);

        uint256 fee = (amount * unstakeFee) / FEE_DENOMINATOR;
        uint256 amountAfterFee = amount - fee;

        stakes[msg.sender].amount -= amount;
        totalStaked -= amount;

        lbrETH.transfer(msg.sender, amountAfterFee);
        lbrETH.transfer(owner(), fee);
        emit Unstaked(msg.sender, amountAfterFee, fee);
    }

    function claimReward() external nonReentrant {
        _updateReward(msg.sender);
        uint256 reward = stakes[msg.sender].rewardPerTokenStored;
        require(reward > 0, "No reward");

        stakes[msg.sender].rewardPerTokenStored = 0;
        treasury.distribute(msg.sender, reward);
        emit RewardClaimed(msg.sender, reward);
    }

    function lockReward(uint256 amount, uint256 duration) external nonReentrant {
        require(amount > 0, "Amount must be > 0");
        require(lockDurations[duration] > 0, "Invalid duration");
        _updateReward(msg.sender);

        uint256 fee = (amount * lockFee) / FEE_DENOMINATOR;
        uint256 amountAfterFee = amount - fee;

        // Optimized single transfer with fee deduction
        bool success = LBR.transferFrom(
            msg.sender,
            address(this),
            amount
        );
        require(success, "Transfer failed");

        if (fee > 0) {
            success = LBR.transfer(owner(), fee);
            require(success, "Fee transfer failed");
        }

        locks[msg.sender].push(LockInfo({
            amount: amountAfterFee,
            unlockTime: block.timestamp + duration,
            apy: lockDurations[duration],
            claimed: false
        }));
        
        emit Locked(msg.sender, amountAfterFee, duration, lockDurations[duration]);
    }

    function unlock(uint256 lockId) external nonReentrant {
        LockInfo storage lock = locks[msg.sender][lockId];
        require(!lock.claimed, "Already claimed");

        uint256 penalty = 0;
        uint256 amount = lock.amount;

        if (block.timestamp < lock.unlockTime) {
            penalty = (amount * earlyUnlockPenalty) / FEE_DENOMINATOR;
            treasury.distribute(owner(), penalty);
            amount -= penalty;
        } else {
            uint256 durationInYears = (lock.unlockTime - (block.timestamp - lock.unlockTime)) / 365 days;
            uint256 bonus = (amount * lock.apy * durationInYears) / FEE_DENOMINATOR;
            amount += bonus;
        }

        lock.claimed = true;
        treasury.distribute(msg.sender, amount);
        emit Unlocked(msg.sender, amount, penalty);
    }

    function burnForReward(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be > 0");
        require(LBR.balanceOf(msg.sender) >= amount, "Insufficient balance");

        LBR.burnFrom(msg.sender, amount);
        treasury.burn(amount);

        uint256 reward = (amount * burnRewardRate) / FEE_DENOMINATOR;
        treasury.distribute(msg.sender, reward);
        emit BurnedForReward(msg.sender, amount, reward);
    }

    function _updateReward(address account) internal {
        if (totalStaked > 0) {
            uint256 timeElapsed = block.timestamp - lastUpdateTime;
            rewardPerTokenStored += (timeElapsed * stakingRewardRate * 1e18) / totalStaked;
        }
        lastUpdateTime = block.timestamp;

        if (account != address(0)) {
            stakes[account].rewardPerTokenStored = earned(account);
            stakes[account].lastClaimed = block.timestamp;
        }
    }

    function earned(address account) public view returns (uint256) {
        return (stakes[account].amount * (rewardPerToken() - stakes[account].rewardPerTokenStored)) / 1e18;
    }
    
    function getUserLocks(address user) external view returns (LockInfo[] memory) {
        return locks[user];
    }

    function rewardPerToken() public view returns (uint256) {
        if (totalStaked == 0) return rewardPerTokenStored;
        return rewardPerTokenStored + ((block.timestamp - lastUpdateTime) * stakingRewardRate * 1e18) / totalStaked;
    }

    function getTreasuryLBRBalance() external view returns (uint256) {
        return LBR.balanceOf(address(treasury));
    }
}
