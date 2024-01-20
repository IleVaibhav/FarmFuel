import 'package:user/authentication/select_lang.dart';
import 'package:user/authentication/sign_in_screen.dart';
import 'package:user/common_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUP extends StatefulWidget {
  const SignUP({super.key});

  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {

  bool hidePassword = true;
  bool isLoading = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference storeUser = FirebaseDatabase.instance.ref('User');

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
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressController.dispose();
    passController.dispose();
    confirmPassController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.transparent,
      ),

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
                const SizedBox(height: 20),
                Image.asset("assets/animated_icon/loading.gif", height: 100, width: 100)
              ],
            )
            : Container(
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              width: 350,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification notification) {
                  notification.disallowIndicator();
                  return true;
                },
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "SignUP / CREATE ACCOUNT here",
                          style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20)
                        )
                    ),

                    Divider(
                      color: Colors.green.shade900,
                      thickness: 0.2,
                    ),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          customTextFormField(
                            controller: nameController,
                            title: "NAME",
                            obsecure: false,
                            errorText: "Please enter Name",
                            icon: Icons.man,
                            titleColor: Colors.green.shade900,
                            keyBoard: TextInputType.text
                          ),

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
                            controller: mobileController,
                            title: "CONTACT NUMBER",
                            obsecure: false,
                            errorText: "Please enter Contact Number",
                            icon: Icons.call,
                            titleColor: Colors.green.shade900,
                            keyBoard: TextInputType.phone
                          ),

                          const SizedBox(height: 20),
                          customTextFormField(
                            controller: addressController,
                            title: "ADDRESS",
                            obsecure: false,
                            errorText: "Please enter Address",
                            icon: Icons.home,
                            titleColor: Colors.green.shade900,
                            keyBoard: null,
                            maxLines: 5
                          ),

                          const SizedBox(height: 20),
                          customTextFormField(
                            controller: passController,
                            title: "PASSWORD",
                            obsecure: hidePassword,
                            errorText: "Please enter Password",
                            icon: hidePassword ? Icons.lock : Icons.lock_open,
                            titleColor: Colors.black,
                            keyBoard: TextInputType.text
                          ),

                          const SizedBox(height: 20),
                          customTextFormField(
                            controller: confirmPassController,
                            title: "CONFIRM PASSWORD",
                            obsecure: hidePassword,
                            errorText: "Please enter Password",
                            icon: hidePassword ? Icons.lock : Icons.lock_open,
                            titleColor: darkGreen,
                            keyBoard: TextInputType.text
                          ),
                        ],
                      )
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                            )
                        ),
                      ],
                    ),

                    // const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignIN())
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.green.shade900,
                                backgroundColor: Colors.blue.shade50,
                                shadowColor: Colors.green.shade900,
                                elevation: 10,
                                fixedSize: const Size.fromWidth(150),
                                side: BorderSide(color: darkGreen, width: 0.3)
                            ),
                            child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.green.shade900
                                )
                            )
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shadowColor: Colors.blue.shade200,
                                elevation: 10,
                                backgroundColor: darkGreen,
                                fixedSize: const Size.fromWidth(180),
                                side: BorderSide(color: Colors.blue.shade50, width: 0.3)
                            ),
                            onPressed: () {
                              if(_formKey.currentState!.validate()) {
                                setState(() {isLoading = false;});
                                if(!(passController.text.toString() == confirmPassController.text.toString())) {
                                    customToastMsg("Passwords not match");
                                }
                                else {
                                  _auth.createUserWithEmailAndPassword(
                                      email: emailController.text.toString(),
                                      password: passController.text.toString()
                                  ).then((value) {
                                    setState(() {isLoading = true;});
                                    storeUser.child(_auth.currentUser!.uid).set({
                                      'e-mail' : emailController.text.toString(),
                                      'mobile' : mobileController.text.toString(),
                                      'address' : addressController.text.toString(),
                                      'name' : nameController.text.toString(),
                                      'wishlist_count' : 0,
                                      'order_count' : 0,
                                      'user_id' : _auth.currentUser!.uid,
                                      'languageCode' : 'eng',
                                      'languageName': 'English',
                                      'password' : passController.text.toString(),
                                      'image' : "https://firebasestorage.googleapis.com/v0/b/agroshop-c67e0.appspot.com/o/default_images%2Ffarmer.jpg?alt=media&token=b7ab444b-4600-4c51-a8dc-7b5c5944308c".toString()
                                    }).then((value) {
                                      setState(() {isLoading = true;});
                                      customToastMsg("Account created successfully for user ${_auth.currentUser!.email}");
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (
                                              context) => const SelectLang())
                                      );
                                    }).onError((error, stackTrace) {
                                      setState(() {isLoading = false;});
                                      customToastMsg(error.toString());
                                    });
                                  }).onError((error, stackTrace) {
                                    setState(() {isLoading = false;});
                                    customToastMsg(error.toString());
                                  });
                                }
                              }
                            },
                            child: const Text(
                                "Create Account",
                                style: TextStyle(fontSize: 17)
                            )
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          )
      ),

    );
  }
}