import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nex_vote/consts/conts.dart';
import 'package:nex_vote/metamask_provider.dart';
import 'package:nex_vote/model/proposal_model.dart';
import 'package:nex_vote/model/vote_model.dart';
import 'package:nex_vote/provider/api.dart';
import 'package:provider/provider.dart';

class VotePage extends StatefulWidget {
  const VotePage({super.key});

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  String searchQuery = '';
  List<Election> elections = [];
  List<ElectionVote> vote_history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchElections();
  }

  Future<void> fetchElections() async {
    try {
      String token = Provider.of<MetaMaskProvider>(context, listen: false)
          .authResponse!
          .token;
      // Fetch elections and user's voting history
      elections = await ApiService().fetchElections(token);
      List<ElectionVote> vote_history =
          await ApiService().fetchUserVotes(token);

      // Extract the election IDs from the vote_history
      List<String> votedElectionIds =
          vote_history.map((vote) => vote.electionId).toList();

      // Filter out elections that the user has already voted in
      setState(() {
        elections = elections.where((election) =>
        !votedElectionIds.contains(election.id) &&
            election.isVotingOpen // Check if voting is open
        ).toList();
      });
    } catch (e) {
      print('Failed to fetch elections: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading when done
      });
    }
  }

  void _showElectionDetailsDialog(BuildContext context, Election election) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              election.title,
              style: GoogleFonts.openSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Container(
            width: 500,
            height: 300,
            child: SingleChildScrollView(
              child: ListBody(
                children: [
                  // Display election details
                  Row(

                    children: [
                      titleValueRow('Start Date' ,'${formatDate(election.startDate)}    ',16),
                      titleValueRow('Time' ,formatTime(election.startDate),16),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      titleValueRow('End Date', formatDate(election.endDate),16),
                      titleValueRow('    Time', formatTime(election.endDate),16),
                    ],
                  ),
                  SizedBox(height: 8),
                  titleValueRow('Description', election.description,16),
                  SizedBox(height: 8),
                  Divider(),
                  // Display candidates and vote buttons
                  if (election.candidates.isNotEmpty) ...[
                    Text(
                      'Candidates:',
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: election.candidates.length,
                      itemBuilder: (context, index) {
                        final candidate = election.candidates[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${candidate.name} (${candidate.symbol})',
                                style: GoogleFonts.openSans(fontSize: 16),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _castVote(candidate.id, election, index);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ThemeNavColors.selectedIconBox,
                                ),
                                child: Text(
                                  'Vote',
                                  style: GoogleFonts.openSans(
                                    color: ThemeNavColors.backgroundColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ] else ...[
                    Text(
                      'No candidates available for this election.',
                      style: GoogleFonts.openSans(fontSize: 16),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _castVote(String? candidateId, Election election, int index) async {
    // Implement your vote casting logic here
    if (candidateId != null && election.id != null) {
      // Example API call to cast the vote

      String token = Provider.of<MetaMaskProvider>(context, listen: false)
          .authResponse!
          .token;
      String transactionHash = '0x354yhgf3';
      bool vote = await Provider.of<MetaMaskProvider>(context, listen: false).castVote(election.electionIndex, index);
      if (vote) {
        await ApiService()
            .castVote(election.id!, candidateId, transactionHash, token);
        print(
            'Casting vote for candidate: $candidateId in election: ${election
                .id}');
        Fluttertoast.showToast(msg: 'Vote Successfully', timeInSecForIosWeb: 3);
        await fetchElections();
      }
      Navigator.pop(context);
      // Perform the API call, and handle the response as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine the number of columns based on screen width
    int crossAxisCount;
    if (screenWidth > 1200) {
      crossAxisCount = 4; // For larger screens, use 4 columns
    } else if (screenWidth > 800) {
      crossAxisCount = 3; // For medium screens, use 3 columns
    } else {
      crossAxisCount = 2; // For smaller screens, use 2 columns
    }

    // Calculate the aspect ratio dynamically
    double childAspectRatio =
        (screenWidth / crossAxisCount) / 180; // Adjust height here

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColorsHome.backgroundColor,
        title: Text(
          'Votes',
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: ThemeColorsHome.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search Elections',
                style: GoogleFonts.openSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Search by Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.teal),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Expanded(
                child: isLoading
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Show loading indicator
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: elections
                            .where((election) => election.title
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()))
                            .length,
                        itemBuilder: (context, index) {
                          final filteredElections = elections
                              .where((election) => election.title
                                  .toLowerCase()
                                  .contains(searchQuery.toLowerCase()))
                              .toList();
                          final election = filteredElections[index];

                          return GestureDetector(
                            onTap: () {
                              _showElectionDetailsDialog(context, election);
                            },
                            child: Card(
                              margin: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 3,
                              color: ThemeColorsHome.primaryColor1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      election.title,
                                      style: GoogleFonts.openSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      election.description,
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          'Start Date: ${formatDate(election.startDate)}  ',
                                          style: GoogleFonts.openSans(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          'Time: ${formatTime(election.startDate)}',
                                          style: GoogleFonts.openSans(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'End Date: ${formatDate(election.endDate)} ',
                                          style: GoogleFonts.openSans(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          'Time: ${formatTime(election.endDate)}',
                                          style: GoogleFonts.openSans(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Widget titleValueRow(String title, String value, double size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$title: ',
              style: GoogleFonts.openSans(
                fontSize: size,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: value,
              style: GoogleFonts.openSans(
                fontSize: size,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

String formatDate(DateTime dateTime) {
  // Format the date to "YYYY-MM-DD"
  String formattedDate = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';

  // Combine date and time
  return '$formattedDate';
}
String formatTime(DateTime dateTime) {
  // Format the time to "HH:MM"
  String formattedTime = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

  // Combine date and time
  return '$formattedTime';
}