import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:seller/common_widget.dart';
import 'package:seller/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddSellerDetails extends StatefulWidget {
  const AddSellerDetails({Key? key}) : super(key: key);

  @override
  State<AddSellerDetails> createState() => _AddSellerDetailsState();
}

class _AddSellerDetailsState extends State<AddSellerDetails> {

  bool isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference sellerDetails = FirebaseDatabase.instance.ref('Seller');

  var nameController = TextEditingController();
  var shopNameController = TextEditingController();
  var shopAddressController = TextEditingController();
  var shopContactController = TextEditingController();
  var sellerImg;

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: backGroundTheme(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 50, bottom: 15, right: 25, left: 25),
            child: NotificationListener(
              onNotification: (OverscrollIndicatorNotification notification) {
                notification.disallowIndicator();
                return true;
              },
              child: SingleChildScrollView(
                child: StreamBuilder(
                  stream: sellerDetails.child(_auth.currentUser!.uid).onValue,
                  builder: (context, AsyncSnapshot snapshot) {
                    if(!snapshot.hasData) {
                      return CircularProgressIndicator(
                          color: Colors.purple.shade900
                      );
                    }
                    else if (snapshot.hasData) {
                        Map<dynamic, dynamic> sellerData = snapshot.data!.snapshot.value;
                        nameController.text = sellerData['name'].toString();
                        shopNameController.text = sellerData['shop_name'].toString();
                        shopAddressController.text = sellerData['shop_address'].toString();
                        shopContactController.text = sellerData['shop_contact'].toString();
                        sellerImg = sellerData['shopImg'].toString().isNotEmpty ? sellerData['shopImg'].toString() : "https://th.bing.com/th/id/OIP.BHnwbuuIaKeQN_Gcg-3VrwHaHa?pid=ImgDet&rs=1";
                        return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                                "Add Shop Details",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.purple.shade900,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22
                                )
                            ),
                            Divider(color: Colors.purple.shade900, thickness: 0.5),
                            const SizedBox(height: 10),
                            Center(
                                child: SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Stack(
                                      children: [
                                        Container(
                                          height: 150,
                                          width: 150,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius: BorderRadius.circular(100),
                                              image: _image != null ? DecorationImage(image: FileImage(_image!.absolute)) : DecorationImage(image: NetworkImage(sellerImg))
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            height: 21,
                                            width: 21,
                                            margin: const EdgeInsets.only(bottom: 11, right: 11.5),
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.circular(25)
                                            )
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                              height: 20,
                                              width: 20,
                                              margin: const EdgeInsets.all(12.5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(25)
                                              )
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            getImageGallery();

                                          },
                                          child: Container(
                                            alignment: Alignment.bottomRight,
                                            padding: const EdgeInsets.all(10),
                                            child: Icon(
                                                Icons.change_circle_rounded,
                                                size: 25.0,
                                                color: Colors.purple.shade900
                                            ),
                                          ),
                                        )
                                      ],
                                  ),
                                ),
                            ),
                            const SizedBox(height: 30),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  customTextFormField(
                                      controller: nameController,
                                      onTap: () {},
                                      obsecureText: false,
                                      keyboardType: TextInputType.text,
                                      hintText: "enter your Full Name here . . .",
                                      labelText: "Full Name . . .",
                                      errorText: "Please enter Full Name . . .",
                                      prefixIcon: Icons.man_outlined
                                  ),
                                  const SizedBox(height: 20),
                                  customTextFormField(
                                      controller: shopNameController,
                                      onTap: () {},
                                      obsecureText: false,
                                      keyboardType: TextInputType.text,
                                      hintText: "enter your Shop name here . . .",
                                      labelText: "Shop Name . . .",
                                      errorText: "Please enter Shop name . . .",
                                      prefixIcon: Icons.shop
                                  ),
                                  const SizedBox(height: 20),
                                  customTextFormField(
                                      controller: shopAddressController,
                                      onTap: () {},
                                      obsecureText: false,
                                      keyboardType: TextInputType.text,
                                      hintText: "enter your Shop Address here . . .",
                                      labelText: "Shop Address . . .",
                                      errorText: "Please enter Shop Address . . .",
                                      prefixIcon: Icons.location_on_sharp,
                                      maxLines: 5
                                  ),
                                  const SizedBox(height: 20),
                                  customTextFormField(
                                      controller: shopContactController,
                                      onTap: () {},
                                      obsecureText: false,
                                      keyboardType: TextInputType.phone,
                                      hintText: "enter your Shop Contact here . . .",
                                      labelText: "Shop Contact . . .",
                                      errorText: "Please enter Shop Contact . . .",
                                      prefixIcon: Icons.phone_rounded
                                  ),
                                  const SizedBox(height: 20)
                                ],
                              ),
                            ),

                            Center(
                            child: !isLoading ? ElevatedButton(
                                onPressed: () async {
                                    isLoading = true;
                                    if(_formKey.currentState!.validate() && (sellerImg != null || _image != null)) {
                                        isLoading = true;
                                        firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance.ref("/seller_profile/${sellerData['name']}${DateTime.now()}");
                                        firebase_storage.UploadTask uploadTask = storageRef.putFile(_image!.absolute);
                                        await Future.value(uploadTask);
                                        var newProfileURL = await storageRef.getDownloadURL();
                                        sellerDetails.child(_auth.currentUser!.uid).update({
                                            'name': nameController.text.toString(),
                                            'shop_name': shopNameController.text.toString(),
                                            'shop_address': shopAddressController.text.toString(),
                                            'shop_contact': shopContactController.text.toString(),
                                            'shopImg': newProfileURL.toString()
                                        }).then((value) {
                                            isLoading = false;
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => const BottomNavigation()
                                                )
                                            );
                                            customToastMsg("${nameController.text.toString()} your shop details saved successfully !!!");
                                        }).onError((error, stackTrace) {
                                          customToastMsg(error.toString());
                                          isLoading = false;
                                        });
                                    }
                                    isLoading = false;
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.purple.shade900),
                                    fixedSize: MaterialStateProperty.all(const Size.fromWidth(190))
                                ),
                                child: const Text("Save & Continue", style: TextStyle(fontSize: 17))
                            ) : CircularProgressIndicator(
                              color: Colors.purple.shade900,
                            ),
                          ),

                        ],
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
                ),
              ),
            ),
          )
      ),
    );
  }
}
