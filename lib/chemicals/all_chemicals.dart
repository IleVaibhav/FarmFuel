import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user/chemicals/all_product.dart';
import 'package:user/common_widget.dart';
import 'package:user/product_details.dart';
import 'package:flutter/material.dart';

class AllChemicals extends StatefulWidget {
  const AllChemicals({Key? key}) : super(key: key);

  @override
  State<AllChemicals> createState() => _AllChemicalsState();
}

class _AllChemicalsState extends State<AllChemicals> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final chemicals = FirebaseFirestore.instance;

  final chemicalType = [
    "Insecticides",
    "Herbicides",
    "Fungicides",
    "Nematicides",
    "Rodenticides",
    "Ovicides"
  ];

  final chemicalTypeImg = [
    "assets/icons/Insecticide.png",
    "assets/icons/herbicide.png",
    "assets/icons/fungi.png",
    "assets/icons/Nematicide.png",
    "assets/icons/rodenticide.png",
    "assets/icons/Insecticide.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: backGroundTheme(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
            child: ListView.builder(
                itemCount: chemicalType.length,
                itemBuilder: (context, index) {
                    return StreamBuilder(
                      stream: chemicals.collection("Chemicals").where("chemicalType", isEqualTo: chemicalType[index].toString()).snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if(!snapshot.hasData) {
                          return Center(
                              child : Image.asset("assets/animated_icon/loading.gif", height: 80, width: 80)
                          );
                        }
                        else if (snapshot.hasData) {
                          var data = snapshot.data!.docs;
                          data.shuffle();
                          return data.isNotEmpty ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AllProduct(
                                                title: chemicalType[index],
                                                type: "Chemicals", data: data
                                            )
                                        )
                                    );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    border: Border.all(color: Colors.black, width: 0.2),
                                    borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    horizontalTitleGap: 0,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    leading: Image.asset(chemicalTypeImg[index], width: 20, height: 20),
                                    title: Text(
                                        chemicalType[index],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16, color: darkGreen
                                        )
                                    ),
                                    trailing: data.length >= 10 ? const Icon(Icons.arrow_right_outlined) : const SizedBox(height: 0, width: 0),
                                  ),
                                ),
                              ),

                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(
                                        data.length,
                                        (index1) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ProductDetails(type: "Chemicals", data: data[index1]))
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: Colors.black, width: 0.2)
                                              ),
                                              width: 135,
                                              height: 200,
                                              margin: const EdgeInsets.only(right: 3, left: 3),
                                              padding: const EdgeInsets.all(5),
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                      Stack(
                                                          alignment: AlignmentDirectional.topEnd,
                                                          children: [
                                                              Container(
                                                                  margin : const EdgeInsets.only(top: 10),
                                                                  alignment: Alignment.center,
                                                                  child: Image.network(data[index1]['productImg'], height: 120, width: 120, fit: BoxFit.fill)
                                                              ),
                                                              listLengthDB(input: data[index1]['productRating1'].toString()) + listLengthDB(input: data[index1]['productRating2'].toString()) + listLengthDB(input: data[index1]['productRating3'].toString()) + listLengthDB(input: data[index1]['productRating4'].toString()) + listLengthDB(input: data[index1]['productRating5'].toString()) != 0 ? Container(
                                                                  width: 40,
                                                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                                                  decoration: BoxDecoration(
                                                                      color: darkGreen,
                                                                      borderRadius: BorderRadius.circular(3)
                                                                  ),
                                                                  child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                          Text(
                                                                              ((1 * listLengthDB(input: data[index1]['productRating1'].toString())
                                                                                + 2 * listLengthDB(input: data[index1]['productRating2'].toString())
                                                                                + 3 * listLengthDB(input: data[index1]['productRating3'].toString())
                                                                                + 4 * listLengthDB(input: data[index1]['productRating4'].toString())
                                                                                + 5 * listLengthDB(input: data[index1]['productRating5'].toString())
                                                                              ) / (listLengthDB(input: data[index1]['productRating1'].toString())
                                                                                + listLengthDB(input: data[index1]['productRating2'].toString())
                                                                                + listLengthDB(input: data[index1]['productRating3'].toString())
                                                                                + listLengthDB(input: data[index1]['productRating4'].toString())
                                                                                + listLengthDB(input: data[index1]['productRating5'].toString()))).toString(),
                                                                              style: const TextStyle(
                                                                                  fontSize: 12,
                                                                                  color: Colors.white
                                                                              )
                                                                          ),
                                                                          Image.asset("assets/animated_icon/star_filled.gif", height: 12, width: 12)
                                                                      ],
                                                                  ),
                                                              ) : const Text("")
                                                          ]
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(data[index1]['productName']),
                                                      const SizedBox(height: 3),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          int.parse(data[index1]['productPrize']) != 0 ? Text("₹${data[index1]['productPrize']}") : Text("Unavailable", style: TextStyle(color: Colors.red.shade900)),
                                                          data[index1]['wishlist'].contains(_auth.currentUser!.uid) ? Container(
                                                              margin: const EdgeInsets.only(right: 10),
                                                              child: const Text("❤", style: TextStyle(fontSize: 12))
                                                          ) : Container()
                                                        ],
                                                      ),
                                                      Text(data[index1]['productManufacturer'])
                                                  ],
                                              ),
                                            ),
                                          );
                                        }
                                    ),
                                  ),
                                ),
                              ),

                              Divider(color: darkGreen, thickness: 0.2, height: 10)

                            ],
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
            ),
          )
      ),
    );
  }
}