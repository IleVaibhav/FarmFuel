import 'dart:io';
import 'package:user/account/wishlist_screen.dart';
import 'package:user/authentication/select_lang.dart';
import 'package:user/authentication/sign_in_screen.dart';
import 'package:user/common_widget.dart';
import 'authenticate_user.dart';
import '../order/my_orders.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:translator/translator.dart';

class Account extends StatefulWidget {
  final data;
  const Account({Key? key, this.data}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference userDetails = FirebaseDatabase.instance.ref('User');
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  // GoogleTranslator translator = GoogleTranslator();
  // Future<String?> translate({required input}) async {
  //   await translator.translate(input.toString(), to: "mr", from: "en").then((value) {
  //     debugPrint("SUCCESS ${value.text}");
  //     return (value.text);
  //   }).onError((error, stackTrace) {
  //     debugPrint( "FAILED $error");
  //     return (error.toString());
  //   });
  //   return null;
  // }

  File? _image;
  final picker = ImagePicker();

  bool isChangeImageButtonPressed = false;
  bool isLoading = false;

  Future getImageGallery() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80, maxHeight: 200, maxWidth: 200);
    setState(() {
      if(pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: goBack(context),
        actions: [
            TextButton(
                onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectLang()));
                },
                child: Text(selectedLangName, style: const TextStyle(color: Colors.white, fontSize: 18))
            ),
            const SizedBox(width: 10)
        ],
        backgroundColor: Colors.blue.shade500,
      ),
      body: backGroundTheme(
          child: Column(
              children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(userData['image'])
                        ),
                        borderRadius: BorderRadius.circular(100)
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Text(translate(input: "How are you")),
                  // FutureBuilder(
                  //     builder: (context, AsyncSnapshot snapshot) {
                  //         if(snapshot.hasData) {
                  //           return Icon(Icons.watch_later);
                  //         }
                  //         else if(snapshot.hasData) {
                  //           return Text(translate(input: "How are you").toString());
                  //         }
                  //         else {
                  //           return Text("How are you");
                  //         }
                  //     }
                  // ),

                  Text(
                      userData['name'].toString(),
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900
                      )
                  ),

                  SizedBox(
                    width: 250,
                    child: Divider(
                        color: Colors.green.shade900,
                        thickness: 0.2
                    ),
                  ),

                  Text(
                      _auth.currentUser!.email.toString(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.green.shade900
                      )
                  ),

                  SizedBox(
                    width: 250,
                    child: Divider(
                        color: Colors.green.shade900,
                        thickness: 0.2
                    ),
                  ),

                  Text(
                      widget.data['mobile'].toString(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.green.shade900
                      )
                  ),

                  Text(
                      widget.data['address'].toString(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.green.shade900
                      )
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AuthenticateUser()
                                )
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green.shade900,
                            fixedSize: const Size.fromWidth(150),
                            side: BorderSide(
                                color: Colors.green.shade900
                            ),
                            shadowColor: Colors.black,
                          ),
                          child: const Text(
                              "Update / Delete",
                              style: TextStyle(fontSize: 17,color: Colors.black)
                          )
                      ),

                      const SizedBox(width: 20),

                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: darkGreen,
                              fixedSize: const Size.fromWidth(130)
                          ),
                          child: const Text(
                              "Log Out",
                              style: TextStyle(fontSize: 17)
                          ),
                          onPressed: () {
                            _auth.signOut().then((value) {
                              userData = {};
                              selectedLangCode = "eng";
                              selectedLangName = "English";
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const SignIN()
                                  ),
                                  (Route route) => false
                              );
                            }
                            ).onError(
                                (error, stackTrace) {
                                    customToastMsg(error.toString());
                                }
                            );
                          }
                      )
                    ],
                  ),

                  const SizedBox(height: 10),

                  Container(
                      height: 10,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                          color: Colors.green.shade900,
                          thickness: 0.5
                      )
                  ),
                  const SizedBox(height: 10),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 0.2)
                    ),
                    child: InkWell(
                      child: ListTile(
                        leading: Image.asset("assets/animated_icon/heart.gif", width: 30),
                        title: Text(
                            "My Wishlist ",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.w500
                            )
                        ),
                        trailing: Text(
                            widget.data['wishlist_count'].toString(),
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.w700
                            )
                        ),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WishlistScreen()
                          )
                      ),
                    ),
                  ),

                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 0.2)
                      ),
                      child: InkWell(
                          child: ListTile(
                            leading: Image.asset("assets/animated_icon/order.gif", width: 30),
                            title: Text(
                                "My Orders ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green.shade900,
                                    fontWeight: FontWeight.w500
                                )
                            ),
                            trailing: Text(
                                widget.data['order_count'].toString(),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.green.shade900,
                                    fontWeight: FontWeight.w700
                                )
                            ),
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyOrders()
                              )
                          )
                      )
                  )
              ],
          )
      ),
    );
  }
}
