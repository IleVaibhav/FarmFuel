import 'package:seller/authentication/seller_details.dart';
import 'package:seller/authentication/sign_in.dart';
import 'package:seller/common_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference sellerDetails = FirebaseDatabase.instance.ref('Seller');

  final mailController = TextEditingController();
  final passController = TextEditingController();

  bool isAuthenticatePressed = false;
  bool hidePassword = true;

  @override
  void dispose() {
      mailController.dispose();
      passController.dispose();
      super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
              InkWell(
                  child: Image.asset("assets/log_out.png", width: 30),
                  onTap: () {
                      _auth.signOut().then((value) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const SignIn()),
                              (Route route) => false
                          );
                      }).onError((error, stackTrace) {
                          customToastMsg(error.toString());
                      });
                  },
              ),
              const SizedBox(width: 15)
          ],
      ),
      
      body: backGroundTheme(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: StreamBuilder(
            stream: sellerDetails.child(_auth.currentUser!.uid).onValue,
            builder: (context, AsyncSnapshot snapshot) {
                if(!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                            color: Colors.purple.shade900,
                        ),
                    );
                }
                else if (snapshot.hasData) {
                    Map<dynamic, dynamic> sellerData = snapshot.data!.snapshot.value;
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Container(
                                height: 170,
                                width: 170,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.transparent,
                                    image: DecorationImage(image: NetworkImage(sellerData['shopImg']))
                                ),
                            ),
                            const SizedBox(height: 5),
                            Divider(color: Colors.purple.shade900, thickness: 0.2, height: 10),
                            Text(sellerData['name'].toString(), style: TextStyle(fontSize: 20, color: Colors.purple.shade900, fontWeight: FontWeight.bold)),
                            Divider(color: Colors.purple.shade900, thickness: 0.2, height: 10),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.purple.shade900),
                                        fixedSize: MaterialStateProperty.all(const Size.fromWidth(150))
                                    ),
                                    onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const AddSellerDetails())
                                        );
                                    },
                                    child: const Text("Update", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                                  ),

                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.purple.shade900),
                                          fixedSize: MaterialStateProperty.all(const Size.fromWidth(150))
                                      ),
                                      onPressed: () {
                                          mailController.clear();
                                          passController.clear();
                                          hidePassword = true;
                                          isAuthenticatePressed = false;

                                          showDialog(
                                              context: context,
                                              builder: (context) => StatefulBuilder(
                                                  builder: (context, setState) {
                                                      return AlertDialog(
                                                          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                                          content: SizedBox(
                                                              height: 220,
                                                              child: Column(
                                                                  children: [
                                                                      const Text("To delete Account First Authenticate Yourself"),
                                                                      const SizedBox(height: 15),
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

                                                                      Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                              TextButton(
                                                                                  onPressed: () {
                                                                                      _auth.sendPasswordResetEmail(
                                                                                          email: _auth.currentUser!.email.toString()
                                                                                      ).then((value) {
                                                                                          customToastMsg("We sent you password reset link on mail, Please check");
                                                                                      }).onError((error, stackTrace) {
                                                                                          customToastMsg(error.toString());
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
                                                                  ],
                                                              ),
                                                          ),
                                                          actionsAlignment: MainAxisAlignment.center,
                                                          actions: [
                                                              OutlinedButton(
                                                                  onPressed: () {
                                                                      if(mailController.text.isEmpty || passController.text.isEmpty) {
                                                                          customToastMsg("Please submit all fields");
                                                                      }
                                                                      else if(isAuthenticatePressed) {
                                                                          final uid = _auth.currentUser!.uid;
                                                                          FirebaseDatabase.instance.ref('Seller').child(uid.toString()).remove();
                                                                          FirebaseDatabase.instance.ref('User').child(uid.toString()).remove();
                                                                          _auth.currentUser!.delete();
                                                                          Navigator.pop(context);
                                                                          Navigator.of(context).pushAndRemoveUntil(
                                                                              MaterialPageRoute(builder: (context) => const SignIn()),
                                                                              (Route route) => false
                                                                          );
                                                                      }
                                                                      else if(mailController.text.toString() == _auth.currentUser!.email.toString()) {
                                                                          _auth.signInWithEmailAndPassword(
                                                                              email: mailController.text.toString(),
                                                                              password: passController.text.toString()
                                                                          ).then((value) {
                                                                              setState(() {
                                                                                  isAuthenticatePressed = !isAuthenticatePressed;
                                                                              });
                                                                              customToastMsg("Authenticated Successfully");
                                                                          }).onError((error, stackTrace) {customToastMsg(error.toString());});
                                                                      }
                                                                  },
                                                                  style: OutlinedButton.styleFrom(
                                                                      side: BorderSide(color: Colors.purple.shade900)
                                                                  ),
                                                                  child: Text(isAuthenticatePressed ? "Delete Account" : "Authenticate", style: TextStyle(color: Colors.purple.shade900, fontSize: 16),)
                                                              )
                                                          ],
                                                      );
                                                  }
                                              ),
                                          );
                                      },
                                      child: const Text("Delete", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                                  ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Divider(color: Colors.purple.shade900, thickness: 0.2, height: 10),
                            const SizedBox(height: 5),
                            Text(sellerData['email'].toString(), style: TextStyle(fontSize: 20, color: Colors.purple.shade900, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text(sellerData['shop_name'].toString(), style: TextStyle(fontSize: 20, color: Colors.purple.shade900, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text(sellerData['shop_address'].toString(), style: TextStyle(fontSize: 20, color: Colors.purple.shade900, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text(sellerData['shop_contact'].toString(), style: TextStyle(fontSize: 20, color: Colors.purple.shade900, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Divider(color: Colors.purple.shade900, thickness: 0.2, height: 10),

                        ],
                    );
                }
                else {
                    return Center(
                        child: Text(
                            "Something Went Wrong",
                            style: TextStyle(color: Colors.purple.shade900, fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                    );
                }
            },

          ),
        )
      ),
    );
  }
}