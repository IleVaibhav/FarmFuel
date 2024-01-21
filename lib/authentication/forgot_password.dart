import 'package:seller/authentication/sign_in.dart';
import 'package:seller/common_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: backGroundTheme(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    customTextFormField(
                        controller: mailController,
                        onTap: () {},
                        obsecureText: false,
                        keyboardType: TextInputType.emailAddress,
                        hintText: "enter mail ID here . . .",
                        labelText: "mail ID . . .",
                        errorText: "Please enter mail ID . . .",
                        prefixIcon: Icons.mail_rounded
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                              _auth.sendPasswordResetEmail(
                                  email: mailController.text
                              ).then((value) {
                                  customToastMsg("We sent you password reset link on mail, Please check");
                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(
                                    builder: (context) => const SignIn(),
                                  ));
                              }).onError((error, stackTrace) {
                                  customToastMsg(error.toString());
                              });
                        },
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(const Size.fromWidth(180)),
                            backgroundColor: MaterialStateProperty.all(Colors.purple.shade900)
                        ),
                        child: const Text(
                          "Forgot Password",
                          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                        )
                    ),
                  ],
              ),
            )
        ),
    );
  }
}
