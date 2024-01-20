import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user/common_widget.dart';
import 'package:user/product_details.dart';
import 'package:flutter/material.dart';

class FarmEquipments extends StatefulWidget {
  const FarmEquipments({Key? key}) : super(key: key);

  @override
  State<FarmEquipments> createState() => _FarmEquipmentsState();
}

class _FarmEquipmentsState extends State<FarmEquipments> {

  final equipments = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: backGroundTheme(
          child: StreamBuilder(
              stream: equipments.collection('Equipments').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(!snapshot.hasData) {
                  return Center(
                      child: Image.asset("assets/animated_icon/loading.gif", width: 100, height: 100)
                  );
                }
                else if (snapshot.hasData) {
                  var data = snapshot.data!.docs;
                  data.shuffle();
                  return GridView.builder(
                    padding: const EdgeInsets.all(3),
                    itemCount: data.length,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: (MediaQuery.of(context).size.width / 9) / (MediaQuery.of(context).size.height / 13)
                    ),
                    itemBuilder: (context, int index) => InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(type: "Equipments", data: data[index])));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black,width: 0.3),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Stack(
                                // alignment: AlignmentDirectional.center,
                                children: [
                                  Image.network(data[index]['productImg'], height: 120, width: 120, fit: BoxFit.fill),
                                  listLengthDB(input: data[index]['productRating1'].toString()) + listLengthDB(input: data[index]['productRating2'].toString()) + listLengthDB(input: data[index]['productRating3'].toString()) + listLengthDB(input: data[index]['productRating4'].toString()) + listLengthDB(input: data[index]['productRating5'].toString()) != 0 ? Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      width: 40,
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                      decoration: BoxDecoration(
                                          color: darkGreen,
                                          borderRadius: BorderRadius.circular(3)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              ((1 * listLengthDB(input: data[index]['productRating1'].toString())
                                                  + 2 * listLengthDB(input: data[index]['productRating2'].toString())
                                                  + 3 * listLengthDB(input: data[index]['productRating3'].toString())
                                                  + 4 * listLengthDB(input: data[index]['productRating4'].toString())
                                                  + 5 * listLengthDB(input: data[index]['productRating5'].toString())
                                              ) / (listLengthDB(input: data[index]['productRating1'].toString())
                                                  + listLengthDB(input: data[index]['productRating2'].toString())
                                                  + listLengthDB(input: data[index]['productRating3'].toString())
                                                  + listLengthDB(input: data[index]['productRating4'].toString())
                                                  + listLengthDB(input: data[index]['productRating5'].toString()))).toString(),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white
                                              ),
                                              textAlign: TextAlign.end
                                          ),
                                          Image.asset("assets/animated_icon/star_filled.gif", height: 12, width: 12)
                                        ],
                                      ),
                                    ),
                                  ) : const Text("")
                                ]
                            ),
                            Expanded(child: Container()),
                            Text(" ${data[index]['productName']}"),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(" ₹${data[index]['productPrize']}"),

                                data[index]['wishlist'].contains(_auth.currentUser!.uid)
                                    ? Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: const Text("💝", style: TextStyle(fontSize: 12))
                                )
                                    : Container(),
                              ],
                            ),
                            const SizedBox(height: 1),
                            Text(" ${data[index]['productManufacturer']}")
                          ],
                        ),
                      ),
                    ),
                  );
                }
                else {
                  return Center(
                      child: Text("Error while loading Fertilizers")
                  );
                }
              },
          )
      ),
    );
  }
}
