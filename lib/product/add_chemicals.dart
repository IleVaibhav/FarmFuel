import 'dart:io';
import  'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller/common_widget.dart';
import 'package:flutter/material.dart';

class AddChemicals extends StatefulWidget {
  const AddChemicals({Key? key}) : super(key: key);

  @override
  State<AddChemicals> createState() => _AddChemicalsState();
}

class _AddChemicalsState extends State<AddChemicals> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference sellerDetails = FirebaseDatabase.instance.ref('Seller');

  final GlobalKey<FormState> _formKey = GlobalKey();

  final productNameController = TextEditingController();
  final productManufacturerController = TextEditingController();
  final productPrizeController = TextEditingController();
  final productQuantityController = TextEditingController();
  final productInstructionController = TextEditingController();
  final productContentController = TextEditingController();
  
  var cropCount = 12;
  var cropHeight = 109;
  final crop = [
    "Bajra", "Barley", "Bitter\nGourd", "Coffee",
    "Cotton", "Cucumber", "Ground\nNuts", "Jowar",
    "Jute", "Maize", "Millet", "Moong",
    "Mustard", "Oat", "Potato", "Pumpkin",
    "Rape\nSeed", "Rice", "Rubber", "Soybean",
    "Sugar\nCane", "Sweet\nPotato", "Tea", "Tur",
    "Urad", "Wheat"
  ];
  bool isSelectAll = false;
  List<bool> isSelected = List.filled(28, false);

  final chemicalType = ["Insecticides", "Herbicides", "Fungicides", "Nematicides", "Rodenticides", "Ovicides"];
  var selectedChemicalType = "Insecticides";

  var usedFor = [];

  bool isSolid = true;

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
            title: const Text("Add Chemicals"),
            actions: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder(
                      stream: sellerDetails.child(_auth.currentUser!.uid).onValue,
                      builder: (context, AsyncSnapshot snapshot) {
                        return !isLoading ? ElevatedButton(
                            onPressed: () async {
                                CollectionReference farmProduct = FirebaseFirestore.instance.collection("Chemicals");
                                if(usedFor.isEmpty) {
                                    customToastMsg("Please select minimum one crop");
                                }
                                else if(_image == null) {
                                    customToastMsg("Please select product image");
                                }
                                else if(_formKey.currentState!.validate()) {
                                    setState(() {
                                        isLoading = true;
                                    });
                                    firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance.ref("/chemicals/$productNameController${DateTime.now()}");
                                    firebase_storage.UploadTask uploadTask = storageRef.putFile(_image!.absolute);
                                    await Future.value(uploadTask);
                                    var newProfileURL = await storageRef.getDownloadURL();
                                    farmProduct.add({
                                        'productType': 'Chemicals'.toString(),
                                        'chemicalType': selectedChemicalType.toString(),
                                        'productName': productNameController.text.toString(),
                                        'productPrize': productPrizeController.text.toString(),
                                        'productQuantityLastAdded': productQuantityController.text.toString(),
                                        'productTotalAdded': productQuantityController.text.toString(),
                                        'productAvailableQuantity': productQuantityController.text.toString(),
                                        'productInstructionsToUse': productInstructionController.text.toString(),
                                        'productContent': productContentController.text.toString(),
                                        'addedByUID': _auth.currentUser!.uid,
                                        'addedByEmail': _auth.currentUser!.email,
                                        'isSolid': isSolid ? "Solid" : "Liquid",
                                        'productImg': newProfileURL.toString(),
                                        'usedFor': usedFor.toList(),
                                        'productManufacturer': productManufacturerController.text.toString(),
                                        'wishlist_count': "0",
                                        'wishlist': [].toList(),
                                        'productRating1': [].toList(),
                                        'productRating2': [].toList(),
                                        'productRating3': [].toList(),
                                        'productRating4': [].toList(),
                                        'productRating5': [].toList()
                                    }).then((value) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Map<dynamic, dynamic> sellerData = snapshot.data!.snapshot.value;
                                        int productCount = int.parse(sellerData['product_count'].toString());
                                        productCount += 1;
                                        sellerDetails.child(_auth.currentUser!.uid).update({
                                            'product_count': productCount.toString()
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
                                        "Select Chemical Type : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.purple.shade900
                                        )
                                    ),

                                    SizedBox(
                                      height: 25,
                                      child: DropdownButton(
                                          underline: Container(),
                                          value: selectedChemicalType,
                                          items: chemicalType.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                          onChanged: (value) {
                                              setState(() {
                                                selectedChemicalType = value as String;
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
                                            controller: productNameController,
                                            onTap: () {},
                                            obsecureText: false,
                                            keyboardType: TextInputType.text,
                                            hintText: "enter Product Name here . . .",
                                            labelText: "Product Name . . .",
                                            errorText: "Please enter Product Name . . .",
                                            prefixIcon: null
                                        ),
                                        const SizedBox(height: 20),
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
                                        const SizedBox(height: 20),
                                        customTextFormField(
                                            controller: productContentController,
                                            onTap: () {},
                                            obsecureText: false,
                                            keyboardType: TextInputType.text,
                                            hintText: "enter content here . . .",
                                            labelText: "Product Content . . .",
                                            errorText: "Please enter Content . . .",
                                            prefixIcon: null,
                                            maxLines: 5
                                        ),
                                    ],
                                ),
                            ),

                            const SizedBox(height: 10),
                            Divider(color: Colors.purple.shade900, thickness: 0.3, height: 1),
                            const SizedBox(height: 10),

                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text(
                                            "Product State",
                                            style: TextStyle(
                                                color: Colors.purple.shade900,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16
                                            )
                                        ),
                                        SizedBox(
                                          height: 33,
                                          child: Row(
                                              children: [
                                                  OutlinedButton(
                                                      onPressed: () {
                                                          setState(() {
                                                              isSolid = !isSolid;
                                                          });
                                                      },
                                                      style: ButtonStyle(
                                                          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20)),
                                                          fixedSize: MaterialStateProperty.all(const Size.fromHeight(1)),
                                                          backgroundColor: MaterialStateProperty.all(
                                                              isSolid ? Colors.purple.shade900 : Colors.transparent
                                                          )
                                                      ),
                                                      child: Text(
                                                          "Solid",
                                                          style: isSolid
                                                              ? const TextStyle(color: Colors.white, fontSize: 16)
                                                              : const TextStyle(color: Colors.grey, fontSize: 16)
                                                      )
                                                  ),
                                                  const SizedBox(width: 15),
                                                  OutlinedButton(
                                                      onPressed: () {
                                                          setState(() {
                                                              isSolid = !isSolid;
                                                          });
                                                      },
                                                      style: ButtonStyle(
                                                          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20)),
                                                          fixedSize: MaterialStateProperty.all(const Size.fromHeight(1)),
                                                          backgroundColor: MaterialStateProperty.all(
                                                              !isSolid ? Colors.purple.shade900 : Colors.transparent
                                                          )
                                                      ),
                                                      child: Text(
                                                          "Liquid",
                                                          style: !isSolid
                                                              ? const TextStyle(color: Colors.white, fontSize: 16)
                                                              : const TextStyle(color: Colors.grey, fontSize: 16)
                                                      )
                                                  )
                                              ],
                                          ),
                                        )
                                    ],
                                ),
                            ),

                            const SizedBox(height: 10),
                            Divider(color: Colors.purple.shade900, thickness: 0.3, height: 1),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                          "Used for",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.purple.shade900
                                          )
                                      ),
                                  ),
                                  Row(
                                      children: [
                                          SizedBox(
                                            height: 22,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                    setState(() {
                                                        isSelectAll = !isSelectAll;
                                                        if(isSelectAll) {
                                                            isSelected = List.filled(28, true);
                                                            usedFor = crop.toList();
                                                        }
                                                        else {
                                                            isSelected = List.filled(28, false);
                                                            usedFor.clear();
                                                        }
                                                    });
                                                },
                                                style: ButtonStyle(
                                                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 5)),
                                                    fixedSize: MaterialStateProperty.all(const Size.fromHeight(1)),
                                                    backgroundColor: MaterialStateProperty.all(Colors.white)
                                                ),
                                                child: Text(isSelectAll ? "Remove All" : "Select All", style: TextStyle(color: Colors.purple.shade900, fontSize: 12))
                                            ),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                  setState(() {
                                                      if(cropCount == 12){
                                                          cropCount = crop.length;
                                                          cropHeight = 253;
                                                      }
                                                      else {
                                                          cropCount = 12;
                                                          cropHeight = 109;
                                                      }
                                                  });
                                              },
                                              style: ButtonStyle(
                                                  overlayColor: MaterialStateProperty.all(Colors.transparent)
                                              ),
                                              child: Row(
                                                  children: [
                                                      Text(cropCount == 12 ? "Show More" : "Show Less", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                                      Icon(cropCount == 12 ? Icons.keyboard_arrow_down_outlined : Icons.keyboard_arrow_up_outlined, color: Colors.grey.shade600, size: 20)
                                                  ],
                                              )
                                        ),
                                      ],
                                  )
                              ],
                            ),

                            Container(
                                height: cropHeight.toDouble(),
                                color: Colors.transparent,
                                child: GridView.builder(
                                    itemCount: cropCount,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        childAspectRatio: 5/2
                                    ),
                                    itemBuilder: (context, index) {
                                        return Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: OutlinedButton(
                                                onPressed: () {
                                                    setState(() {
                                                        isSelected[index] = !isSelected[index];
                                                        if(isSelected[index]) {
                                                            usedFor.add(crop[index]);
                                                        }
                                                        else {
                                                            usedFor.remove(crop[index]);
                                                        }
                                                    });
                                                },
                                                style: ButtonStyle(
                                                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 11)),
                                                    backgroundColor: MaterialStateProperty.all(Colors.purple.shade900.withOpacity(0.05)),
                                                    shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(18.0),
                                                            side: const BorderSide(color: Colors.grey)
                                                        )
                                                    )
                                                ),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text(crop[index], style: TextStyle(fontSize: 11, color: Colors.blue.shade800)),
                                                        isSelected[index] ? Icon(Icons.remove, size: 12, color: Colors.green.shade900) : Icon(Icons.add, size: 12, color: Colors.red.shade900)
                                                    ],
                                                )
                                            ),
                                        );
                                  }
                              ),
                            ),

                            Divider(color: Colors.purple.shade900),
                            Text(
                              "   Select Product Image",
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
