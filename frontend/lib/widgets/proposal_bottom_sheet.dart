import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nex_vote/consts/conts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nex_vote/metamask_provider.dart';
import 'package:nex_vote/model/proposal_model.dart';
import 'package:provider/provider.dart';

class ProposalBottomSheet extends StatefulWidget {
  final VoidCallback onSubmit;
  final VoidCallback onUpdateElections;

  ProposalBottomSheet({required this.onSubmit, required this.onUpdateElections});

  @override
  State<ProposalBottomSheet> createState() => _ProposalBottomSheetState();
}

class _ProposalBottomSheetState extends State<ProposalBottomSheet> {
  final TextEditingController title = TextEditingController();
  final TextEditingController des = TextEditingController();

  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add New Proposal',
            style: GoogleFonts.openSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: title,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: des,
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Date and Time Pickers
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, isStartDate: true),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                        text: _startDate == null
                            ? ''
                            : '${_startDate!.toLocal()}'.split(' ')[0],
                      ),
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectTime(context, isStartTime: true),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                        text: _startTime == null
                            ? ''
                            : _startTime!.format(context),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Start Time',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, isStartDate: false),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                        text: _endDate == null
                            ? ''
                            : '${_endDate!.toLocal()}'.split(' ')[0],
                      ),
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectTime(context, isStartTime: false),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                        text: _endTime == null ? '' : _endTime!.format(context),
                      ),
                      decoration: InputDecoration(
                        labelText: 'End Time',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await _submitProposal();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeNavColors.selectedIconBox,
              ),
              child: Text(
                'Submit',
                style: GoogleFonts.openSans(
                  color: ThemeNavColors.backgroundColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitProposal() async {

    String creator = Provider.of<MetaMaskProvider>(context, listen: false).authResponse!.user.id;
    String creatorWallet = Provider.of<MetaMaskProvider>(context, listen: false).currentAddress;
    int electionIndex = await Provider.of<MetaMaskProvider>(context, listen: false).createElection(title.text);

    final election = Election(
      title: title.text,
      description: des.text,
      startDate: _startDate ?? DateTime.now(),
      endDate: _endDate ?? DateTime.now(),
      creator: creator,
      creatorWallet: creatorWallet,
      electionIndex: electionIndex,
      candidates: [], // Assuming no candidates for now
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
        isVotingOpen: true
    );

    await createElection(election);
    widget.onUpdateElections();
  }

  Future<void> createElection(Election election) async {
    final url = Uri.parse('http://localhost:3000/api/v1/election'); // Adjust URL as needed
    String token = Provider.of<MetaMaskProvider>(context, listen: false).authResponse!.token;

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(election.toJson()),
      );

      if (response.statusCode == 201) {
        print('Election created successfully: ${response.body}');
      } else {
        print('Failed to create election: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to create election: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error creating election: $e');
      throw e;
    }
  }

  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = isStartDate ? _startDate ?? now : _endDate ?? now;
    final DateTime firstDate = DateTime(now.year - 100);
    final DateTime lastDate = DateTime(now.year + 100);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      if (isStartDate) {
        setState(() {
          _startDate = pickedDate;
        });
      } else {
        setState(() {
          _endDate = pickedDate;
        });
      }
    }
  }

  Future<void> _selectTime(BuildContext context, {required bool isStartTime}) async {
    final TimeOfDay initialTime = isStartTime ? _startTime ?? TimeOfDay.now() : _endTime ?? TimeOfDay.now();

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      if (isStartTime) {
        setState(() {
          _startTime = pickedTime;
        });
      } else {
        setState(() {
          _endTime = pickedTime;
        });
      }
    }
  }
}
