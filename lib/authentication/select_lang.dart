import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:user/common_widget.dart';
import 'package:user/top_navigation.dart';
import 'package:flutter/material.dart';

final langName = ["Marathi", "Hindi", "English"];
final langCode = ["mr", "hi", "eng"];

class SelectLang extends StatefulWidget {
  const SelectLang({Key? key}) : super(key: key);

  @override
  State<SelectLang> createState() => _SelectLangState();
}

class _SelectLangState extends State<SelectLang> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference storeUser = FirebaseDatabase.instance.ref('User');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: backGroundTheme(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text("Select language :",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 250,
                  child: Divider(
                    color: Colors.green.shade800,
                    thickness: 0.5,
                  ),
                ),

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(5),
                    physics: const BouncingScrollPhysics(),
                    itemCount: langName.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 9/2.3
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(5),
                        child: langButton(
                            langName: langName[index],
                            langCode: langCode[index],
                            onPressed: () {
                              storeUser.child(_auth.currentUser!.uid).update({
                                'languageCode': langCode[index].toString(),
                                'languageName': langName[index].toString()

                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Navigation())
                              );
                            }
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),
                SizedBox(
                  width: 250,
                  child: Divider(
                    color: Colors.green.shade800,
                    thickness: 0.5,
                  ),
                )
              ],
            )
        )
    );
  }
}
