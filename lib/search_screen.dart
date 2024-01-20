import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user/common_widget.dart';
import 'package:user/product_details.dart';

class SearchScreen extends StatefulWidget {
  final productType;
  const SearchScreen({Key? key, this.productType}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchController = TextEditingController();

  final fertilizer = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String searchText = "";
  void setSearchText() {
    setState(() {
      searchText = searchController.text.toString();
    });
  }

  String defaultSearch = "Name";
  final searchByFilter1 = [
    "Name",
    "Prize",
    "Manufacturer",
    "Used For",
    "Rating"
  ];
  final searchByFilter2 = [
    "Name",
    "Prize",
    "Manufacturer",
    "Rating"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade500,
        elevation: 1,
        leading: Container(
          padding: const EdgeInsets.only(left: 10),
          alignment: Alignment.center,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: const Icon(Icons.arrow_back_ios)
          )
        ),
        leadingWidth: 50,
        titleSpacing: 0,
        toolbarHeight: 95,
        title: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2, right: 5),
              height: 45,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20)
              ),
              alignment: Alignment.center,
              child: TextFormField(
                controller: searchController,
                autofocus: true,
                cursorColor: Colors.white,
                keyboardType: defaultSearch == "Rating" || defaultSearch == "Prize" ? TextInputType.number : TextInputType.text,
                onChanged: (newValue) {
                  setState(() {
                    searchText = newValue;
                    if((defaultSearch == "Prize" || defaultSearch == "Rating") && (double.tryParse(searchText.toString()) == null)) {
                      searchText = "0";
                    }
                  });
                },
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  hintText: "Search ${widget.productType} here . . .",
                  suffixIcon: InkWell(
                    onTap: setSearchText,
                    child: const Icon(Icons.search, color: Colors.white)
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white, width: 0.5)
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white, width: 0.5)
                  )
                )
              )
            ),
            Container(
              height: 30,
              margin: const EdgeInsets.only(top: 7, right: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: Colors.white
                ),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Row(
                children: [
                  const Text("Filter by : ", style: TextStyle(fontSize: 17)),
                  Expanded(
                    child: DropdownButton(
                      value: defaultSearch,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      underline: const SizedBox(height:0, width: 0),
                      items: widget.productType == "Chemicals" || widget.productType == "Animal Home" ? searchByFilter1.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items)
                        );
                      }).toList() : searchByFilter2.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items)
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          defaultSearch = newValue!;
                          searchController.clear();
                          searchText = "";
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),

      body: backGroundTheme(
        child: searchText != "" ? StreamBuilder(
          stream: fertilizer.collection(widget.productType == "Farm Equipments" ? "Equipments" : widget.productType == "Animal Home" ? "Animal Products" : widget.productType.toString()).snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return Center(
                child : Image.asset("assets/animated_icon/loading.gif", height: 80, width: 80)
              );
            }
            else if(snapshot.hasData) {
              var data = snapshot.data!.docs;
              if(defaultSearch == "Name") {
                data = data.where((element) => element['productName'].toString().toLowerCase().contains(searchText.toString().toLowerCase())).toList();
              }
              else if(defaultSearch == "Prize") {
                data = data.where(
                  (element) {
                    return double.parse(element['productPrize'].toString()) <= double.parse(searchText.toString().toLowerCase());
                }).toList();
              }
              else if(defaultSearch == "Manufacturer") {
                data = data.where((element) => element['productManufacturer'].toString().toLowerCase().contains(searchText.toString().toLowerCase())).toList();
              }
              else if(defaultSearch == "Used For") {
                data = data.where((element) => element['usedFor'].toString().toLowerCase().contains(searchText.toString().toLowerCase())).toList();
              }
              else if(defaultSearch == "Rating") {
                data = data.where(
                  (element) {
                    return ((1 * listLengthDB(input: element['productRating1'].toString())
                        + 2 * listLengthDB(input: element['productRating2'].toString())
                        + 3 * listLengthDB(input: element['productRating3'].toString())
                        + 4 * listLengthDB(input: element['productRating4'].toString())
                        + 5 * listLengthDB(input: element['productRating5'].toString())
                    ) / (listLengthDB(input: element['productRating1'].toString())
                        + listLengthDB(input: element['productRating2'].toString())
                        + listLengthDB(input: element['productRating3'].toString())
                        + listLengthDB(input: element['productRating4'].toString())
                        + listLengthDB(input: element['productRating5'].toString()))) >= double.parse(searchText.toString().toLowerCase());
                }).toList();
              }

              return data.isNotEmpty ? GridView.builder(
                padding: const EdgeInsets.all(5),
                physics: const BouncingScrollPhysics(),
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: (MediaQuery.of(context).size.width / 9) / (MediaQuery.of(context).size.height / 11)
                ),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(type: widget.productType, data: data[index])));
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
                            width: MediaQuery.of(context).size.width / 3,
                            child: Image.network(data[index]['productImg'], fit: BoxFit.contain),
                          ),
                        ),
                        Expanded(child: Container()),
                        widget.productType == "Seeds"
                            ? Text("  ${data[index]['productName']} seeds")
                            : Text("  ${data[index]['productName']}"),
                        const SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("  ₹${data[index]['productPrize']}"),
                            data[index]['wishlist'].contains(_auth.currentUser!.uid) ? Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const Text("❤", style: TextStyle(fontSize: 12))
                            ) : Container(),
                          ],
                        ),
                        const SizedBox(height: 1),
                        Text(
                            "  Rating : ${(1 * listLengthDB(input: data[index]['productRating1'].toString())
                                + 2 * listLengthDB(input: data[index]['productRating2'].toString())
                                + 3 * listLengthDB(input: data[index]['productRating3'].toString())
                                + 4 * listLengthDB(input: data[index]['productRating4'].toString())
                                + 5 * listLengthDB(input: data[index]['productRating5'].toString())
                            ) / (listLengthDB(input: data[index]['productRating1'].toString())
                                + listLengthDB(input: data[index]['productRating2'].toString())
                                + listLengthDB(input: data[index]['productRating3'].toString())
                                + listLengthDB(input: data[index]['productRating4'].toString())
                                + listLengthDB(input: data[index]['productRating5'].toString()))} ⭐"
                        ),
                        const SizedBox(height: 1),
                        Text("  ${data[index]['productManufacturer']}"),
                        const SizedBox(height: 5)
                      ],
                    ),
                  ),
                ),
              ) : Center(
                child: Text(
                  "No ${widget.productType} found",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: darkGreen
                  )
                ),
              );
            }
            else {
              return Center(
                child: Text(
                  "Error while loading data",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: darkGreen
                  )
                ),
              );
            }
          }
        ) : Center(
          child: Text(
            "Enter a search text",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: darkGreen
            )
          )
        )
      ),
    );
  }
}
