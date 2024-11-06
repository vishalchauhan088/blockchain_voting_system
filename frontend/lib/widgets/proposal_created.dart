import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nex_vote/consts/conts.dart';
import 'package:nex_vote/metamask_provider.dart';
import 'package:nex_vote/model/proposal_model.dart';
import 'package:provider/provider.dart'; // Update this import to where your Election model is defined

class ProposalCreated extends StatefulWidget {
  final List<Election> elections; // Accepting the list of Election as a parameter

  const ProposalCreated({super.key, required this.elections});

  @override
  State<ProposalCreated> createState() => _ProposalCreatedState();
}

class _ProposalCreatedState extends State<ProposalCreated> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Election History',
              style: GoogleFonts.openSans(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.elections.length,
              itemBuilder: (context, index) {
                Election election = widget.elections[index];
                Candidate? winner = findWinner(election.candidates);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.all(12),
                    childrenPadding: EdgeInsets.all(12),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          election.title,
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        Icon(
                          Icons.circle,
                          color: election.isVotingOpen
                              ? Colors.greenAccent
                              : Colors.redAccent,
                        ),
                      ],
                    ),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description: ${election.description}',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Start Date: ${formatDateTime(election.startDate)}',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'End Date: ${formatDateTime(election.endDate)}',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Creator: ${election.creator}',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Winner: ${winner?.name ?? 'N/A'}',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Total Candidates: ${election.candidates.length}',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


Candidate? findWinner(List<Candidate> candidates) {
  if (candidates.isEmpty) return null; // Return null if no candidates

  // Start with the first candidate as the initial winner
  Candidate winner = candidates[0];

  // Iterate through candidates to find the one with the maximum vote count
  for (var candidate in candidates) {
    if (candidate.voteCount != null && candidate.voteCount! > winner.voteCount!) {
      winner = candidate;
    }
  }

  return winner;
}


String formatDateTime(DateTime dateTime) {
  // Format the date to "YYYY-MM-DD"
  String formattedDate = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';

  // Format the time to "HH:MM"
  String formattedTime = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

  // Combine date and time
  return '$formattedDate Time: $formattedTime';
}