# 🔪 LBR Staking Protocol - Full Test Flow Guide

This guide walks you through running `testfullflow.js`, a comprehensive test for the LBR staking protocol on a local Hardhat network.

---

## 📦 Requirements

Before you begin, make sure the following are installed:

- [Node.js](https://nodejs.org/) (v16+ recommended)
- [Git](https://git-scm.com/)
- [Hardhat](https://hardhat.org/)

Install Hardhat globally (if you haven't already):
```bash
npm install -g hardhat
```

Also install Hardhat Toolbox (required):
```bash
npm install --save-dev hardhat-toolbox
```

In your `hardhat.config.js`, make sure to include:
```js
require("@nomicfoundation/hardhat-toolbox");
```

---

## ✨ Step-by-Step Setup

### 1. Clone the Repository
```bash
git clone <your-repo-url>
cd lbr-staking/core-contracts
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Compile Contracts
```bash
npx hardhat compile
```

### 4. Run Full Flow Test
Run the test script directly (no need to start a separate Hardhat node):
```bash
npx hardhat test scripts/testfullflow.js
```

---

## 🔍 What Does `testfullflow.js` Do?

This script simulates the full flow of the LBR staking protocol:

### 🏗️ Deployment:
- Deploys `lbrETH`, `LBRToken`, `LBRTreasury`, and `LBRStaking`

### ⚙️ Initialization:
- Sets staking contract address in treasury
- Approves and deposits 6M LBRToken to treasury

### 👤 User Interaction:
- User wraps ETH into lbrETH
- Approves and stakes lbrETH

### 🏱 Reward Flow:
- Simulates 7 days for rewards to accrue
- User claims LBR rewards

### 🔥 Burn for Reward:
- User burns half of LBRToken to get a bonus

### 🔒 Lock for APY:
- Locks 25% of balance for 90 days
- Checks lock status

### 🥰 Early Unlock:
- Simulates 30 days and attempts early unlock (with 20% penalty)

### 🔒 Full Lock Cycle:
- Locks again for 90 days
- Simulates full period and unlocks successfully

---

## ✅ Summary
This test ensures:
- Deployment works
- User flows (stake, claim, burn, lock, unlock) function as expected

---

## 📌 Notes
- This is a **local test** using Hardhat's in-memory blockchain
- Modify the script for custom testing or live network deployment

---

Happy testing! 🔪

