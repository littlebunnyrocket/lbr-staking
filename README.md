
# 🚀 LBR Staking Protocol (Testnet)

Welcome to the **LBR Staking Protocol**, a testnet-only playground to explore reward distribution, staking, and reward-enhancing features. This is your lab to experiment with locking, burning, and earning — without the risk of real funds!

🔗 **Try it Live**: [LBR Staking Dashboard](https://testnet.littlebunnyrocket.com)

---

## 🧠 What is LBR Staking?

LBR Staking simulates a DeFi reward system using:
- **`lbrETH`**: Wrapped ETH token for staking.
- **`LBRToken`**: ERC-20 token earned as staking rewards.

It also includes mechanisms like:
- 🔥 **Burning** rewards for bonuses  
- 🔒 **Locking** tokens for higher APY

<details>
  <summary><strong>📜 Smart Contracts</strong> (click to expand)</summary>

### 🪙 `LBRToken`
- ERC-20 reward token
- 🔥 Burn to get bonus LBR (daily capped)
- 🔒 Lock for higher APY
- 🔍 [View on Explorer](https://explorer.testnet.riselabs.xyz/address/0x7E82da3Bd232eb1EAcFd6427060fb427461d0132)

---

### 💧 `lbrETH`
- Wrapped native ETH (1:1)
- Main staking token
- 🔍 [View on Explorer](https://explorer.testnet.riselabs.xyz/address/0x562E6B7884Cb0b9876D1D51BF1Be990Cf43FF55B)

---

### 🏦 `LBRTreasury`
- Holds LBR reward reserves
- 🧾 Handles deposits and transfers to staking
- 🔍 [View on Explorer](https://explorer.testnet.riselabs.xyz/address/0xD3147D0edB453d8777FdE63CBB408D9477e1Eb85)

---

### ⚙️ `LBRStaking`
- Core logic for staking and rewards
- 📥 Stake/Unstake Anytime  
  - Fee: Stake `0.5%` | Unstake `1%`
- 🎁 Claim rewards anytime
- 🔥 Burn rewards for bonus (capped daily)
- 🔒 Lock rewards for APY  
  - Lock Fee: `0.5%`  
  - Early Unlock Penalty: `20%`  
  - Durations & APY:
    - 30 days → 10% APY  
    - 90 days → 30% APY  
    - 180 days → 60% APY
- 🔍 [View on Explorer](https://explorer.testnet.riselabs.xyz/address/0xA2C2498D490C77a2707F663a6cfd87825204b617)

</details>

---

## 🔐 Security Notes

- Built with **OpenZeppelin** standards: `SafeERC20`, `Ownable`, `ReentrancyGuard`
- Reward logic fully isolated in the treasury
- Transparent, minimal contract roles
- Emissions capped by treasury limits

---

## ⚠️ Disclaimer

> **This project is for educational/testing purposes only.**  
All contracts are on testnet and hold no real-world value. Please **do not send real ETH or tokens** to any of the addresses!

---

Made with ❤️ for builders and testers.
