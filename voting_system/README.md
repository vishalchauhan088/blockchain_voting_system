# Next Vote Contract

This project implements a decentralized voting system using Solidity and Hardhat. The contract allows users to create elections, add candidates, and cast votes securely on the Ethereum blockchain.

## Features

- **Create Elections**: Users can create new elections with a title.
- **Add Candidates**: Election creators can add candidates to their elections.
- **Cast Votes**: Registered voters can cast their votes for candidates in open elections.
- **Close Voting**: Only the election creator can close voting for their election.
- **View Results**: Users can retrieve the results of an election and details about it.

## Getting Started

### Prerequisites

- Node.js (version 14 or higher)
- npm (Node package manager)

### Installation

1. Clone the repository:

   ```shell
   git clone <repository-url>
   cd voting_system
   ```

2. Install the dependencies:

   ```shell
   npm install
   ```

### Running the Project

1. To compile the smart contracts, run:

   ```shell
   npx hardhat compile
   ```

2. To run tests, use:

   ```shell
   npx hardhat test
   ```

3. To deploy the contract, execute:

   ```shell
   npx hardhat run scripts/deploy.js
   ```

4. For local development, start a Hardhat node:

   ```shell
   npx hardhat node
   ```

5. To deploy using Hardhat Ignition, run:

   ```shell
   npx hardhat ignition deploy ./ignition/modules/Lock.js
   ```

## Usage

After deploying the contract, you can interact with it using the Hardhat console or through a frontend application. The contract provides functions to create elections, add candidates, cast votes, and retrieve election results.

## License

This project is licensed under the ISC License.