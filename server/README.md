# Nex Vote Backend

## Overview

Nex Vote is a voting platform that allows users to create and participate in elections securely. This repository contains the backend code for the Nex Vote software, built using Node.js, Express, and MongoDB.

## Features

- User authentication (signup and login)
- Election creation and management
- Voting functionality
- Candidate management
- RESTful API for frontend integration
- Middleware for authentication and authorization

## Technologies Used

- Node.js
- Express.js
- MongoDB (with Mongoose)
- JSON Web Tokens (JWT) for authentication
- bcryptjs for password hashing
- dotenv for environment variable management
- CORS for cross-origin resource sharing

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/nex-vote-backend.git
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

Contributions are welcome! Please open an issue or submit a pull request for any improvements or features.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Thanks to the contributors and the open-source community for their support.