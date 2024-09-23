const { expect } = require("chai");

describe("VotingSystem contract", function () {
  let VotingSystem;
  let votingSystem;
  let owner, admin1, admin2, voter1, voter2, candidate1;

  beforeEach(async function () {
    [owner, admin1, admin2, voter1, voter2, candidate1] =
      await ethers.getSigners();
    votingSystem = await ethers.deployContract();
  });
});
