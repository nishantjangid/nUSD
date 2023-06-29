

const hre = require("hardhat");

async function main() {    
  // const [deployer] = await ethers.getSigners();
  const nUSD = await ethers.getContractFactory("nUSD");
  const contract = await nUSD.deploy();

  console.log(
    `nUSD with deployed to ${contract.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
