import 'package:user/common_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: backGroundTheme(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customTextFormField(
                    controller: emailController,
                    title: "e-Mail",
                    obsecure: false,
                    errorText: "Please enter email . . .",
                    icon: Icons.mail,
                    titleColor: Colors.green.shade900,
                    keyBoard: TextInputType.emailAddress
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shadowColor: Colors.blue.shade50,
                        backgroundColor: Colors.green.shade900,
                        fixedSize: const Size.fromWidth(180)
                    ),
                    child: const Text(
                        "Forgot",
                        style: TextStyle(fontSize: 17)
                    ),
                    onPressed: () {
                      _auth.sendPasswordResetEmail(
                          email: emailController.text
                      ).then((value) {
                        customToastMsg("We have send you a email to reset password");
                        Navigator.pop(context);
                      }).onError((error, stackTrace) {
                        customToastMsg(error.toString());
                      });
                    }
                ),
              ],
            ),
          )
      ),
    );
  }
}
