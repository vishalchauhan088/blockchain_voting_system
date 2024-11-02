const express = require("express");
const VotingActivity = require("../model/votingActivityModel");
const { authMiddleware } = require("../controllers/authControllers");
const router = express.Router();

// Voting Route
router.post("/:electionId/vote", authMiddleware, async (req, res) => {
  const { electionId } = req.params;
  const { candidateId, transactionHash } = req.body; // Expect transaction hash from frontend

  try {
    // Assuming req.userId is set by authMiddleware
    const votingActivity = new VotingActivity({
      user: req.userId, // Use the authenticated user's ID
      election: electionId,
      candidateId,
      transactionHash, // Save the transaction hash received from the frontend
    });

    await votingActivity.save();

    res
      .status(200)
      .json({ message: "Vote recorded successfully!", votingActivity });
  } catch (error) {
    console.error("Error recording vote:", error);
    res
      .status(500)
      .json({ message: "Failed to record vote", error: error.message });
  }
});

router.get("/my-votes", authMiddleware, async (req, res) => {
  const userId = req.userId; // Get the authenticated user's ID

  try {
    // Find voting activities for the user
    const votingActivities = await VotingActivity.find({
      user: userId,
    }).populate("election"); // Populate the election details

    // Map to get just the elections details
    const electionsVoted = votingActivities.map((voting) => ({
      electionId: voting.election._id,
      title: voting.election.title,
      description: voting.election.description,
      timestamp: voting.timestamp,
      candidateId: voting.candidateId,
      transactionHash: voting.transactionHash,
    }));

    res.status(200).json(electionsVoted);
  } catch (error) {
    console.error("Error fetching user's voted elections:", error);
    res
      .status(500)
      .json({
        message: "Failed to fetch elections where user has voted",
        error: error.message,
      });
  }
});

module.exports = router;
