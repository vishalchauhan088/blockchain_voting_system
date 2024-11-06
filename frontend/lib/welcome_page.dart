import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nex_vote/connect_button.dart';
import 'package:nex_vote/nav_screen.dart';
import 'package:nex_vote/pages/auth_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/welcome_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Main Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // App Logo
                  const Icon(
                    Icons.check_circle_outline,
                    size: 120,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  // Welcome Text
                  Text(
                    'Welcome to NexVote!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Introduction Text
                  Text(
                    'NexVote is a cutting-edge blockchain-based voting system ensuring secure and transparent elections. Explore your voting history, create proposals, and manage your votes with confidence.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Start Button
                  ElevatedButton(
                    onPressed: () {

                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (BuildContext context) => ButtonCon()),
                      // );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => AuthPage()),
                      );

                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (BuildContext context) => NavigationScreen()),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black.withOpacity(0.2),
                    ),
                    child: Text(
                      'Get Started',
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Footer Text
                  Text(
                    'Powered by Blockchain Technology',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
