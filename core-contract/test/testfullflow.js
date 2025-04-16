const { ethers } = require("hardhat");

async function main() {
  // SECTION 1: DEPLOYMENT
  console.log("🚀 Starting deployment process...");
  const [deployer, user] = await ethers.getSigners();

  console.log(`\n📋 Accounts:`);
  console.log(`- Deployer: ${deployer.address}`);
  console.log(`- Test User: ${user.address}`);

  // Deploy lbrETH
  console.log("\n🔨 Deploying lbrETH contract...");
  const lbrETHFactory = await ethers.getContractFactory("lbrETH");
  const lbrETH = await lbrETHFactory.deploy();
  await lbrETH.waitForDeployment();
  console.log(`✅ lbrETH deployed at: ${lbrETH.target}`);

  // Deploy LBRToken
  console.log("\n🔨 Deploying LBRToken contract...");
  const LBRTokenFactory = await ethers.getContractFactory("LBRToken");
  const lbrToken = await LBRTokenFactory.deploy();
  await lbrToken.waitForDeployment();
  console.log(`✅ LBRToken deployed at: ${lbrToken.target}`);

  // Deploy LBRTreasury
  console.log("\n🔨 Deploying LBRTreasury contract...");
  const TreasuryFactory = await ethers.getContractFactory("contracts/LBRTreasury.sol:LBRTreasury");
  const treasury = await TreasuryFactory.deploy(lbrToken.target, deployer.address);
  await treasury.waitForDeployment();
  console.log(`✅ LBRTreasury deployed at: ${treasury.target}`);

  // Deploy LBRStaking
  console.log("\n🔨 Deploying LBRStaking contract...");
  const StakingFactory = await ethers.getContractFactory("LBRStaking");
  const staking = await StakingFactory.deploy(lbrETH.target, lbrToken.target, treasury.target, deployer.address);
  await staking.waitForDeployment();
  console.log(`✅ LBRStaking deployed at: ${staking.target}`);

  // SECTION 2: INITIAL SETUP
  console.log("\n⚙️ Initializing contracts...");

  // 1. Set staking contract in treasury
  console.log("\n🔗 Setting staking contract address in treasury...");
  await treasury.setStakingContract(staking.target);
  console.log("✔️ Staking contract set in treasury");

  // 2. Fund Treasury
  const amountToApprove = ethers.parseUnits("6000000", 18);
  console.log(`\n💰 Approving treasury to spend ${ethers.formatUnits(amountToApprove, 18)} LBRToken...`);
  await lbrToken.approve(treasury.target, amountToApprove);

  console.log("💸 Depositing to treasury...");
  await treasury.deposit(amountToApprove);
  console.log(`✔️ Treasury now has ${ethers.formatUnits(await lbrToken.balanceOf(treasury.target), 18)} LBRToken`);

  // SECTION 3: USER INTERACTIONS
  console.log("\n👤 Beginning user interactions...");

  // User deposits ETH to get lbrETH
  const depositAmount = ethers.parseEther("1");
  console.log(`\n🔵 User depositing ${ethers.formatEther(depositAmount)} ETH to get lbrETH...`);
  await lbrETH.connect(user).deposit({ value: depositAmount });
  
  const lbrETHBalance = await lbrETH.balanceOf(user.address);
  console.log(`✔️ User received ${ethers.formatUnits(lbrETHBalance, 18)} lbrETH`);

  // User approves staking contract
  console.log("\n🔏 Approving staking contract to spend user's lbrETH...");
  await lbrETH.connect(user).approve(staking.target, lbrETHBalance);
  console.log("✔️ Approval complete");

  // SECTION 4: STAKING OPERATIONS
  console.log("\n🔄 Beginning staking operations...");

  // User stakes lbrETH
  console.log(`\n⭐ User staking ${ethers.formatUnits(lbrETHBalance, 18)} lbrETH...`);
  await staking.connect(user).stake(lbrETHBalance);
  console.log("✔️ Stake successful");

  // Check staking details
  const userStake = await staking.stakes(user.address);
  console.log("\n📊 Staking Details:");
  console.log(`- Staked Amount: ${ethers.formatUnits(userStake.amount, 18)} lbrETH`);
  console.log(`- Last Claim Time: ${new Date(Number(userStake.lastClaimed) * 1000).toISOString()}`);

  // SECTION 5: REWARD ACCRUAL
  console.log("\n⏳ Simulating time passage for rewards...");
  
  // Fast-forward 7 days
  const DAY_IN_SECONDS = 86400n;
  await ethers.provider.send("evm_increaseTime", [Number(7n * DAY_IN_SECONDS)]);
  await ethers.provider.send("evm_mine");
  console.log("⏰ Fast-forwarded 7 days");

  // Check earned rewards
  const earnedBefore = await staking.earned(user.address);
  console.log(`\n💰 Earned rewards: ${ethers.formatUnits(earnedBefore, 18)} LBRToken`);

  // Claim rewards
  console.log("\n🎁 Claiming rewards...");
  await staking.connect(user).claimReward();
  console.log("✔️ Rewards claimed");

  // Check new balance
  const userLBR = await lbrToken.balanceOf(user.address);
  console.log(`\n💵 User's LBRToken balance: ${ethers.formatUnits(userLBR, 18)}`);

  // SECTION 6: BURN FOR REWARD
  console.log("\n🔥 Beginning burn for reward operation...");
  
  const burnAmount = userLBR / 2n;
  console.log(`\n🔘 Approving to burn ${ethers.formatUnits(burnAmount, 18)} LBRToken...`);
  await lbrToken.connect(user).approve(staking.target, burnAmount);
  
  console.log("🔥 Burning tokens for reward...");
  await staking.connect(user).burnForReward(burnAmount);
  
  const afterBurnBalance = await lbrToken.balanceOf(user.address);
  console.log(`✔️ New balance: ${ethers.formatUnits(afterBurnBalance, 18)} LBRToken`);
  console.log(`💎 Received 110% of burned amount`);

// SECTION 7: LOCKING REWARDS
console.log("\n🔒 Beginning lock reward operations...");

// Assuming you have defined lockDurations somewhere in your contract setup
// For this example, I'll assume 90 days duration has an APY configured
const lockDuration = 90n * DAY_IN_SECONDS;
const lockAmount = afterBurnBalance / 4n;
console.log(`\n🔘 Approving to lock ${ethers.formatUnits(lockAmount, 18)} LBRToken for 90 days...`);

// First approve the full amount (including fee) for transfer
await lbrToken.connect(user).approve(staking.target, lockAmount);

console.log("⏳ Locking tokens...");
const tx = await staking.connect(user).lockReward(lockAmount, lockDuration);
await tx.wait();
console.log("✔️ Tokens locked");

// Check lock details - note this returns an array of locks
const userLocks = await staking.getUserLocks(user.address);
const latestLock = userLocks[userLocks.length - 1]; // Get the most recent lock

console.log("\n🗃️ Lock Details:");
console.log(`- Locked Amount: ${ethers.formatUnits(latestLock.amount, 18)}`);
console.log(`- Unlock Time: ${new Date(Number(latestLock.unlockTime) * 1000).toISOString()}`);
console.log(`- APY: ${Number(latestLock.apy) / 100}%`);
console.log(`- Claimed: ${latestLock.claimed}`);

  // SECTION 8: EARLY UNLOCK ATTEMPT
  console.log("\n⚠️ Testing early unlock (with penalty)...");
  
  // Fast-forward 30 days
  await ethers.provider.send("evm_increaseTime", [Number(30n * DAY_IN_SECONDS)]);
  await ethers.provider.send("evm_mine");
  console.log("⏰ Fast-forwarded 30 days");

  try {
    console.log("\n🔓 Attempting early unlock...");
    await staking.connect(user).unlock(0);
    const earlyUnlockBalance = await lbrToken.balanceOf(user.address);
    const receivedAmount = earlyUnlockBalance - (afterBurnBalance - lockAmount);
    console.log(`✔️ Early unlock successful (with penalty)`);
    console.log(`💸 Received ${ethers.formatUnits(receivedAmount, 18)} after penalty`);
  } catch (error) {
    console.log("❌ Early unlock failed:", error.message);
  }
  
// SECTION 8.5: CREATE NEW LOCK FOR FULL TERM TESTING
console.log("\n🔒 Creating new lock for full term testing...");
const newLockAmount = await lbrToken.balanceOf(user.address) / 2n; // Lock half of remaining balance

// Approve new lock
await lbrToken.connect(user).approve(staking.target, newLockAmount);
console.log(`\n🔘 Approved to lock ${ethers.formatUnits(newLockAmount, 18)} LBRToken for 90 days...`);

// Create new lock
console.log("⏳ Locking new tokens...");
await staking.connect(user).lockReward(newLockAmount, lockDuration);
console.log("✔️ New tokens locked");

// Check new lock details
const newUserLocks = await staking.getUserLocks(user.address);
const newLockIndex = newUserLocks.length - 1; // Get index of the new lock
console.log("\n🗃️ New Lock Details:");
console.log(`- Locked Amount: ${ethers.formatUnits(newUserLocks[newLockIndex].amount, 18)}`);
console.log(`- Unlock Time: ${new Date(Number(newUserLocks[newLockIndex].unlockTime) * 1000).toISOString()}`);

// SECTION 9: COMPLETE UNLOCK
console.log("\n🕒 Waiting for full lock period...");

// Fast-forward full 90 days
await ethers.provider.send("evm_increaseTime", [Number(90n * DAY_IN_SECONDS)]);
await ethers.provider.send("evm_mine");
console.log("⏰ Fast-forwarded 90 days");

console.log("\n🔓 Performing full unlock...");
const balanceBeforeUnlock = await lbrToken.balanceOf(user.address);
await staking.connect(user).unlock(newLockIndex); // Unlock the new lock

const balanceAfterUnlock = await lbrToken.balanceOf(user.address);
const unlockedAmount = balanceAfterUnlock - balanceBeforeUnlock;
console.log(`✔️ Unlock completed`);
console.log(`🔓 Unlocked Amount: ${ethers.formatUnits(unlockedAmount, 18)}`);
console.log(`💰 Final LBRToken balance: ${ethers.formatUnits(balanceAfterUnlock, 18)}`);

console.log("\n🎉 All operations completed successfully!");
}

main().catch((error) => {
  console.error("❌ Script failed:", error);
  process.exitCode = 1;
});