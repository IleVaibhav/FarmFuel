import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user/common_widget.dart';
import 'package:user/product_details.dart';
import 'all_shops.dart';

class AllProductsByShop extends StatefulWidget {
  final Seller shopData;
  const AllProductsByShop({Key? key, required this.shopData}) : super(key: key);

  @override
  State<AllProductsByShop> createState() => _AllProductsByShopState();
}

class _AllProductsByShopState extends State<AllProductsByShop> {

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
        title: Text(widget.shopData.shopName),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.blue
      ),
      body: backGroundTheme(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Image.network(
                          widget.shopData.shopImg.toString(),
                          height: 200,
                          width: 200,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                SizedBox(
                                    width: 120,
                                    child: Text("Shop Name")
                                ),
                                Text(": ")
                              ],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 187,
                              child: Text(
                                  widget.shopData.shopName.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen
                                  ),
                                  textAlign: TextAlign.end
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Divider(color: darkGreen, thickness: 0.1, height: 1,),
                        const SizedBox(height: 4),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                SizedBox(
                                    width: 120,
                                    child: Text("Rating")
                                ),
                                Text(": ")
                              ],
                            ),
                            SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                      widget.shopData.shopRating.toString(),
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
                        const SizedBox(height: 4),
                        Divider(color: darkGreen, thickness: 0.1, height: 1,),
                        const SizedBox(height: 4),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                SizedBox(
                                    width: 120,
                                    child: Text("Owner Name")
                                ),
                                Text(": "),
                              ],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 187,
                              child: Text(
                                  widget.shopData.shopOwner.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen
                                  ),
                                  textAlign: TextAlign.end
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Divider(color: darkGreen, thickness: 0.1, height: 1,),
                        const SizedBox(height: 4),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                SizedBox(
                                    width: 120,
                                    child: Text("Contact")
                                ),
                                Text(": "),
                              ],
                            ),
                            SizedBox(
                              child: Text(
                                  widget.shopData.shopContact.toString(),
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
                        const SizedBox(height: 4),
                        Divider(color: darkGreen, thickness: 0.1, height: 1,),
                        const SizedBox(height: 4),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                SizedBox(
                                    width: 120,
                                    child: Text("email")
                                ),
                                Text(": ")
                              ],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 187,
                              child: Text(
                                  widget.shopData.email.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen
                                  ),
                                  textAlign: TextAlign.end
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Divider(color: darkGreen, thickness: 0.1, height: 1,),
                        const SizedBox(height: 4),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                SizedBox(
                                    width: 120,
                                    child: Text("Address")
                                ),
                                Text(": ")
                              ],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 187,
                              child: Text(
                                  widget.shopData.shopAddress.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: darkGreen
                                  ),
                                  textAlign: TextAlign.end
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Divider(color: darkGreen, thickness: 0.1, height: 1,),
                        const SizedBox(height: 4),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                SizedBox(
                                    width: 120,
                                    child: Text("All Products Added")
                                ),
                                Text(": ")
                              ],
                            ),
                            SizedBox(
                              child: Text(
                                  widget.shopData.shopRating.toString(),
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
                        const SizedBox(height: 4),
                        Divider(color: darkGreen, thickness: 0.1, height: 1,),
                        const SizedBox(height: 4),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                SizedBox(
                                    width: 120,
                                    child: Text("Rated by")
                                ),
                                Text(": ")
                              ],
                            ),
                            SizedBox(
                              child: Text(
                                  "${widget.shopData.allRating.toString()} farmers",
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
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Divider(color: darkGreen, height: 1, thickness: 1),
                  const SizedBox(height: 8),

                  widget.shopData.totalProductsAdded != "0" ? Column(
                    children: List.generate(
                        productTypes.length,
                        (index) => customStreamBuilder(
                            productType: productTypes[index],
                            sellerUID: widget.shopData.sellerID
                        )
                    ),
                  ) : Text(
                      "No products added",
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
      ),
    );
  }
}

Widget customStreamBuilder({required productType, required sellerUID}) {
  final products = FirebaseFirestore.instance;

  return StreamBuilder(
      stream: products.collection(productType.toString()).where('addedByUID', isEqualTo: sellerUID).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(!snapshot.hasData) {
          return Center(
              child: Image.asset("assets/animated_icon/loading.gif", width: 100, height: 100)
          );
        }
        else if(snapshot.hasData) {
          var data = snapshot.data!.docs;
          int totalRow = (data.length / 3).floor();
          int extraRowSize = (data.length) % 3;
          int iterableDataIndex = 0;
          return data.isNotEmpty ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(productType, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 3),
              totalRow != 0 ? Column(
                children: List.generate(
                  totalRow,
                  (index) {
                    return Row(
                        children: List.generate(
                            3,
                            (index) {
                              iterableDataIndex++;
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ProductDetails(type: productType, data: data[index]))
                                  );
                                },
                                child: Container(
                                  height: 185,
                                  width: (MediaQuery.of(context).size.width - 38) / 3,
                                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: darkGreen,
                                          width: 0.2
                                      )
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.network(data[iterableDataIndex - 1]['productImg']),
                                      Text(data[iterableDataIndex - 1]['productName']),
                                      Text("prize ₹ ${data[iterableDataIndex - 1]['productPrize']}"),
                                      Text("Availability : ${data[iterableDataIndex - 1]['productAvailableQuantity']}"),
                                    ],
                                  ),
                                ),
                              );
                            }
                        )
                    );
                  }
                ),
              ) : const SizedBox(height: 0, width: 0),
              extraRowSize != 0 ? Row(
                  children: List.generate(
                      extraRowSize,
                      (index) {
                        iterableDataIndex++;
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProductDetails(type: productType, data: data[index]))
                            );
                          },
                          child: Container(
                            height: 185,
                            width: (MediaQuery.of(context).size.width - 38) / 3,
                            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: darkGreen,
                                    width: 0.2
                                )
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(data[iterableDataIndex - 1]['productImg']),
                                Text(data[iterableDataIndex - 1]['productName']),
                                Text("prize ₹ ${data[iterableDataIndex - 1]['productPrize']}"),
                                Text("Availability : ${data[iterableDataIndex - 1]['productAvailableQuantity']}"),
                              ],
                            ),
                          ),
                        );
                      }
                  )
              ) : const SizedBox(height: 0, width: 0),
              Divider(color: darkGreen, height: 1, thickness: 1),
              const SizedBox(height: 8),
            ],
          ) : const SizedBox(height: 0, width: 0);
        }
        else {
          return const Center(
              child: Text("Error while loading Fertilizers")
          );
        }
      }
  );
}