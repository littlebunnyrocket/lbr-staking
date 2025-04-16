async function main() {
  const [owner] = await ethers.getSigners();
  
  // Deploy Tokens
  const LBR = await ethers.getContractFactory("LBRToken");
  const lbrETH = await ethers.getContractFactory("LbrETH");
  const lbr = await LBR.deploy();
  const eth = await lbrETH.deploy();

  // Deploy Treasury
  const Treasury = await ethers.getContractFactory("LBRTreasury");
  const treasury = await Treasury.deploy(lbr.address);

  // Deploy Staking
  const Staking = await ethers.getContractFactory("LBRStaking");
  const staking = await Staking.deploy(eth.address, lbr.address, treasury.address);

  console.log("LBR deployed to:", lbr.address);
  console.log("lbrETH deployed to:", eth.address);
  console.log("Treasury deployed to:", treasury.address);
  console.log("Staking deployed to:", staking.address);
}
main().catch(console.error);