import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../common_widget.dart';
import 'package:flutter/material.dart';
import '../product_details.dart';

class AllFertilizersAndSeeds extends StatefulWidget {
  final type;
  const AllFertilizersAndSeeds({Key? key, required this.type}) : super(key: key);

  @override
  State<AllFertilizersAndSeeds> createState() => _AllFertilizersAndSeedsState();
}

class _AllFertilizersAndSeedsState extends State<AllFertilizersAndSeeds> {

  final fertilizer = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.type != "Seeds" && widget.type != "Fertilizers") ? AppBar(
        actions: const [
          Icon(Icons.search_outlined),
          SizedBox(width: 10)
        ],
        centerTitle: true,
        title: Text("${widget.type}"),
        backgroundColor: Colors.blue.shade500,
        elevation: 1,
        leading: goBack(context),
      ) : null,
      body: backGroundTheme(
        child: StreamBuilder(
          stream: fertilizer.collection(widget.type.toString()).snapshots(),
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
                padding: const EdgeInsets.all(5),
                physics: const BouncingScrollPhysics(),
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(type: widget.type, data: data[index])));
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: 4,
                        right: (index % 2 == 1) ? 0 : 2,
                        left:  (index % 2 == 0) ? 0 : 2
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(color: Colors.black,width: 0.3),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.only(top: 10),
                            height: MediaQuery.of(context).size.height / 6.5,
                            // width: MediaQuery.of(context).size.width / 3,
                            child: Stack(
                                alignment: AlignmentDirectional.center,
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
                          ),
                        ),
                        Expanded(child: Container()),
                        widget.type == "Seeds" ?
                          Text("  ${data[index]['productName']} seeds")
                          : Text("  ${data[index]['productName']}"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("  ₹${data[index]['productPrize']}"),

                            data[index]['wishlist'].contains(_auth.currentUser!.uid)
                                ? Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: const Text("❤", style: TextStyle(fontSize: 12))
                                )
                                : Container(),
                          ],
                        ),
                        Text("  ${data[index]['productManufacturer']}"),
                        const SizedBox(height: 5)
                      ],
                    ),
                  ),
                ),
              );
            }
            else {
              return const Center(
                child: Text("Error while loading Fertilizers")
              );
            }
          },
        ),
      )
    );
  }
}
