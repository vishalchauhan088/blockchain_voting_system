// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract VotingSystem {
    struct Candidate {
        string name;
        string symbol;
        uint voteCount;
    }

    struct Election {
        string title;
        address creator;
        bool isVotingOpen;
        uint[] candidateIds; // Array of candidate IDs for this election
        mapping(address => bool) hasVoted; // Track if an address has voted in this election
        mapping(uint => Candidate) candidates; // Mapping of candidate ID to Candidate details
        uint candidateCount; // Candidate count specific to this election
    }

    mapping(uint => Election) public elections;
    uint public electionCount; // 0-based index for elections

    event ElectionCreated(uint electionId, string title, address creator);
    event CandidateAdded(
        uint electionId,
        uint candidateId,
        string name,
        string symbol
    );
    event VoteCast(uint electionId, address voter, uint candidateId);
    event VotingClosed(uint electionId);

    // Create a new election
    function createElection(string memory _title) public returns (uint) {
        elections[electionCount].title = _title;
        elections[electionCount].creator = msg.sender;
        elections[electionCount].isVotingOpen = true; // Voting is open upon creation

        emit ElectionCreated(electionCount, _title, msg.sender);
        electionCount++; // Increment for next election ID
        return electionCount - 1; // Return the ID of the current election (0-based)
    }

    // Add a candidate to an election
    function addCandidate(
        uint electionId,
        string memory _name,
        string memory _symbol
    ) public returns (uint) {
        Election storage election = elections[electionId];
        require(
            election.creator == msg.sender,
            "Only the election creator can add candidates."
        );

        // Use the election's candidateCount as the ID
        election.candidates[election.candidateCount] = Candidate(
            _name,
            _symbol,
            0
        );
        election.candidateIds.push(election.candidateCount); // Add candidate ID to election's candidate list

        emit CandidateAdded(
            electionId,
            election.candidateCount,
            _name,
            _symbol
        );
        election.candidateCount++; // Increment the election's candidate count
        return election.candidateCount - 1; // Return the ID of the current candidate (0-based)
    }

    // Cast a vote for a candidate in an open election
    function castVote(uint electionId, uint candidateId) public {
        Election storage election = elections[electionId];
        require(election.isVotingOpen, "Voting is closed for this election.");
        require(
            !election.hasVoted[msg.sender],
            "You have already voted in this election."
        ); // Check if the sender has already voted

        election.candidates[candidateId].voteCount++;
        election.hasVoted[msg.sender] = true; // Mark the sender as having voted
        emit VoteCast(electionId, msg.sender, candidateId);
    }

    // Close voting for an election (only creator can close it)
    function closeVoting(uint electionId) public {
        require(
            elections[electionId].creator == msg.sender,
            "Only the election creator can close voting."
        );
        elections[electionId].isVotingOpen = false;
        emit VotingClosed(electionId);
    }

    // Get the results of an election
    function getResults(
        uint electionId
    ) public view returns (Candidate[] memory) {
        Election storage election = elections[electionId];
        Candidate[] memory candidates = new Candidate[](
            election.candidateIds.length
        );

        for (uint i = 0; i < election.candidateIds.length; i++) {
            uint candidateId = election.candidateIds[i];
            candidates[i] = election.candidates[candidateId];
        }
        return candidates;
    }

    // Get all details of an election
    function getElectionDetails(
        uint electionId
    )
        public
        view
        returns (
            string memory title,
            address creator,
            bool isVotingOpen,
            Candidate[] memory candidates
        )
    {
        Election storage election = elections[electionId];
        title = election.title;
        creator = election.creator;
        isVotingOpen = election.isVotingOpen;

        candidates = new Candidate[](election.candidateIds.length);
        for (uint i = 0; i < election.candidateIds.length; i++) {
            uint candidateId = election.candidateIds[i];
            candidates[i] = election.candidates[candidateId];
        }
    }

    // Getter function for hasVoted mapping
    function hasVotedInElection(
        uint electionId,
        address voter
    ) public view returns (bool) {
        return elections[electionId].hasVoted[voter];
    }
}
