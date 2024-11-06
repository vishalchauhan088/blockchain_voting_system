import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nex_vote/consts/conts.dart';
import 'package:nex_vote/metamask_provider.dart';
import 'package:nex_vote/model/proposal_model.dart';
import 'package:nex_vote/provider/api.dart';

import 'package:nex_vote/widgets/proposal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProposalPage extends StatefulWidget {
  const ProposalPage({super.key});

  @override
  State<ProposalPage> createState() => _ProposalPageState();
}

class _ProposalPageState extends State<ProposalPage> {
  List<Election> elections = [];
  String searchQuery = '';
  bool isLoading = true; // Loading state

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
      List<Election> ele = await ApiService().fetchElections(token);
      ele.sort((a, b) {
        return a.isVotingOpen == b.isVotingOpen ? 0 : (a.isVotingOpen ? -1 : 1);
      });
      setState(() {
        elections = ele;
      });
    } catch (e) {
      print('Failed to fetch elections: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
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
    double childAspectRatio = (screenWidth / crossAxisCount) / 296;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColorsHome.backgroundColor,
        title: Text(
          'Election History',
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
          child: isLoading
              ? Center(child: CircularProgressIndicator()) // Loading indicator
              : Column(
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
                      child: GridView.builder(
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
                            onTap: () async {
                              // Fetch results for the election candidates
                              List<ContractCandidate> contractCandidates =
                                  await Provider.of<MetaMaskProvider>(context,
                                          listen: false)
                                      .getResults(election.electionIndex);

                              // Create a map for easy lookup of contract candidates by name
                              Map<String, int> contractCandidateVotes = {
                                for (var contractCandidate
                                    in contractCandidates)
                                  contractCandidate.name:
                                      contractCandidate.voteCount
                              };

                              // Update voteCount for each candidate based on the results
                              for (var candidate in election.candidates) {
                                // Set voteCount based on the contractCandidateVotes map; default to 0 if not found
                                candidate.voteCount =
                                    contractCandidateVotes[candidate.name] ?? 0;
                              }

                              // Show the election details dialog
                              _showElectionDetailsDialog(context, election);
                            },
                            child: Card(
                              margin: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 3,
                              color: election.isVotingOpen
                                  ? ThemeColorsHome.primaryColor1
                                  : ThemeColorsHome.primaryColor2,
                              // color: ThemeColorsHome.primaryColor1,
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
                                    Text(
                                      election.isVotingOpen
                                          ? 'Status: Voting Open'
                                          : 'Status: Voting Closed',
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProposalBottomSheet(context),
        child: Icon(Icons.add, color: ThemeNavColors.backgroundColor),
        backgroundColor: ThemeNavColors.selectedIconBox,
      ),
    );
  }

  void _showAddProposalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ProposalBottomSheet(
          onSubmit: () {
            // Add logic to handle proposal submission
            fetchElections();
            Navigator.pop(context); // Close the bottom sheet
          },
          onUpdateElections: fetchElections,
        );
      },
    );
  }

  void _showElectionDetailsDialog(BuildContext context, Election election) {
    Candidate? winner = findWinner(election.candidates);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    election.title,
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  bool close = await Provider.of<MetaMaskProvider>(context,
                          listen: false)
                      .closeVoting(election.electionIndex);
                  if (!close) {
                    String token =
                        Provider.of<MetaMaskProvider>(context, listen: false)
                            .authResponse!
                            .token;
                    await ApiService().closeElection(election.id!, token);
                    Fluttertoast.showToast(
                        msg: "Election Closed Successfully",
                        timeInSecForIosWeb: 4);
                    fetchElections();
                  } else {
                    Fluttertoast.showToast(
                        msg: "Error Election Closing", timeInSecForIosWeb: 4);
                  }
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close Election',
                  style: GoogleFonts.openSans(
                    color: Colors.blueAccent, // White text for contrast
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                // Display election details
                Row(
                  children: [
                    titleValueRow('Start Date',
                        '${formatDate(election.startDate)}    ', 16),
                    titleValueRow('Time', formatTime(election.startDate), 16),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    titleValueRow('End Date', formatDate(election.endDate), 16),
                    titleValueRow('    Time', formatTime(election.endDate), 16),
                  ],
                ),
                SizedBox(height: 8),
                titleValueRow('Description', '${election.description}', 16),
                SizedBox(height: 8),
                if (!election.isVotingOpen)
                  titleValueRow('Winner', '${winner?.name ?? 'N/A'}', 16),
                SizedBox(height: 8),
                Divider(),

                // Display the candidate list if available
                if (election.candidates.isNotEmpty) ...[
                  Text(
                    'Candidates:',
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 500,
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      // Allow the list view to take up only the required space
                      physics: NeverScrollableScrollPhysics(),
                      // Disable scrolling to prevent overflow
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
                              Text("Total Vote:${candidate.voteCount ?? 0}")
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                ] else ...[
                  Text(
                    'No candidates available for this election.',
                    style: GoogleFonts.openSans(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                ],

                // Button to add a new candidate
                if (election.isVotingOpen)
                  ElevatedButton(
                    onPressed: () {
                      _showAddCandidateDialog(context, election);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent, // Modern green color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Add Candidate',
                      style: GoogleFonts.openSans(
                        color: ThemeNavColors.backgroundColor,
                      ),
                    ),
                  ),
              ],
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

  Candidate? findWinner(List<Candidate> candidates) {
    if (candidates.isEmpty) return null; // Return null if no candidates

    // Start with the first candidate as the initial winner
    Candidate winner = candidates[0];

    // Iterate through candidates to find the one with the maximum vote count
    for (var candidate in candidates) {
      if (candidate.voteCount != null &&
          candidate.voteCount! > winner.voteCount!) {
        winner = candidate;
      }
    }

    return winner; // Return the candidate with the maximum votes
  }

  void _showAddCandidateDialog(BuildContext context, Election election) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController walletAddressController =
        TextEditingController();
    final TextEditingController symbolController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Candidate'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Candidate Name'),
                ),
                TextField(
                  controller: walletAddressController,
                  decoration: InputDecoration(labelText: 'Wallet Address'),
                ),
                TextField(
                  controller: symbolController,
                  decoration: InputDecoration(labelText: 'Symbol'),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    // Get the input values
                    final String name = nameController.text;
                    final String walletAddress = walletAddressController.text;
                    final String symbol = symbolController.text;

                    // Create the new candidate object
                    final newCandidate = Candidate(
                      name: name,
                      symbol: symbol,
                      contractIndex: 0, // Adjust as needed
                      walletAddress: walletAddress,
                    );

                    String token =
                        Provider.of<MetaMaskProvider>(context, listen: false)
                            .authResponse!
                            .token;

                    // Call the function to add a candidate to the election
                    ContractElectionDetails res =
                        await Provider.of<MetaMaskProvider>(context,
                                listen: false)
                            .addCandidate(election.electionIndex, name, "ZZ");
                    print(res);
                    await ApiService().addCandidateToElection(
                        election.id!, newCandidate, token);
                    fetchElections(); // Refresh the elections list
                    Fluttertoast.showToast(
                        msg: "Candidate Added Successfully",
                        timeInSecForIosWeb: 3);
                    Navigator.pop(context); // Close the dialog
                    Navigator.pop(context);
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

// Function to create a TitleValueRow widget
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
  String formattedDate =
      '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';

  // Format the time to "HH:MM"
  String formattedTime =
      '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

  // Combine date and time
  return '$formattedDate';
}

String formatTime(DateTime dateTime) {
  // Format the date to "YYYY-MM-DD"
  String formattedDate =
      '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';

  // Format the time to "HH:MM"
  String formattedTime =
      '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

  // Combine date and time
  return '$formattedTime';
}
