import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nex_vote/model/auth_model.dart';
import 'package:nex_vote/model/proposal_model.dart';
import 'package:nex_vote/model/vote_model.dart';

class ApiService {
  final String baseUrl='http://localhost:3000';
  final String authUrl = '/api/v1/auth';
  final String electionUrl = '/api/v1/election';
  final String userActivityUrl = '/api/v1/userActivity';


  Future<void> signup(String username, String password, String email, String name) async {
    final url = Uri.parse('$baseUrl$authUrl/signup');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email, // New email field
        'name': name,   // New name field
      }),
    );

    if (response.statusCode == 201) {
      print('User created successfully');
    } else {
      print('Signup failed: ${response.body}');
      throw Exception('Failed to signup: ${response.body}');
    }
  }


  Future<AuthResponse> login(String username, String password) async {
    final url = Uri.parse('http://localhost:3000/api/v1/auth/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      AuthResponse auth = AuthResponse.fromJson(responseData);
      return auth;
    } else {
      print('Login failed: ${response.body}');
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<List<Election>> fetchElections(String token) async {
    // final token = Provider.of<MetaMaskProvider>(context, listen: false).authResponse?.token;
    final url = Uri.parse('$baseUrl$electionUrl/');

    try {
      final response = await http.get(url,
        headers: {
          'Authorization': 'Bearer $token', // Add the Bearer token here
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((json) => Election.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load elections: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching elections: $e');
      throw e;
    }
  }
  Future<void> createElection(Election election, String token) async {
    final url = Uri.parse("$baseUrl$electionUrl");

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
  }
  Future<Candidate?> addCandidateToElection(String electionId, Candidate candidate,String token) async {
    final String apiUrl = '$baseUrl$electionUrl/$electionId/candidate';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(candidate.toJson()),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final addedCandidate = Candidate.fromJson(data['candidate']); // Use fromJson for response
        print('Response: ${data['message']}');
        print('Candidate added: ${addedCandidate.name}, Symbol: ${addedCandidate.symbol}');
        return addedCandidate;
      } else {
        print('Failed to add candidate: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }

  Future<void> castVote(String electionId, String candidateId, String transactionHash, String token) async {
    final url = Uri.parse('$baseUrl/api/v1/userActivity/$electionId/vote');

    final body = jsonEncode({
      'candidateId': candidateId,
      'transactionHash': transactionHash,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        // Successfully recorded the vote
        print('Vote recorded successfully: ${response.body}');
      } else {
        // Handle error response
        print('Failed to record vote: ${response.body}');
        throw Exception('Failed to record vote: ${response.body}');
      }
    } catch (error) {
      print('Error occurred while recording vote: $error');
      throw Exception('Error occurred while recording vote: $error');
    }
  }

  Future<List<ElectionVote>> fetchUserVotes(String token) async {
    final url = Uri.parse('$baseUrl/api/v1/userActivity/my-votes');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((vote) => ElectionVote.fromJson(vote))
            .toList();
      } else {
        throw Exception('Failed to load user votes');
      }
    } catch (e) {
      print('Error: $e');
      return []; // Return an empty list on error
    }
  }

  Future<void> closeElection(String electionId, String token) async {
    final url = Uri.parse('$baseUrl$electionUrl/close-election/$electionId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Election closed successfully: ${data['message']}');
      } else if (response.statusCode == 404) {
        print('Error: Election not found');
      } else if (response.statusCode == 400) {
        print('Error: ${jsonDecode(response.body)['message']}');
      } else {
        print('Error closing election: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error making request to close election: $e');
    }
  }

}
