import 'package:user/authentication/forgot_password.dart';
import 'package:user/authentication/sign_up_screen.dart';
import 'package:user/common_widget.dart';
import 'package:user/top_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SignIN extends StatefulWidget {
  const SignIN({super.key});

  @override
  State<SignIN> createState() => _SignINState();
}

class _SignINState extends State<SignIN> {

  bool hidePassword = true;
  bool isLoading = false;

  final DatabaseReference userDetails = FirebaseDatabase.instance.ref('User');
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final emailController = TextEditingController();
  final passController = TextEditingController();

  void _showPass() {
    setState(() {
      if(hidePassword) {
        hidePassword = false;
      } else {
        hidePassword = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,

      body: backGroundTheme(
          child: Center(
            child: isLoading ?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                    "Please wait . . .",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    )
                ),
                const SizedBox(height: 10),
                CircularProgressIndicator(
                  color: darkGreen,
                ),
              ],
            )
            : SingleChildScrollView(
              child: SizedBox(
                width: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                        child: Text(
                          "SignIN here",
                          style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20)
                        )
                    ),
                    Divider(
                      color: Colors.green.shade900,
                      thickness: 0.1,
                    ),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          customTextFormField(
                            controller: emailController,
                            title: "e-MAIL",
                            obsecure: false,
                            errorText: "Please enter e-Mail",
                            icon: Icons.email,
                            titleColor: Colors.green.shade900,
                            keyBoard: TextInputType.emailAddress
                          ),

                          const SizedBox(height: 20),
                          customTextFormField(
                            controller: passController,
                            title: "CONFIRM PASSWORD",
                            obsecure: hidePassword,
                            errorText: "Please enter Password",
                            icon: hidePassword ? Icons.lock : Icons.lock_open,
                            titleColor: Colors.green.shade900,
                            keyBoard: TextInputType.text
                          ),
                        ],
                      )
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ForgotPassword())
                              );
                            },
                            style: ButtonStyle(
                                overlayColor: MaterialStatePropertyAll(
                                    Colors.green.shade900.withOpacity(0.1)
                                )
                            ),
                            child: const Text(
                                "Forgot Password",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                )
                            ),
                        ),

                        TextButton(
                          onPressed: _showPass,
                          style: ButtonStyle(
                              overlayColor: MaterialStatePropertyAll(
                                  Colors.green.shade900.withOpacity(0.1)
                              )
                          ),
                          child: Text(
                              "${hidePassword ? "Show" : "Hide"} Password",
                              style: TextStyle(
                                  color: Colors.blue.shade900,
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 0.5
                              )
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.green.shade900,
                            backgroundColor: Colors.blue.shade50,
                            shadowColor: Colors.green.shade900,
                            elevation: 10,
                            fixedSize: const Size.fromWidth(150),
                            side: BorderSide(color: darkGreen, width: 0.3)
                        ),
                        onPressed: () {
                          if(_formKey.currentState!.validate()) {
                            setState(() {isLoading = false;});
                            _auth.signInWithEmailAndPassword(
                                email: emailController.text.toString(),
                                password: passController.text.toString()
                            ).then((value) {
                              setState(() {isLoading = true;});
                              customToastMsg("${value.user!.email} Logged in Successfully");
                              userDetails.child(_auth.currentUser!.uid).update({
                                  'password': passController.text.toString()
                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Navigation())
                              );
                            }).onError((error, stackTrace) {
                                setState(() {isLoading = false;});
                                customToastMsg(error.toString());
                            });
                          }
                        },
                        child: Text(
                            "SignIN",
                            style: TextStyle(fontSize: 17, color: Colors.green.shade900)
                        )
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account ?"),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignUP())
                              );
                            },
                            style: ButtonStyle(
                                overlayColor: MaterialStatePropertyAll(
                                    Colors.green.shade900.withOpacity(0.1)
                                )
                            ),
                            child: Text(
                                "Sign up",
                                style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16
                                )
                            )
                        ),
                      ],
                    )

                  ],
                ),
              ),
            ),
          )
      ),

    );
  }
}