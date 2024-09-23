// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract VotingSystem {
    enum ElectionStatus {
        Registration,
        Voting,
        Ended
    }

    struct Candidate {
        string name;
        address candidateAddress;
        uint256 voteCount; // Track number of votes
        bool isRegistered;
    }

    struct Election {
        string name;
        address[] admins; // Admins specific to this election
        ElectionStatus status;
        mapping(address => bool) registeredVoters; // Track registered voters
        mapping(address => bool) voted; // Track if a voter has voted
        mapping(address => Candidate) candidates; // Track candidates
        address[] candidateList; // List of candidate addresses
    }

    mapping(uint256 => Election) public elections;
    uint256 public electionCount;

    // Events for tracking important actions
    event VoterRegistered(uint256 indexed electionId, address indexed voter);
    event CandidateRegistered(
        uint256 indexed electionId,
        address indexed candidate
    );
    event CandidateRemoved(
        uint256 indexed electionId,
        address indexed candidate
    );
    event Voted(
        uint256 indexed electionId,
        address indexed voter,
        address indexed candidate
    );
    event ElectionStatusChanged(
        uint256 indexed electionId,
        ElectionStatus status
    );

    modifier onlyAdmin(uint256 electionId) {
        require(
            isElectionAdmin(electionId, msg.sender),
            "Only admin can perform this action."
        );
        _;
    }

    modifier onlyDuringVoting(uint256 electionId) {
        require(
            elections[electionId].status == ElectionStatus.Voting,
            "Not in voting phase."
        );
        _;
    }

    modifier onlyDuringRegistration(uint256 electionId) {
        require(
            elections[electionId].status == ElectionStatus.Registration,
            "Not in registration phase."
        );
        _;
    }

    constructor() {}

    function createElection(string memory name) public {
        Election storage newElection = elections[electionCount];
        newElection.name = name;
        newElection.admins.push(msg.sender); // Add creator as the first admin
        newElection.status = ElectionStatus.Registration;
        electionCount++;
    }

    function addAdmin(
        uint256 electionId,
        address newAdmin
    ) public onlyAdmin(electionId) {
        elections[electionId].admins.push(newAdmin);
    }

    function openRegistration(uint256 electionId) public onlyAdmin(electionId) {
        elections[electionId].status = ElectionStatus.Registration;
        emit ElectionStatusChanged(electionId, ElectionStatus.Registration);
    }

    function closeRegistration(
        uint256 electionId
    ) public onlyAdmin(electionId) {
        elections[electionId].status = ElectionStatus.Voting;
        emit ElectionStatusChanged(electionId, ElectionStatus.Voting);
    }

    function endVoting(uint256 electionId) public onlyAdmin(electionId) {
        elections[electionId].status = ElectionStatus.Ended;
        emit ElectionStatusChanged(electionId, ElectionStatus.Ended);
    }

    function registerVoter(
        uint256 electionId,
        address voter
    ) public onlyAdmin(electionId) onlyDuringRegistration(electionId) {
        require(
            !elections[electionId].registeredVoters[voter],
            "Voter is already registered."
        );
        elections[electionId].registeredVoters[voter] = true;
        emit VoterRegistered(electionId, voter);
    }

    function registerCandidate(
        uint256 electionId,
        string memory candidateName
    ) public onlyDuringRegistration(electionId) {
        require(
            !elections[electionId].candidates[msg.sender].isRegistered,
            "Candidate is already registered."
        );

        elections[electionId].candidates[msg.sender] = Candidate({
            name: candidateName,
            candidateAddress: msg.sender,
            voteCount: 0,
            isRegistered: true
        });

        elections[electionId].candidateList.push(msg.sender);
        emit CandidateRegistered(electionId, msg.sender);
    }

    function removeCandidate(
        uint256 electionId,
        address candidateAddress
    ) public onlyAdmin(electionId) onlyDuringRegistration(electionId) {
        require(
            elections[electionId].candidates[candidateAddress].isRegistered,
            "Candidate is not registered."
        );

        elections[electionId].candidates[candidateAddress].isRegistered = false;
        emit CandidateRemoved(electionId, candidateAddress);
    }

    function vote(
        uint256 electionId,
        address candidateAddress
    ) public onlyDuringVoting(electionId) {
        require(
            elections[electionId].registeredVoters[msg.sender],
            "You are not registered to vote."
        );
        require(
            !elections[electionId].voted[msg.sender],
            "You have already voted."
        );
        require(
            elections[electionId].candidates[candidateAddress].isRegistered,
            "Candidate is not registered."
        );

        elections[electionId].voted[msg.sender] = true; // Mark as voted
        elections[electionId].candidates[candidateAddress].voteCount++; // Increment vote count for the candidate
        emit Voted(electionId, msg.sender, candidateAddress);
    }

    function getElectionDetails(
        uint256 electionId
    )
        public
        view
        returns (
            string memory name,
            ElectionStatus status,
            address[] memory admins
        )
    {
        Election storage election = elections[electionId];
        return (election.name, election.status, election.admins);
    }

    function getCandidateList(
        uint256 electionId
    ) public view returns (address[] memory) {
        return elections[electionId].candidateList;
    }

    function getCandidateVoteCount(
        uint256 electionId,
        address candidateAddress
    ) public view returns (uint256) {
        require(
            elections[electionId].candidates[candidateAddress].isRegistered,
            "Candidate is not registered."
        );
        return elections[electionId].candidates[candidateAddress].voteCount;
    }

    function getFinalResults(
        uint256 electionId
    ) public view returns (Candidate[] memory) {
        require(
            elections[electionId].status == ElectionStatus.Ended,
            "Election has not ended yet."
        );

        Candidate[] memory results = new Candidate[](
            elections[electionId].candidateList.length
        );
        for (
            uint256 i = 0;
            i < elections[electionId].candidateList.length;
            i++
        ) {
            address candidateAddress = elections[electionId].candidateList[i];
            results[i] = elections[electionId].candidates[candidateAddress];
        }
        return results;
    }

    function isElectionAdmin(
        uint256 electionId,
        address admin
    ) public view returns (bool) {
        for (uint256 i = 0; i < elections[electionId].admins.length; i++) {
            if (elections[electionId].admins[i] == admin) {
                return true;
            }
        }
        return false;
    }
}
