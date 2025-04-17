import { ethers } from "hardhat";

async function main() {
  const dTaskListFactory = await ethers.getContractFactory("DTaskList");
  const dTaskList = await dTaskListFactory.deploy();

  await dTaskList.waitForDeployment();

  console.log("DTaskList deployed to:", await dTaskList.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
