import 'package:user/account/edit_profile.dart';
import 'package:user/authentication/forgot_password.dart';
import 'package:user/authentication/sign_up_screen.dart';
import 'package:user/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthenticateUser extends StatefulWidget {
  const AuthenticateUser({Key? key}) : super(key: key);

  @override
  State<AuthenticateUser> createState() => _AuthenticateUserState();
}

class _AuthenticateUserState extends State<AuthenticateUser> {

  bool showOtherButton = false;
  bool hidePassword = true;

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
      body: backGroundTheme(
          child: Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

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
                                title: "PASSWORD",
                                obsecure: hidePassword,
                                errorText: "Please enter Password",
                                icon: hidePassword ? Icons.lock : Icons.lock_open,
                                titleColor: Colors.green.shade900,
                                keyBoard: TextInputType.text
                            ),
                          ],
                        )
                    ),

                    !showOtherButton ? Row(
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
                    ) : Container(),

                    const SizedBox(height: 15),

                    !showOtherButton ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.green.shade900,
                            backgroundColor: Colors.blue.shade50,
                            elevation: 10,
                            fixedSize: const Size.fromWidth(150)
                        ),
                        onPressed: () {
                          if(_formKey.currentState!.validate() && _auth.currentUser!.email.toString() == emailController.text.toString()) {
                            setState(() {
                              showOtherButton = false;
                            });
                            _auth.signInWithEmailAndPassword(
                                email: emailController.text.toString(),
                                password: passController.text.toString()
                            ).then((value) {
                              setState(() {
                                showOtherButton = true;
                              });
                              customToastMsg("${value.user!.email} Authenticated Successfully");
                              userDetails.child(_auth.currentUser!.uid).update({
                                'password': passController.text.toString()
                              });
                            }).onError((error, stackTrace) {
                              setState(() {
                                showOtherButton = false;
                              });
                              customToastMsg("Please enter correct email and password");
                            });
                          }
                        },
                        child: Text(
                            "Authenticate",
                            style: TextStyle(fontSize: 17, color: Colors.green.shade900)
                        )
                    ) : Container(),

                  showOtherButton ? Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkGreen
                              ),
                              onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: lightBlue,
                                          alignment: Alignment.center,
                                          scrollable: true,
                                          elevation: 10,
                                          content: const Text(
                                              "Are you sure want to delete your account ?",
                                              style: TextStyle(fontWeight: FontWeight.bold)
                                          ),
                                          actions: [
                                            TextButton(
                                                style: TextButton.styleFrom(foregroundColor: Colors.white),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                    "Cancel",
                                                    style: TextStyle(fontSize: 16, color: darkGreen),
                                                )
                                            ),

                                            TextButton(
                                                style: TextButton.styleFrom(foregroundColor: Colors.white),
                                                onPressed: () {
                                                  userDetails.child(_auth.currentUser!.uid).remove().onError((error, stackTrace) {customToastMsg("Can't delete your account, Try again");});
                                                  _auth.currentUser!.delete().then((value) {
                                                    customToastMsg("Your account deleted successfully");
                                                    Navigator.of(context).pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                            builder: (context) => const SignUP()
                                                        ),
                                                        (Route route) => false
                                                    );
                                                  }).onError((error, stackTrace) {
                                                    customToastMsg(error.toString());
                                                  });
                                                },
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(fontSize: 16, color: Colors.red.shade900),
                                                )
                                            ),
                                          ],
                                        );
                                      },
                                  );
                              },
                              child: Text(
                                  "Delete Account",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: lightBlue
                                  )
                              ),
                          ),

                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkGreen
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const EditProfile())
                                );
                              },
                            child: Text(
                                "Update Account",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: lightBlue

                                )
                            )
                          ),
                        ],
                      ),
                  ) : Container(),

                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}
