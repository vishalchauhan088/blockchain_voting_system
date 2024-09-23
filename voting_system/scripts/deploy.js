// Import necessary libraries
const hre = require("hardhat");

async function main() {
  // Get the ContractFactory and Signers here
  const VotingSystem = await hre.ethers.getContractFactory("VotingSystem");
  const votingSystem = await VotingSystem.deploy();

  // Wait for the contract to be deployed
  await votingSystem.deployed();

  console.log("VotingSystem deployed to:", votingSystem.address);
}

// Handle errors
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
