class Election {
  final String? id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String creator;
  final String creatorWallet;
  final int electionIndex;
  List<Candidate> candidates; // List of Candidate objects
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVotingOpen;

  Election({
    this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.creator,
    required this.creatorWallet,
    required this.electionIndex,
    required this.candidates,
    required this.createdAt,
    required this.updatedAt,
    required this.isVotingOpen
  });

  factory Election.fromJson(Map<String, dynamic> json) {
    return Election(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      creator: json['creator'],
      creatorWallet: json['creatorWallet'],
      electionIndex: json['electionIndex'],
      candidates: (json['candidates'] as List<dynamic>?)
          ?.map((candidate) => Candidate.fromJson(candidate))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
        isVotingOpen: json['isVotingOpen']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'creator': creator,
      'creatorWallet': creatorWallet,
      'electionIndex': electionIndex,
      'candidates': candidates.map((candidate) => candidate.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isVotingOpen' : isVotingOpen
    };
  }
}

class Candidate {
  final String? id;
  final String name;
  final String symbol;
  final int contractIndex;
  final String walletAddress;
  int? voteCount;

  Candidate({
    this.id, // Initialize ID as optional
    required this.name,
    required this.symbol,
    required this.contractIndex,
    required this.walletAddress,
    this.voteCount
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json['_id'], // Parse _id from JSON
      name: json['name'],
      symbol: json['symbol'],
      contractIndex: json['contractIndex'],
      walletAddress: json['walletAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id, // Include _id only if it's not null
      'name': name,
      'symbol': symbol,
      'contractIndex': contractIndex,
      'walletAddress': walletAddress,
    };
  }
}


class ContractElectionDetails {
  final String title;
  final bool isVotingOpen;
  final List<ContractCandidate> candidates;

  ContractElectionDetails({
    required this.title,
    // required this.creator,
    required this.isVotingOpen,
    required this.candidates,
  });

  factory ContractElectionDetails.fromList(List<dynamic> data) {
    // Assuming candidates are returned as a list of lists
    List<ContractCandidate> candidates = (data[3] as List).map((candidateData) {
      return ContractCandidate(
        name: candidateData[0],
        symbol: candidateData[1],
        voteCount: candidateData[2].toInt(),
      );
    }).toList();

    return ContractElectionDetails(
      title: data[0],
      // creator: data[1],
      isVotingOpen: data[2],
      candidates: candidates,
    );
  }
}

class ContractCandidate {
  final String name;
  final String symbol;
  final int voteCount;

  ContractCandidate({
    required this.name,
    required this.symbol,
    required this.voteCount,
  });

  factory ContractCandidate.fromList(List<dynamic> data) {
    return ContractCandidate(
      name: data[0],
      symbol: data[1],
      voteCount: data[2].toInt(),
    );
  }
}
