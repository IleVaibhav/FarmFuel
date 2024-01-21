import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller/product/product_details.dart';

Widget backGroundTheme({required child}) {
  return Container(
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      image: const DecorationImage(
        image: AssetImage("assets/bg.png"),
        scale: 19/13,
        alignment: Alignment.bottomRight,
        opacity: 0.1
      )
    ),
    child: child
  );
}


Widget customTextFormField({
    final onTap,
    final obsecureText,
    final keyboardType,
    final hintText,
    final labelText,
    final errorText,
    final prefixIcon,
    var controller,
    maxLines = 1
}) {
    return TextFormField(
        controller: controller,
        onTap: onTap,
        cursorColor: Colors.purple.shade900,
        cursorHeight: 25,
        obscureText: obsecureText,
        obscuringCharacter: "v",
        keyboardType: keyboardType,
        cursorWidth: 0.7,
        maxLines: maxLines,
        decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            errorStyle: TextStyle(color: Colors.red.shade900),
            labelStyle: TextStyle(color: Colors.purple.shade900),
            contentPadding: const EdgeInsets.all(15),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: Colors.purple.shade700
                )
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Colors.white
                )
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: Colors.red.shade900
                )
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Colors.white
                )
            ),
            prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, color: Colors.purple.shade900)
        ),
        validator: (value) {
            if(value!.isEmpty) {
                return errorText;
            }
            return null;
        },
    );
}

void customToastMsg(String str) {
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: const Color.fromARGB(255, 103, 2, 2),
        textColor: Colors.blue.shade50,
        fontSize: 16.0
    );
}

DatabaseReference sellerDetails = FirebaseDatabase.instance.ref('Seller');
final FirebaseAuth _auth = FirebaseAuth.instance;
final products = FirebaseFirestore.instance;

Widget customGridViewBuilder({
    required type
}) {
    return Expanded(
        child: StreamBuilder(
            stream: products.collection(type.toString()).where('addedByUID',isEqualTo: _auth.currentUser!.uid).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                            color: Colors.purple.shade900,
                        ),
                    );
                }
                else if (snapshot.hasData) {
                    var data = snapshot.data!.docs;
                    if(data.isEmpty) {
                        return Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Text(
                                        "Sorry . . . 😕",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.purple.shade900
                                        )
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                        "No $type found",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.purple.shade800
                                        )
                                    )
                                ],
                            )
                        );
                    }
                    else {
                        return GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(0),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 9/14
                            ),
                            itemCount: data.length,
                            itemBuilder: (context, index) => productGrid(
                                context: context,
                                index: index,
                                type: type.toString(),
                                data: data[index]
                            ),
                        );
                    }
                }
                else {
                    return const Text("Error");
                }
            }
        ),
    );
}


Widget productGrid({
    context,
    required index,
    required type,
    required data
}) {
    return InkWell(
      onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductDetails(data: data, type: type))
          );
      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.purple.shade900, width: 0.1)
          ),
          margin: EdgeInsets.only(
              bottom: 6,
              right: (index % 3 == 0 || index % 3 == 1) ? 3 : 0,
              left: (index % 3 == 1 || index % 3 == 2) ? 3 : 0,
          ),
          child: Column(
              children: [
                  Expanded(child: Image.network(data['productImg'], width: 200)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Container(
                              width: 5 * MediaQuery.of(context).size.width / 23,
                              margin: const EdgeInsets.only(left: 5),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(data['productName'], style: TextStyle(color: Colors.purple.shade900)),
                                      const SizedBox(height: 3),
                                      Text("₹${data['productPrize']} | ${data['productAvailableQuantity']}", style: const TextStyle(fontSize: 12)),
                                      const SizedBox(height: 3),
                                  ],
                              ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width / 23,
                              margin: const EdgeInsets.only(right: 15),
                              child: StreamBuilder(
                                  stream: sellerDetails.child(_auth.currentUser!.uid).onValue,
                                  builder: (context, AsyncSnapshot snapshot) {
                                      return IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red.shade900, size: 20),
                                          onPressed: () {
                                              products.collection(type.toString()).doc(data.id).delete().then((value) {
                                                  Map<dynamic, dynamic> sellerData = snapshot.data!.snapshot.value;
                                                  int productCount = int.parse(sellerData['product_count'].toString());
                                                  productCount -= 1;
                                                  sellerDetails.child(_auth.currentUser!.uid).update({
                                                      'product_count': productCount.toString()
                                                  });
                                              }).onError((error, stackTrace) {
                                                  customToastMsg(error.toString());
                                              });
                                          },
                                      );
                                  },
                              )

                          ),
                      ],
                  ),
              ],
          ),
      ),
    );
}


Widget customInkwell({
    required showText,
    required onTap,
    required bool showAll
}) {
    return InkWell(
        onTap: onTap,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Text(
                    showText,
                    style: TextStyle(
                        color: Colors.purple.shade900,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    )
                ),
                Row(
                    children: [
                        Text(showAll ? "Show less" : "Show more", style: TextStyle(color: Colors.grey.shade800)),
                        Icon(
                            showAll ? Icons.unfold_less : Icons.unfold_more,
                            size: 16.0,
                            color: Colors.grey.shade800
                        ),
                        const SizedBox(width: 5)
                    ],
                )
            ],
        ),
    );
}