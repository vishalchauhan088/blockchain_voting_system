const jwt = require("jsonwebtoken");
const Election = require("../model/electionModel");

const authMiddleware = (req, res, next) => {
  const token = req.headers["authorization"]?.split(" ")[1];

  if (!token) {
    return res.status(403).json({ message: "No token provided" });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
    if (err) {
      console.log(err);
      return res.status(401).json({ message: "Unauthorized" });
    }
    req.userId = decoded.id;
    req.isAdmin = decoded.isAdmin; // Optional: Store admin status
    console.log("Authenticated user:");
    next();
  });
};
const isElectionAdminMiddleware = async (req, res, next) => {
  const electionId = req.params.electionId; // Get the election ID from the request params

  try {
    // Find the election by ID
    const election = await Election.findById(electionId);
    if (!election) {
      return res.status(404).json({ message: "Election not found" });
    }

    // Check if the logged-in user is the creator of the election
    // if (req.userId !== election.creator.toString()) {
    //   return res
    //     .status(403)
    //     .json({
    //       message: "You are not authorized to add candidates to this election",
    //     });
    // }

    if (!election.creator.equals(req.userId)) {
      return res
        .status(403)
        .json({
          message: "You are not authorized to add candidates to this election",
        });
    }

    // User is the creator, proceed to the next middleware
    req.electionId = electionId;
    next();
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Internal server error", error });
  }
};

module.exports = { authMiddleware, isElectionAdminMiddleware };
