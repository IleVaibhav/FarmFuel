import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:user/top_navigation.dart';
import 'account.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final DatabaseReference userDetails = FirebaseDatabase.instance.ref('User');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  File? _image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100
    );
    setState(() {
      if(pickedFile != null) {
        _image = File(pickedFile.path);
      }
      else {
        debugPrint("No image picked");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    mobileController.dispose();
    addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: backGroundTheme(
          child: StreamBuilder(
            stream: userDetails.child(_auth.currentUser!.uid).onValue,
            builder: (context, AsyncSnapshot snapshot) {
              if(!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                      color: Colors.green.shade900
                  ),
                );
              }
              else if(snapshot.hasData) {
                Map<dynamic, dynamic> userData = snapshot.data!.snapshot.value;
                nameController.text = userData['name'];
                mobileController.text = userData['mobile'];
                addressController.text = userData['address'];
                var userImg = userData['image'];
                return Center(
                  child: Container(
                    width: 350,
                    padding: const EdgeInsets.only(top: 50, bottom: 20),
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
                                  "Update Profile here",
                                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20)
                              )
                          ),

                          Divider(
                            color: Colors.green.shade900
                          ),
                          const SizedBox(height: 10),

                          Center(
                            child: SizedBox(
                              height: 200,
                              width: 200,
                              child: Stack(
                                children: [
                                  Container(
                                      height: 200,
                                      width: 200,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(200),
                                          image: _image != null ? DecorationImage(image: FileImage(_image!.absolute)) : DecorationImage(image: NetworkImage(userImg))
                                      )
                                  ),
                                  Container(
                                      height: 200,
                                      width: 200,
                                      alignment: Alignment.bottomRight,
                                      padding: const EdgeInsets.all(17),
                                      child: Container(
                                        height: 26,
                                        width: 26,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(30)
                                        ),
                                      ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      getImageGallery();
                                    },
                                    child: Container(
                                        height: 200,
                                        width: 200,
                                        alignment: Alignment.bottomRight,
                                        padding: const EdgeInsets.all(15),
                                        child: Icon(Icons.change_circle_rounded, color: darkGreen, size: 30)
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  customTextFormField(
                                      controller: nameController,
                                      title: "Name",
                                      obsecure: false,
                                      errorText: "Please enter Name . . .",
                                      icon: Icons.man,
                                      titleColor: Colors.green.shade900,
                                      keyBoard: TextInputType.text
                                  ),

                                  const SizedBox(height: 20),

                                  customTextFormField(
                                      controller: mobileController,
                                      title: "Mobile",
                                      obsecure: false,
                                      errorText: "Please enter Contact number . . .",
                                      icon: Icons.call,
                                      titleColor: Colors.green.shade900,
                                      keyBoard: TextInputType.number
                                  ),

                                  const SizedBox(height: 20),

                                  customTextFormField(
                                      controller: addressController,
                                      title: "Address",
                                      obsecure: false,
                                      errorText: "Please enter Address . . .",
                                      icon: Icons.call,
                                      titleColor: Colors.green.shade900,
                                      keyBoard: TextInputType.text,
                                      maxLines: 5
                                  ),
                                ],
                              )
                          ),

                          const SizedBox(height: 20),

                          !isLoading ? ElevatedButton(
                              onPressed: () async {
                                if(_formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance.ref("/user_profile/$nameController${DateTime.now()}");
                                  firebase_storage.UploadTask uploadTask = storageRef.putFile(_image!.absolute);
                                  await Future.value(uploadTask);
                                  var newProfileURL = await storageRef.getDownloadURL();
                                  userDetails.child(_auth.currentUser!.uid).update({
                                    'name': nameController.text.toString(),
                                    'mobile': mobileController.text.toString(),
                                    'address': addressController.text.toString(),
                                    'image': _image != null ? newProfileURL.toString() : userImg.toString()
                                  }).then((value) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    customToastMsg("Your profile updated successfully");
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const Navigation())
                                    );
                                  }
                                  ).onError((error, stackTrace) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    customToastMsg(error.toString());
                                  });
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade900,
                                  shadowColor: Colors.blue.shade50
                              ),
                              child: const Text(
                                "Update Profile",
                                style: TextStyle(fontSize: 17),
                              )
                          ) : Center(
                              child: CircularProgressIndicator(
                                  color: darkGreen
                              ),
                          )

                        ],
                      ),
                    ),
                  ),
                );
              }
              else {
                return Center(
                  child: Text(
                    "Something Went wrong",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900
                    ),
                  ),
                );
              }
            },
          )

      ),
    );
  }
}
