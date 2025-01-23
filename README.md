# Nex Vote

## Overview

Nex Vote is a comprehensive voting platform designed to facilitate secure and efficient voting processes. The system consists of three main components: a frontend application built with Flutter, a backend server using Node.js and Express, and a decentralized voting contract implemented in Solidity on the Ethereum blockchain.

## Features

### Frontend
- **User Authentication**: Users can log in or sign up to access the voting platform.
- **Voting History**: Users can view their voting history and track their participation in elections.
- **Election Management**: Admins can create and manage elections, including adding candidates and closing elections.
- **Real-time Vote Counting**: The application updates vote counts in real-time, ensuring transparency.
- **Responsive Design**: The app is designed to work seamlessly on various screen sizes, providing an optimal user experience on both mobile and desktop devices.
- **Blockchain Integration**: Utilizes blockchain technology to ensure secure and transparent voting processes.
- **User-Friendly Interface**: Intuitive UI that guides users through the voting process.

### Backend
- **User Authentication**: Signup and login functionality.
- **Election Creation and Management**: Admins can create and manage elections.
- **Voting Functionality**: Users can cast votes in elections.
- **Candidate Management**: Admins can manage candidates for elections.
- **RESTful API**: Provides endpoints for frontend integration.
- **Middleware for Authentication and Authorization**: Ensures secure access to resources.

### Smart Contract
- **Create Elections**: Users can create new elections with a title.
- **Add Candidates**: Election creators can add candidates to their elections.
- **Cast Votes**: Registered voters can cast their votes for candidates in open elections.
- **Close Voting**: Only the election creator can close voting for their election.
- **View Results**: Users can retrieve the results of an election and details about it.

## Getting Started

### Prerequisites

Before you begin, ensure you have met the following requirements:

- **Frontend**: 
  - Flutter SDK installed on your machine
  - Dart SDK installed
  - An IDE such as Android Studio, Visual Studio Code, or Xcode
  - For iOS development, a Mac with Xcode installed

- **Backend**: 
  - Node.js (version 14 or higher)
  - npm (Node package manager)

- **Smart Contract**: 
  - Node.js (version 14 or higher)
  - npm (Node package manager)

### Installation

#### Frontend

1. Clone the repository:
   ```bash
   git clone https://github.com/vishalchauhan088/nex_vote.git
   ```

2. Navigate to the project directory:
   ```bash
   cd nex_vote
   ```

3. Install the dependencies:
   ```bash
   flutter pub get
   ```

4. Run the application:
   - For Android:
     ```bash
     flutter run
     ```
   - For iOS:
     ```bash
     flutter run
     ```
   - For Web:
     ```bash
     flutter run -d chrome
     ```
   - For Desktop (Windows/Linux):
     ```bash
     flutter run -d windows
     ```

#### Backend

1. Clone the repository:
   ```bash
   git clone https://github.com/vishalchauhan088/nex-vote-backend.git
   ```

2. Navigate to the project directory:
   ```bash
   cd nex-vote-backend
   ```

3. Install the dependencies:
   ```bash
   npm install
   ```

4. Create a `.env` file in the root directory and add the following environment variables:
   ```plaintext
   MONGODB_USERNAME=your_mongodb_username
   MONGODB_PASSWORD=your_mongodb_password
   MONGODB_DATABASE=your_database_name
   JWT_SECRET=your_jwt_secret
   PORT=3000
   ```

5. Start the server in development mode:
   ```bash
   npm run dev
   ```

#### Smart Contract

1. Clone the repository:
   ```bash
   git clone <https://github.com/vishalchauhan088/blockchain_voting_system>
   cd voting_system
   ```

2. Install the dependencies:
   ```bash
   npm install
   ```

### Running the Smart Contract

1. To compile the smart contracts, run:
   ```bash
   npx hardhat compile
   ```

2. To run tests, use:
   ```bash
   npx hardhat test
   ```

3. To deploy the contract, execute:
   ```bash
   npx hardhat run scripts/deploy.js
   ```

4. For local development, start a Hardhat node:
   ```bash
   npx hardhat node
   ```

5. To deploy using Hardhat Ignition, run:
   ```bash
   npx hardhat ignition deploy ./ignition/modules/Lock.js
   ```

## API Endpoints

### Authentication
- **POST** `/api/v1/auth/signup` - Create a new user
- **POST** `/api/v1/auth/login` - Authenticate a user

### Elections
- **POST** `/api/v1/election` - Create a new election (requires admin)
- **GET** `/api/v1/election` - Get all elections
- **GET** `/api/v1/election/:id` - Get an election by ID
- **PUT** `/api/v1/election/:id` - Update an election (requires admin)
- **DELETE** `/api/v1/election/:id` - Delete an election (requires admin)

### Voting
- **POST** `/api/v1/useractivity/:electionId/vote` - Cast a vote in an election
- **GET** `/api/v1/useractivity/my-votes` - Get all votes cast by the user

## Contributing

Contributions are welcome! Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes and commit them (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Create a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for creating an amazing framework.
- Contributors for their valuable input and support.
- The open-source community for their support.
