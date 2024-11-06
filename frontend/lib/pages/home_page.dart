import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nex_vote/consts/conts.dart';
import 'package:nex_vote/metamask_provider.dart';
import 'package:nex_vote/model/proposal_model.dart';
import 'package:nex_vote/model/vote_model.dart';
import 'package:nex_vote/provider/api.dart';
import 'package:nex_vote/widgets/proposal_created.dart';
import 'package:nex_vote/widgets/user_info.dart';
import 'package:nex_vote/widgets/vote_history.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ElectionVote> vote_history= [];
  List<Election> proposal =[];
  List<Election> updatedProposal = [];

  @override
  void initState() {
    super.initState();
    fetchDataAndUpdate();
  }

  Future<void> fetchDataAndUpdate() async {
    await fetchData();
    await updateAllElections(proposal, context);
  }

  Future<void> fetchData() async {
    try {
      String token = Provider.of<MetaMaskProvider>(context, listen: false)
          .authResponse!
          .token;
      // Fetch elections and user's voting history
      List<ElectionVote> vote_his = await ApiService().fetchUserVotes(token);

      List<Election> pro = await ApiService().fetchElections(token);

      // Filter out elections that the user has already voted in
      setState(() {
        vote_history = vote_his;
        proposal = pro;
      });


    } catch (e) {
      print('Failed to fetch elections: $e');
    }
  }

  Future<void> updateAllElections(List<Election> elections, BuildContext context) async {
    List<Election> updatedList = [];

    for (var election in elections) {
      // Update each election with votes
      Election update = await updateElectionWithVotes(election, context);
      updatedList.add(update);
    }
    setState(() {
      updatedProposal = updatedList;
      // isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if the screen width is less than 790 pixels
        bool isSmallScreen = constraints.maxWidth < 790;

        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: constraints.maxHeight * 0.4, // Adjust height proportionally
                width: double.infinity, // Ensure it takes full width
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColorsHome.selectedIconBox,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: UserInfo(),
              ),
              if (isSmallScreen)
                Column(
                  children: [
                    Container(
                      height: constraints.maxHeight * 0.25, // Adjust height proportionally
                      width: double.infinity, // Ensure it takes full width
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ThemeColorsHome.selectedIconBox,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: VoteHistory(voteHistory: vote_history),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: constraints.maxHeight * 0.25, // Adjust height proportionally
                      width: double.infinity, // Ensure it takes full width
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ThemeColorsHome.selectedIconBox,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ProposalCreated(elections: proposal),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: constraints.maxHeight * 0.5, // Adjust height proportionally
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ThemeColorsHome.selectedIconBox,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: VoteHistory(voteHistory: vote_history,),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: constraints.maxHeight * 0.5, // Adjust height proportionally
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ThemeColorsHome.selectedIconBox,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ProposalCreated(elections: proposal),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

Future<Election> updateElectionWithVotes(Election election,  BuildContext context) async{
  List<ContractCandidate> contractCandidates = await Provider.of<MetaMaskProvider>(context, listen: false).getResults(election.electionIndex);
  // Create a map for easy lookup of contract candidates by name
  Map<String, int> contractCandidateVotes = {
    for (var contractCandidate in contractCandidates)
      contractCandidate.name: contractCandidate.voteCount
  };

  // Update voteCount for each candidate based on the results
  List<Candidate> updatedCandidates = election.candidates.map((candidate) {
    // Set voteCount based on the contractCandidateVotes map; default to 0 if not found
    candidate.voteCount = contractCandidateVotes[candidate.name] ?? 0;
    return candidate;
  }).toList();

  // Return a new Election object with updated candidates and other properties
  return Election(
    id: election.id,
    title: election.title,
    description: election.description,
    startDate: election.startDate,
    endDate: election.endDate,
    creator: election.creator,
    creatorWallet: election.creatorWallet,
    electionIndex: election.electionIndex,
    candidates: updatedCandidates,
    createdAt: election.createdAt,
    updatedAt: DateTime.now(),
    isVotingOpen: election.isVotingOpen,
  );
}