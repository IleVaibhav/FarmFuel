import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:user/shops/all_products_by_shop.dart';

import '../common_widget.dart';

class AllShops extends StatefulWidget {
  const AllShops({Key? key}) : super(key: key);

  @override
  State<AllShops> createState() => _AllShopsState();
}

class _AllShopsState extends State<AllShops> {

  final DatabaseReference sellers = FirebaseDatabase.instance.ref("Seller");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("All Shops"),
        centerTitle: true,
        elevation: 1
      ),
      body: backGroundTheme(
          child: StreamBuilder(
              stream: sellers.onValue,
              builder: (context, AsyncSnapshot snapshot) {
                if(!snapshot.hasData) {
                  return Center(
                    child: Image.asset("assets/animated_icon/loading.gif", width: 100, height: 100)
                  );
                }
                else if(snapshot.hasData) {
                  final Map<dynamic, dynamic> sellersData = snapshot.data?.snapshot.value ?? {};
                  List<Seller> allSellersData = [];
                  sellersData.forEach((key, value) {
                    Map<dynamic, dynamic> sellerData = value;

                    Seller seller = Seller(
                      shopName: sellerData['shop_name'],
                      email: sellerData['email'],
                      shopAddress: sellerData['shop_address'],
                      shopContact: sellerData['shop_contact'],
                      shopOwner: sellerData['name'],
                      totalProductsAdded: sellerData['product_count'],
                      allRating: sellerData['all_rating'],
                      shopRating: sellerData['shop_rating'],
                      shopImg: sellerData['shopImg'],
                      sellerID: key.toString()
                    );

                    allSellersData.add(seller);
                  });

                  return allSellersData.isEmpty ? Center(
                    child: Text(
                        "No Sellers found . . .",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: darkGreen
                        )
                    ),
                  ) : ListView.builder(
                      itemCount: allSellersData.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Image.network(
                                    allSellersData[index].shopImg.toString(),
                                    height: 150,
                                    width: 150,
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 150 - 20 - 10,
                                    height: 150,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(
                                                width: 60,
                                                child: Text("Name")
                                            ),
                                            const Text(": "),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width - 150 - 20 - 10 - 67,
                                              child: Text(
                                                  allSellersData[index].shopName.toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: darkGreen
                                                  ),
                                                  overflow: TextOverflow.visible,
                                                  maxLines: 1
                                              ),
                                            ),
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            const SizedBox(
                                                width: 60,
                                                child: Text("Rating")
                                            ),
                                            const Text(": "),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width - 150 - 20 - 10 - 67,
                                              child: Row(
                                                children: [
                                                  Text(
                                                      allSellersData[index].shopRating.toString(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                          color: darkGreen
                                                      ),
                                                      overflow: TextOverflow.visible,
                                                      maxLines: 1
                                                  ),
                                                  const Text(" ⭐"),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            const SizedBox(
                                                width: 60,
                                                child: Text("Owner")
                                            ),
                                            const Text(": "),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width - 150 - 20 - 10 - 67,
                                              child: Text(
                                                  allSellersData[index].shopOwner.toString(),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      color: darkGreen
                                                  ),
                                                  overflow: TextOverflow.visible,
                                                  maxLines: 1
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                                width: 60,
                                                child: Text("Contact")
                                            ),
                                            const Text(": "),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width - 150 - 20 - 10 - 67,
                                              child: Text(
                                                  allSellersData[index].shopContact.toString(),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      color: darkGreen
                                                  ),
                                                  overflow: TextOverflow.visible,
                                                  maxLines: 1
                                              ),
                                            ),
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            const SizedBox(
                                                width: 60,
                                                child: Text("Address")
                                            ),
                                            const Text(": "),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width - 150 - 20 - 10 - 67,
                                              child: Text(
                                                  allSellersData[index].shopAddress.toString(),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      color: darkGreen
                                                  ),
                                                  overflow: TextOverflow.visible,
                                                  maxLines: 1
                                              ),
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => AllProductsByShop(
                                                shopData: allSellersData[index]
                                              ))
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: darkGreen)
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                    "All added products",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500
                                                    )
                                                ),
                                                Text(
                                                  allSellersData[index].totalProductsAdded.toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: darkGreen
                                                  )
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Divider(color: darkGreen, height: 1, thickness: 0.3)
                            ],
                          ),
                        );
                      },
                  );
                }
                else {
                  return Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)
                    ),
                  );
                }
              }
          ),
      ),
    );
  }
}

class Seller {
  String shopName;
  String email;
  String shopOwner;
  String shopAddress;
  String shopContact;
  String totalProductsAdded;
  String sellerID;
  String allRating;
  String shopRating;
  String shopImg;

  Seller({
    required this.shopName,
    required this.email,
    required this.shopAddress,
    required this.shopContact,
    required this.shopOwner,
    required this.totalProductsAdded,
    required this.sellerID,
    required this.allRating,
    required this.shopRating,
    required this.shopImg
  });
}