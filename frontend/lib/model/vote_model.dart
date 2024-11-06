class ElectionVote {
  String electionId;
  String title;
  String description;
  DateTime timestamp;
  String transactionHash;

  ElectionVote({
    required this.electionId,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.transactionHash,
  });

  // Factory constructor to create an ElectionVote from JSON
  factory ElectionVote.fromJson(Map<String, dynamic> json) {
    return ElectionVote(
      electionId: json['electionId'],
      title: json['title'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      transactionHash: json['transactionHash'],
    );
  }

  // Method to convert ElectionVote to JSON
  Map<String, dynamic> toJson() {
    return {
      'electionId': electionId,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'transactionHash': transactionHash,
    };
  }
}
