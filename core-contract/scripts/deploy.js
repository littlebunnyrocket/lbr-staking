const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying with:", deployer.address);

  // 1. Deploy lbrETH
  const lbrETH = await ethers.deployContract("lbrETH");
  await lbrETH.waitForDeployment();
  console.log("lbrETH deployed at:", lbrETH.target);

  // 2. Deploy LBRToken
  const LBRToken = await ethers.deployContract("LBRToken");
  await LBRToken.waitForDeployment();
  console.log("LBRToken deployed at:", LBRToken.target);

  // 3. Deploy LBRTreasury
  const LBRTreasury = await ethers.deployContract("contracts/LBRTreasury.sol:LBRTreasury", [
    LBRToken.target,
    deployer.address
  ]);
  await LBRTreasury.waitForDeployment();
  console.log("LBRTreasury deployed at:", LBRTreasury.target);

  // 4. Deploy LBRStaking
  const LBRStaking = await ethers.deployContract("contracts/LBRStaking.sol:LBRStaking", [
    lbrETH.target,
    LBRToken.target,
    LBRTreasury.target,
    deployer.address
  ]);
  await LBRStaking.waitForDeployment();
  console.log("LBRStaking deployed at:", LBRStaking.target);
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
