const express = require("express");
const Election = require("../model/electionModel"); // Adjust the path as necessary
const Candidate = require("../model/candidateModel"); // Adjust the path as necessary
const router = express.Router();
const {
  authMiddleware,
  isElectionAdminMiddleware,
} = require("../controllers/authControllers");

// Create an Election
router.post("/", authMiddleware, async (req, res) => {
  const {
    title,
    description,
    startDate,
    endDate,
    creatorWallet,
    electionIndex,
  } = req.body;

  // Use req.userId from authMiddleware to set the creator
  const creator = req.userId;

  try {
    const newElection = new Election({
      title,
      description,
      startDate,
      endDate,
      creator,
      creatorWallet,
      electionIndex,
    });

    await newElection.save();
    res.status(201).json({
      message: "Election created successfully",
      election: newElection,
    });
  } catch (error) {
    res.status(500).json({ message: "Error creating election", error });
  }
});

// Get All Elections - No authentication needed
router.get("/", async (req, res) => {
  try {
    const elections = await Election.find();
    res.status(200).json(elections);
  } catch (error) {
    res.status(500).json({ message: "Error fetching elections", error });
  }
});

// Get Election by ID - No authentication needed
router.get("/:id", async (req, res) => {
  const { id } = req.params;

  try {
    const election = await Election.findById(id);
    if (!election) {
      return res.status(404).json({ message: "Election not found" });
    }
    res.status(200).json(election);
  } catch (error) {
    res.status(500).json({ message: "Error fetching election", error });
  }
});

// Update Election - Only creator (admin) can update
router.put(
  "/:id",
  authMiddleware,
  isElectionAdminMiddleware,
  async (req, res) => {
    const { id } = req.params;
    const { title, description, startDate, endDate, creatorWallet } = req.body;

    try {
      const updatedElection = await Election.findByIdAndUpdate(
        id,
        { title, description, startDate, endDate, creatorWallet },
        { new: true }
      );

      if (!updatedElection) {
        return res.status(404).json({ message: "Election not found" });
      }

      res.status(200).json({
        message: "Election updated successfully",
        election: updatedElection,
      });
    } catch (error) {
      res.status(500).json({ message: "Error updating election", error });
    }
  }
);

// Delete Election - Only creator (admin) can delete
router.delete(
  "/:id",
  authMiddleware,
  isElectionAdminMiddleware,
  async (req, res) => {
    const { id } = req.params;

    try {
      const deletedElection = await Election.findByIdAndDelete(id);
      if (!deletedElection) {
        return res.status(404).json({ message: "Election not found" });
      }

      res.status(200).json({ message: "Election deleted successfully" });
    } catch (error) {
      res.status(500).json({ message: "Error deleting election", error });
    }
  }
);

// Add Candidate to Election - Only creator (admin) can add
router.post(
  "/:electionId/candidate",
  authMiddleware,
  isElectionAdminMiddleware,
  async (req, res) => {
    const { name, walletAddress, candidateIndex, symbol } = req.body;
    const { electionId } = req.params;

    try {
      // Find the election by ID
      const election = await Election.findById(electionId);
      if (!election) {
        return res.status(404).json({ message: "Election not found" });
      }

      // Create the new candidate object
      const newCandidate = {
        name,
        symbol,
        contractIndex: candidateIndex,
        walletAddress,
      };

      // Add the new candidate to the election's candidates array
      election.candidates.push(newCandidate);

      // Save the updated election document
      await election.save();

      res.status(201).json({
        message: "Candidate added successfully",
        candidate: newCandidate,
      });
    } catch (error) {
      console.error("Error adding candidate:", error);
      res.status(500).json({ message: "Error adding candidate", error });
    }
  }
);

// Close Election - Only creator (admin) can close
router.put(
  "/:id/close",
  authMiddleware,
  isElectionAdminMiddleware,
  async (req, res) => {
    const { id } = req.params;

    try {
      const election = await Election.findById(id);
      if (!election)
        return res.status(404).json({ message: "Election not found" });

      if (!election.isVotingOpen) {
        return res.status(400).json({ message: "Election is already closed" });
      }

      election.isVotingOpen = false;
      election.updatedAt = Date.now();
      const updatedElection = await election.save();

      res
        .status(200)
        .json({ message: "Election closed successfully", updatedElection });
    } catch (error) {
      res.status(500).json({ message: "Error closing election", error });
    }
  }
);

module.exports = router;
