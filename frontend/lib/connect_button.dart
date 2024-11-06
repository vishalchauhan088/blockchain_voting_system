import 'package:flutter/material.dart';
import 'package:nex_vote/metamask_provider.dart';
import 'package:nex_vote/nav_screen.dart';
import 'package:provider/provider.dart';

class ButtonCon extends StatefulWidget {
  const ButtonCon({super.key});

  @override
  State<ButtonCon> createState() => _ButtonConState();
}

class _ButtonConState extends State<ButtonCon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Consumer<MetaMaskProvider>(
          builder: (context, provider, child) {
            if (provider.isEnabled) {
              if (!provider.isConnected) {
                return ElevatedButton(
                  onPressed: () =>
                      context.read<MetaMaskProvider>().connect(() {
                        // Navigate to NavigationScreen after connecting
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                NavigationScreen(),
                          ),
                        );
                      }),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child:const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wallet),
                      Text(
                        " Connect Wallet",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                );
              }
              else {
                // User is connected
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 15,
                  shadowColor: Colors.black,
                  child: Container(
                    padding: const EdgeInsets.only(left: 15, bottom: 15),
                    height: 270,
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Account",
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(provider.currentAddress),
                      ],
                    ),
                  ),
                );
              }

            } else {
              return const Text(
                'Please use a Web3 supported browser.',
                style: TextStyle(fontSize: 24, color: Colors.white),
              );
            }
          },
        ),
      ),
    );
  }
}
