import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nex_vote/consts/conts.dart';
import 'package:nex_vote/model/proposal_model.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'package:nex_vote/metamask_provider.dart'; // Import your MetaMaskProvider

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  TextEditingController name = TextEditingController();
  int candidateCount = 0; // Store the candidate count
  String errorMessage = ''; // Store any error message

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 790;

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
          child: Consumer<MetaMaskProvider>(builder: (context, provider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: isSmallScreen ? 2 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textField('UserName', provider.authResponse!.user.name),
                      SizedBox(height: 8),
                      textField('Email', provider.authResponse!.user.email),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Wallet Address: ',
                            style: GoogleFonts.openSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      provider.currentAddress,
                                      style: GoogleFonts.openSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[800],
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: provider.currentAddress));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Address copied to clipboard!')),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.copy_rounded,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     try {
                      //       int count = await provider.getElectionCount();
                      //       setState(() {
                      //         candidateCount = count; // Update candidate count
                      //         errorMessage = ''; // Clear any previous errors
                      //       });
                      //     } catch (e) {
                      //       setState(() {
                      //         errorMessage = e.toString(); // Set error message
                      //         print(errorMessage);
                      //       });
                      //     }
                      //   },
                      //   child: Text('Get Candidate Count'),
                      // ),
                      // // Display the candidate count or error message below the button
                      // if (errorMessage.isNotEmpty)
                      //   Text(
                      //     'Error: $errorMessage',
                      //     style: TextStyle(color: Colors.red),
                      //   ),
                      // if (candidateCount > 0)
                      //   Text(
                      //     'Candidate Count: $candidateCount',
                      //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      //   ),
                      // TextField(
                      //   controller: name,
                      //   decoration: InputDecoration(
                      //     labelText: 'Name',
                      //   ),
                      // ),
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     try {
                      //       // int res = await provider.createElection(name.text);
                      //       // print(res);
                      //
                      //       // ContractElectionDetails res = await provider.addCandidate(3, name.text, "ZZ");
                      //       // print(res);
                      //
                      //       // List<ContractCandidate> candidates = await provider.getResults(3);
                      //       // candidates.forEach((candidate) {
                      //       //   print('Candidate Name: ${candidate.name}, Votes: ${candidate.voteCount}');
                      //       // });
                      //
                      //       // bool vote = await provider.castVote(1, 0);
                      //       // bool vote = await provider.hasVotedInElection(1);
                      //       // print(vote);
                      //       // bool close = await provider.closeVoting(1);
                      //       // print("voting $close");
                      //
                      //     } catch (e) {
                      //       setState(() {
                      //         errorMessage = e.toString(); // Set error message
                      //         print(errorMessage);
                      //       });
                      //     }
                      //   },
                      //   child: Text('Create'),
                      // ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Center(
                    child: Icon(
                      Icons.person_2_rounded,
                      size: 150,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Widget textField(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.openSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey[800],
            ),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
