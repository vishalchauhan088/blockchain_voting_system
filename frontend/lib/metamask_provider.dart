import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web3/ethereum.dart';
import 'package:flutter_web3/flutter_web3.dart' as flutter_web3;
import 'package:nex_vote/model/auth_model.dart';
import 'package:nex_vote/model/proposal_model.dart';
import 'package:web3dart/web3dart.dart' as web3dart;
import 'package:http/http.dart';

class MetaMaskProvider extends ChangeNotifier {
  String currentAddress = '';
  String account = '';
  int? currentChain;
  Client httpClient = Client();
  late web3dart.Web3Client ethClient;

  // Replace with your smart contract address
  final String contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';
  // Replace with your private key
  final String privateKey = 'ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80';

  late web3dart.DeployedContract contract;

  bool get isEnabled => flutter_web3.ethereum != null;
  bool get isConnected => isEnabled && currentAddress.isNotEmpty;

  // Fields for authentication response
  AuthResponse? authResponse;

  MetaMaskProvider() {
    String url = 'http://127.0.0.1:8545/';
    ethClient = web3dart.Web3Client(url, httpClient);
    print('Web3Client initialized with URL: $url');

    loadContract();
  }

  Future<void> loadContract() async {
    try {
      final String abiString = await rootBundle.loadString('assets/abi.json');
      // print('ABI loaded successfully: $abiString');

      // Initialize the contract
      contract = web3dart.DeployedContract(
        web3dart.ContractAbi.fromJson(abiString, 'SimpleVotingSystem'),
        web3dart.EthereumAddress.fromHex(contractAddress),
      );
      print('Contract initialized with address: $contractAddress');

    } catch (e) {
      print('Error loading contract: $e');
    }
  }

  Future<void> connect(Function onSuccess) async {
    if (isEnabled) {
      try {
        final List<String> accs = await flutter_web3.ethereum!.requestAccount();
        print('Accounts retrieved: $accs');

        if (accs.isNotEmpty) {
          account = accs.first;
          currentAddress = account;
          currentChain = await flutter_web3.ethereum!.getChainId();
          print('Connected to account: $account on chain ID: $currentChain');

          await loadContract();
          notifyListeners();
          onSuccess();
        }
      } catch (e) {
        print('Error connecting to MetaMask: $e');
      }
    } else {
      print('MetaMask is not enabled');
    }
  }

  Future<void> callContractFunction(String functionName, List<dynamic> params) async {
    if (!isConnected) {
      print('Not connected to MetaMask');
      return;
    }

    try {
      final contractFunction = contract.function(functionName);
      print('Calling contract function: $functionName with params: $params');

      final result = await ethClient.call(
        contract: contract,
        function: contractFunction,
        params: params,
      );

      print('Contract function result: $result');
    } catch (e) {
      print('Error calling contract function: $e');
    }
  }

  Future<int> getElectionCount() async {
    if (!isConnected) {
      throw Exception('Not connected to MetaMask');
    }

    try {
      final result = await ethClient.call(
        contract: contract,
        function: contract.function('electionCount'),
        params: [],
      );

      print('Raw result from candidateCount: $result');

      if (result is List && result.isNotEmpty) {
        BigInt candidateCountBigInt = result[0] as BigInt;
        return candidateCountBigInt.toInt();
      } else {
        throw Exception('Unexpected result format: $result');
      }
    } catch (e) {
      print('Error fetching candidate count: $e');
      throw e;
    }
  }


