import 'dart:async';
import 'package:user/authentication/sign_in_screen.dart';
import 'package:user/common_widget.dart';
import 'package:user/top_navigation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {

    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    super.initState();
    Timer(
      const Duration(seconds: 1),
      () {
        if(user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Navigation())
          );
        }
        else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignIN())
          );
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade500,
              Colors.blue.shade200,
              Colors.white,
            ]
          )
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                "assets/splash_screen/bg0.png",
                width: MediaQuery.of(context).size.width / 2.3
              )
            ),
            Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                "assets/splash_screen/bg1.png",
                width: MediaQuery.of(context).size.width / 2.3
              )
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/splash_screen/app_logo.png", height: 150, width: 150),
                  const SizedBox(height: 10),
                  Text(
                    "FarmFuel",
                    style: TextStyle(
                      color: darkGreen,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Designed for Farmers",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500
                    )
                  ),
                  const SizedBox(height: 150)
                ]
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset("assets/splash_screen/bg2.png")
            )
          ],
        ),
      ),
    );
  }
}
