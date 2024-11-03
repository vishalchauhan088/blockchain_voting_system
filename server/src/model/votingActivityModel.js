const mongoose = require("mongoose");

const votingActivitySchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  election: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Election",
    required: true,
  },
  candidateId: {
    type: Number, // Index or ID of the candidate in the election contract
    required: true,
  },
  transactionHash: {
    type: String,
    //required: true, // The transaction hash for blockchain tracking
  },
  timestamp: {
    type: Date,
    default: Date.now,
  },
});

const VotingActivity = mongoose.model("VotingActivity", votingActivitySchema);
module.exports = VotingActivity;
