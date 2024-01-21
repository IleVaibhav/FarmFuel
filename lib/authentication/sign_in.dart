import 'forgot_password.dart';
import 'seller_details.dart';
import 'package:seller/common_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final GlobalKey<FormState> _formKey = GlobalKey();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference sellerDetails = FirebaseDatabase.instance.ref('Seller');

  final mailController = TextEditingController();
  final passController = TextEditingController();

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: backGroundTheme(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      customTextFormField(
                          controller: mailController,
                          onTap: () {},
                          obsecureText: false,
                          keyboardType: TextInputType.text,
                          hintText: "enter your mail here . . .",
                          labelText: "mail . . .",
                          errorText: "Please enter email . . .",
                          prefixIcon: Icons.mail_rounded
                      ),
                      const SizedBox(height: 20),
                      customTextFormField(
                          controller: passController,
                          onTap: () {},
                          obsecureText: hidePassword,
                          keyboardType: TextInputType.text,
                          hintText: "enter your password here . . .",
                          labelText: "password . . .",
                          errorText: "Please enter password . . .",
                          prefixIcon: hidePassword ? Icons.lock : Icons.lock_open_rounded
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                            _auth.sendPasswordResetEmail(
                                email: mailController.text
                            ).then((value) {
                                customToastMsg("We sent you password reset link on mail, Please check");
                            }).onError((error, stackTrace) {
                                if(mailController.text.toString().isEmpty) {
                                    customToastMsg("Please enter email ID");
                                }
                                else {
                                    customToastMsg(error.toString());
                                }
                            });
                        },
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(Colors.black),
                            overlayColor: MaterialStateProperty.all(Colors.transparent)
                        ),
                        child: const Text("Forgot Password")
                    ),
                    TextButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.transparent)
                        ),
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        child: Text(
                            hidePassword ? "Show Password" : "Hide Password",
                            style: TextStyle(
                                color: Colors.blue.shade900,
                                decoration: TextDecoration.underline,
                                decorationThickness: 0.5
                            )
                        )
                    )
                  ],
                ),

                ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()) {
                        _auth.signInWithEmailAndPassword(
                            email: mailController.text.toString(),
                            password: passController.text.toString()
                        ).then((value) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AddSellerDetails()
                                )
                            );
                            sellerDetails.child(_auth.currentUser!.uid).update({
                                'email': mailController.text.toString(),
                                'password': passController.text.toString()
                            });
                            customToastMsg("${_auth.currentUser!.email} Logged in successfully");
                        }).onError((error, stackTrace) {
                            customToastMsg(error.toString());
                        });
                      }
                    },
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(const Size.fromWidth(180)),
                        backgroundColor: MaterialStateProperty.all(Colors.purple.shade900)
                    ),
                    child: const Text(
                      "Log in",
                      style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                    )
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                        onPressed: () async {
                          await launchUrl(
                            Uri.parse('mailto:vaibhavile@gmail.com'),
                            mode: LaunchMode.externalApplication,
                          );
                          // launch();
                        },
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.transparent)
                        ),
                        child: Text(
                            "Contact Admin",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple.shade900,
                                decoration: TextDecoration.underline,
                                decorationThickness: 0.5
                            )
                        )
                    )
                  ],
                )

              ],
            ),
          ),
      ),
    );
  }
}

