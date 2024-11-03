const mongoose = require("mongoose");

// Assuming you have a User model defined in the same directory
const User = require("./userMode"); // Adjust the path as necessary

const electionSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    // required: true,
  },
  startDate: {
    type: Date,
    //required: true,
  },
  endDate: {
    type: Date,
    //required: true,
  },
  creator: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User", // Reference to the User model
    required: true, // Reference to the user who created the election
  },
  creatorWallet: {
    type: String,
    required: true, // Wallet address of the election creator
  },
  candidates: [
    {
      name: { type: String, required: true },
      symbol: { type: String, required: true },
      contractIndex: { type: Number, required: true },
      walletAddress: { type: String },
    },
  ],
  electionIndex: {
    type: Number,
    required: true, // Index of the election on the contract
  },
  isVotingOpen: {
    type: Boolean,
    default: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

const Election = mongoose.model("Election", electionSchema);
module.exports = Election;
