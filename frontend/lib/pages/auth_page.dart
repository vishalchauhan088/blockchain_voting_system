import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nex_vote/connect_button.dart';
import 'package:nex_vote/consts/conts.dart';
import 'package:nex_vote/metamask_provider.dart';
import 'package:nex_vote/model/auth_model.dart';
import 'package:nex_vote/provider/api.dart';
import 'package:provider/provider.dart'; // Ensure you have this import

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true; // Track whether to show login or signup

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController(); // New field for email
  final TextEditingController nameController = TextEditingController(); // New field for name

  void toggleView() {
    setState(() {
      isLogin = !isLogin; // Toggle between login and signup
    });
  }

  Future<void> handleSubmit() async {
    String username = usernameController.text;
    String password = passwordController.text;
    String email = emailController.text; // Get email input
    String name = nameController.text; // Get name input

    final provider = Provider.of<MetaMaskProvider>(context, listen: false);

    try {
      if (isLogin) {
        // Call login API
        AuthResponse authResponse = await ApiService().login(username, password);
        // Store the token in the provider
        provider.authResponse = authResponse;
        provider.notifyListeners(); // Notify listeners about the change

        // Navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => ButtonCon()),
        );
      } else {
        // Call signup API with email and name
        await ApiService().signup(username, password, email, name);
        // If signup is successful, call login API
        AuthResponse authResponse = await ApiService().login(username, password);
        // Store the token in the provider
        provider.authResponse = authResponse;
        provider.notifyListeners(); // Notify listeners about the change

        // Navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => ButtonCon()),
        );
      }
    } catch (e) {
      print('Error: $e');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(isLogin ? "Login" : "Sign Up"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isLogin ? "Welcome Back!" : "Create Account",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                    if (!isLogin) ...[
                      SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeNavColors.selectedIconBox,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isLogin ? "Login" : "Sign Up",
                        style: GoogleFonts.openSans(
                          color: ThemeNavColors.backgroundColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: toggleView,
                      child: Text(
                        isLogin ? "Don't have an account? Sign up" : "Already have an account? Login",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
