import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller/common_widget.dart';
import 'package:flutter/material.dart';

class AddSeed extends StatefulWidget {
  const AddSeed({Key? key}) : super(key: key);

  @override
  State<AddSeed> createState() => _AddSeedState();
}

class _AddSeedState extends State<AddSeed> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference sellerDetails = FirebaseDatabase.instance.ref('Seller');

  final GlobalKey<FormState> _formKey = GlobalKey();

  final productManufacturerController = TextEditingController();
  final productPrizeController = TextEditingController();
  final productQuantityController = TextEditingController();
  final productInstructionController = TextEditingController();

  var cropCount = 12;
  var cropHeight = 109;
  final crop = [
    "Bajra", "Barley", "Bitter Gourd", "Coffee",
    "Cotton", "Cucumber", "Ground Nuts", "Jowar",
    "Jute", "Maize", "Millet", "Moong",
    "Mustard", "Oat", "Potato", "Pumpkin",
    "Rape Seed", "Rice", "Rubber", "Soybean",
    "Sugar Cane", "Sweet Potato", "Tea", "Tur",
    "Urad", "Wheat"
  ];
  var selectedSeed = "Bajra";

  var usedFor = [];

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.purple.shade900,
        title: const Text("Add Seeds"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder(
                stream: sellerDetails.child(_auth.currentUser!.uid).onValue,
                builder: (context, AsyncSnapshot snapshot) {
                  return !isLoading ? ElevatedButton(
                    onPressed: () async {
                      CollectionReference farmProduct = FirebaseFirestore.instance.collection("Seeds");
                      if(_image == null){
                        customToastMsg("Please select product image");
                      }
                      else if(_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance.ref("/seeds/$selectedSeed${DateTime.now()}");
                        firebase_storage.UploadTask uploadTask = storageRef.putFile(_image!.absolute);
                        await Future.value(uploadTask);
                        var newProfileURL = await storageRef.getDownloadURL();
                        farmProduct.add({
                          'productName': selectedSeed.toString(),
                          'productType': 'Seeds'.toString(),
                          'productPrize': productPrizeController.text.toString(),
                          'productQuantityLastAdded': productQuantityController.text.toString(),
                          'productTotalAdded': productQuantityController.text.toString(),
                          'productAvailableQuantity': productQuantityController.text.toString(),
                          'productInstructionsToUse': productInstructionController.text.toString(),
                          'addedByUID': _auth.currentUser!.uid,
                          'addedByEmail': _auth.currentUser!.email,
                          'wishlist_count': "0",
                          'wishlist': [].toList(),
                          'productRating1': [].toList(),
                          'productRating2': [].toList(),
                          'productRating3': [].toList(),
                          'productRating4': [].toList(),
                          'productRating5': [].toList(),
                          'productManufacturer': productManufacturerController.text.toString(),
                          'productImg': newProfileURL.toString()
                        }).then((value) {
                          Map<dynamic, dynamic> sellerData = snapshot.data!.snapshot.value;
                          int productCount = int.parse(sellerData['product_count'].toString());
                          productCount += 1;
                          sellerDetails.child(_auth.currentUser!.uid).update({
                            'product_count': productCount.toString()
                          });
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                          customToastMsg("Product added successfully");
                        }).onError((error, stackTrace) {
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
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),)
                        )
                    ),
                    child: Text("Add", style: TextStyle(color: Colors.purple.shade900, fontSize: 16, fontWeight: FontWeight.bold)),
                  ) : const Center(
                    child: CircularProgressIndicator(
                        color: Colors.white
                    ),
                  );
                }
            ),
          )
        ],
      ),

      body: backGroundTheme(
          child: NotificationListener(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: NotificationListener(
                  onNotification: (OverscrollIndicatorNotification notification) {
                    notification.disallowIndicator();
                    return true;
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                                Text(
                                    "Seeds Of : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: Colors.purple.shade900
                                    )
                                ),

                                SizedBox(
                                    height: 20,
                                    child: DropdownButton(
                                        value: selectedSeed,
                                        underline: Container(),
                                        items: crop.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                        onChanged: (value) {
                                            setState(() {
                                              selectedSeed = value as String;
                                            });
                                        },
                                    ),
                                ),
                            ],
                        ),

                        const SizedBox(height: 10),
                        Divider(color: Colors.purple.shade900, thickness: 0.3, height: 1),
                        const SizedBox(height: 15),

                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              customTextFormField(
                                  controller: productManufacturerController,
                                  onTap: () {},
                                  obsecureText: false,
                                  keyboardType: TextInputType.text,
                                  hintText: "enter Company name here . . .",
                                  labelText: "Company Name . . .",
                                  errorText: "Please enter Company name . . .",
                                  prefixIcon: null
                              ),
                              const SizedBox(height: 20),
                              customTextFormField(
                                  controller: productPrizeController,
                                  onTap: () {},
                                  obsecureText: false,
                                  keyboardType: TextInputType.phone,
                                  hintText: "enter Prize here . . .",
                                  labelText: "Prize . . .",
                                  errorText: "Please enter Prize . . .",
                                  prefixIcon: null
                              ),
                              const SizedBox(height: 20),
                              customTextFormField(
                                  controller: productQuantityController,
                                  onTap: () {},
                                  obsecureText: false,
                                  keyboardType: TextInputType.phone,
                                  hintText: "enter Available Quantity here . . .",
                                  labelText: "Quantity . . .",
                                  errorText: "Please enter Quantity . . .",
                                  prefixIcon: null
                              ),
                              const SizedBox(height: 20),
                              customTextFormField(
                                  controller: productInstructionController,
                                  onTap: () {},
                                  obsecureText: false,
                                  keyboardType: TextInputType.text,
                                  hintText: "enter instruction's here . . .",
                                  labelText: "Instructions to Use . . .",
                                  errorText: "Please enter Instructions . . .",
                                  prefixIcon: null,
                                  maxLines: 5
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),
                        Divider(color: Colors.purple.shade900),
                        Text(
                          "  Select Product Image",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade900,
                              fontSize: 16
                          ),
                        ),
                        const SizedBox(height: 10),

                        InkWell(
                          onTap: () {
                            getImageGallery();
                          },
                          child: _image == null ? Container(
                              height: MediaQuery.of(context).size.width - 50,
                              width: MediaQuery.of(context).size.width - 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(15.0)
                              ),
                              child: Icon(
                                  Icons.add,
                                  color: Colors.grey.shade700,
                                  size: 30
                              )
                          ) : Image.file(_image!.absolute),
                        ),

                        const SizedBox(height: 20)

                      ],
                    ),
                  ),
                ),
              )
          )
      ),
    );
  }
}