  Future<String> callFunction(String funcname, List<dynamic> args) async {
    web3dart.EthPrivateKey credentials = web3dart.EthPrivateKey.fromHex(privateKey);

    final ethFunction = contract.function(funcname);
    final result = await ethClient.sendTransaction(
        credentials,
        web3dart.Transaction.callContract(
          contract: contract,
          function: ethFunction,
          parameters: args,
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true);
    return result;
  }

  Future<int> createElection(String name) async {
    // Send the transaction to create the election
    var transactionHash = await callFunction('createElection', [name]);
    print('Election started successfully. Transaction Hash: $transactionHash');

    // To get the election ID returned from the contract, we need to modify callFunction
    // It should return the ID, but currently, it returns a transaction hash.
    // You can listen for the transaction receipt and extract the ID from that.

    // Note: Since we can't capture the return value directly from sendTransaction,
    // we need to check for the receipt to ensure the transaction is confirmed,
    // and then call a function to get the updated election count.

    // Assuming the last election ID is the one just created
    int electionId = await getElectionCount() - 1; // Subtract 1 to get the ID of the new election
    return electionId;
  }


  //
  Future<ContractElectionDetails> addCandidate(int electionId, String name, String symbol) async {
    var response = await callFunction('addCandidate', [BigInt.from(electionId), name, symbol]);
    print('Candidate added successfully $response');

    var electionDetails = await getElectionDetails(electionId);
    print("\n\n$electionDetails\n\n");
    return electionDetails;
  }


  Future<bool> castVote(int electionId, int candidateId) async {
    var response = await callFunction('castVote', [BigInt.from(electionId), BigInt.from(candidateId)]);
    print('Vote cast successfully');

    bool result = await hasVotedInElection(electionId);
    return result;
  }

  Future<bool> closeVoting(int electionId) async {
    var response = await callFunction('closeVoting', [BigInt.from(electionId)]);
    print('Voting closed successfully $response');

    ContractElectionDetails electionDetails = await getElectionDetails(electionId);
    return electionDetails.isVotingOpen ;
    // return response;
  }

  Future<List<ContractCandidate>> getResults(int electionId) async {
    if (!isConnected) {
      throw Exception('Not connected to MetaMask');
    }

    try {
      print("start");
      final result = await ethClient.call(
        contract: contract,
        function: contract.function('getResults'),
        params: [BigInt.from(electionId)],
      );
      print("end");

      print('Results fetched: $result');

      // The result structure is [[[name, symbol, voteCount], ...]]
      List<List<dynamic>> candidatesData = List<List<dynamic>>.from(result[0]);

      // Convert the nested lists to Candidate models
      List<ContractCandidate> candidates = candidatesData.map((candidateData) {
        return ContractCandidate.fromList(candidateData);
      }).toList();

      return candidates;
    } catch (e) {
      print('Error fetching results: $e');
      throw e;
    }
  }


  Future<ContractElectionDetails> getElectionDetails(int electionId) async {
    if (!isConnected) {
      throw Exception('Not connected to MetaMask');
    }

    try {
      print("started");
      final result = await ethClient.call(
        contract: contract,
        function: contract.function('getElectionDetails'),
        params: [BigInt.from(electionId)],
      );
      print("end");
      print('Election details fetched: $result');

      return ContractElectionDetails.fromList(result);
    } catch (e) {
      print('Error fetching election details: $e');
      throw e;
    }
  }


  Future<bool> hasVotedInElection(int electionId) async {
    if (!isConnected) {
      throw Exception('Not connected to MetaMask');
    }

    try {
      final result = await ethClient.call(
        contract: contract,
        function: contract.function('hasVotedInElection'),
        params: [BigInt.from(electionId),  web3dart.EthereumAddress.fromHex(currentAddress)],
      );

      return result[0] as bool;
    } catch (e) {
      print('Error checking if has voted: $e');
      throw e;
    }
  }

  Future<List<dynamic>> getElections() async {
    if (!isConnected) {
      throw Exception('Not connected to MetaMask');
    }

    try {
      int electionCount = await getElectionCount();
      List<dynamic> elections = [];

      for (int i = 0; i < electionCount; i++) {
        var details = await getElectionDetails(i);
        elections.add(details);
      }

      return elections;
    } catch (e) {
      print('Error fetching elections: $e');
      throw e;
    }
  }
}
