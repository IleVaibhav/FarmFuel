import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller/common_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAnimalProduct extends StatefulWidget {
  const AddAnimalProduct({Key? key}) : super(key: key);

  @override
  State<AddAnimalProduct> createState() => _AddAnimalProductState();
}

class _AddAnimalProductState extends State<AddAnimalProduct> {

  CollectionReference animalProduct = FirebaseFirestore.instance.collection("Animal Products");
  final DatabaseReference sellerDetails = FirebaseDatabase.instance.ref('Seller');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey();

  final productNameController = TextEditingController();
  final productManufacturerController = TextEditingController();
  final productPrizeController = TextEditingController();
  final productQuantityController = TextEditingController();
  final productInstructionController = TextEditingController();
  final productContentController = TextEditingController();

  var animalCount = 8;
  var animalHeight = 36 * 2 + 1;
  final animalName = [
    "Cow", "Buffalo", "Camel", "Horse",
    "Donkey", "Pig", "Goat",  "Sheep",
    "Fishery", "Dog", "Cat", "Rabbit",
    "Poultry", "Parrot", "Pigeon", "Bee"
  ];
  bool isSelectAll = false;
  List<bool> isSelected = List.filled(16, false);

  var usedFor = [];

  bool isSolid = true;

  bool isLading = false;

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
        title: const Text("Add Animal Product"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder(
              stream: sellerDetails.child(_auth.currentUser!.uid).onValue,
              builder: (context, AsyncSnapshot snapshot) {
                  return !isLading ? ElevatedButton(
                      onPressed: () async {
                          if (usedFor.isEmpty) {
                              customToastMsg("Please select minimum one Animal");
                          }
                          else if(_image == null) {
                              customToastMsg("Please select product Image");
                          }
                          else if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLading = true;
                              });
                              firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance.ref("/Animal Products/$productNameController${DateTime.now()}");
                              firebase_storage.UploadTask uploadTask = storageRef.putFile(_image!.absolute);
                              await Future.value(uploadTask);
                              var newProfileURL = await storageRef.getDownloadURL();
                              animalProduct.add({
                                  'productType': "Animal Products".toString(),
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
                                    isLading = false;
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
                                    isLading = false;
                                  });
                                  customToastMsg(error.toString());
                              });
                          }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),)
                          )
                      ),
                      child: Text("Add", style: TextStyle(
                          color: Colors.purple.shade900,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)
                      ),
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
                        const SizedBox(height: 20),

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
                                            isSelected = List.filled(16, true);
                                            usedFor = animalName.toList();
                                          }
                                          else {
                                            isSelected = List.filled(16, false);
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
                                        if(animalCount == 8){
                                          animalCount = animalName.length;
                                          animalHeight = 145;
                                        }
                                        else {
                                          animalCount = 8;
                                          animalHeight = 73;
                                        }
                                      });
                                    },
                                    style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(Colors.transparent)
                                    ),
                                    child: Row(
                                      children: [
                                        Text(animalCount == 8 ? "Show More" : "Show Less", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                        Icon(animalCount == 8 ? Icons.keyboard_arrow_down_outlined : Icons.keyboard_arrow_up_outlined, color: Colors.grey.shade600, size: 20)
                                      ],
                                    )
                                ),
                              ],
                            )
                          ],
                        ),

                        Container(
                          height: animalHeight.toDouble(),
                          color: Colors.transparent,
                          child: GridView.builder(
                              itemCount: animalCount,
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
                                              usedFor.add(animalName[index]);
                                          }
                                          else {
                                              usedFor.remove(animalName[index]);
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
                                          Text(animalName[index], style: TextStyle(fontSize: 11, color: Colors.blue.shade800)),
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
