import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user/common_widget.dart';
import 'package:user/product_details.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {

  final product = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int wishlistCount = 0;

  final productTypes = [
    "Chemicals",
    "Fertilizers",
    "Equipments",
    "Seeds",
    "Animal Products"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: goBack(context),
        title: const Text("Wishlist"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade500,
        elevation: 1
      ),

      body: backGroundTheme(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return true;
            },
            child: userData['wishlist_count'].toString() != "0" ? ListView.builder(
                itemCount: productTypes.length,
                itemBuilder: (context, index) {
                    return StreamBuilder(
                        stream: product.collection(productTypes[index].toString()).where('wishlist', arrayContains: _auth.currentUser!.uid.toString()).snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if(!snapshot.hasData) {
                              return Center(
                                  child : Image.asset("assets/animated_icon/loading.gif", height: 80, width: 80)
                              );
                            }
                            else if (snapshot.hasData) {
                              var data = snapshot.data!.docs;
                              return data.isNotEmpty ? Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black, width: 0.2)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(
                                          productTypes[index],
                                          style: TextStyle(
                                              color: darkGreen,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                          )
                                      ),
                                      trailing: data.length >= 15 ? const Icon(Icons.arrow_right_outlined, color: Colors.black) : const SizedBox(height: 0, width: 0),
                                    ),
                                    SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: List.generate(
                                              data.length,
                                              (index1) {
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(type: productTypes[index], data: data[index1])));
                                                  },
                                                  child: Container(
                                                      width: MediaQuery.of(context).size.width / 3.3,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(color: Colors.black, width: 0.1)
                                                      ),
                                                      margin: const EdgeInsets.only(right: 3, left: 3, bottom: 5, top: 0),
                                                      padding: const EdgeInsets.all(5),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Image.network(data[index1]['productImg'], height: 120, width: 120),
                                                          const SizedBox(height: 5),
                                                          Text(data[index1]['productName'], style: const TextStyle(fontSize: 16)),
                                                          const SizedBox(height: 3),
                                                          Text("₹${data[index1]['productPrize']}")
                                                        ],
                                                      )
                                                  ),
                                                );
                                              }
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ) : Container();
                            }
                            else {
                               return const Center(
                                  child: Text("Error while loading data"),
                               );
                            }
                        },
                    );
                },
            ) : Center(
              child: Text(
                "No products added to wishlist",
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
          )
      ),
    );
  }
}
