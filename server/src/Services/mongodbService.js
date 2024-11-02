const mongoose = require("mongoose");

class MongodbService {
  constructor(connectionString) {
    this.connectionString = connectionString;
  }

  async connect() {
    try {
      await mongoose.connect(this.connectionString);
      console.log("Connected to MongoDB");
    } catch (err) {
      console.error("Error connecting to MongoDB:", err.message);
    }
  }

  async disconnect() {
    try {
      await mongoose.disconnect();
      console.log("Disconnected from MongoDB");
    } catch (err) {
      console.error("Error disconnecting from MongoDB:", err.message);
    }
  }
}

module.exports = MongodbService;
