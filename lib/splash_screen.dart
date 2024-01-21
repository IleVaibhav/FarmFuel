import 'dart:async';
import 'common_widget.dart';
import 'package:seller/authentication/sign_in.dart';
import 'navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 1),
        () {
          if(_auth.currentUser != null) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavigation())
            );
          }
          else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignIn())
            );
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: backGroundTheme(
            child: Column(
                children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Image.asset(
                                    "assets/logo_splash_screen.png",
                                    height: 100,
                                    width: 100
                                ),
                                const SizedBox(height: 20),
                                Text(
                                    "FarmFuel",
                                    style: TextStyle(
                                        color: Colors.purple.shade900,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                                Text(
                                    "Designed for Seller's",
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500
                                    )
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height / 4)
                            ],
                        ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Text(
                            "Designed by : V.V",
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                                fontWeight: FontWeight.w500
                            ),
                        ),
                    )
                ],
            )
        ),
    );
  }
}
