import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller/common_widget.dart';

class ProductDetails extends StatefulWidget {
  final dynamic data;
  final String type;
  const ProductDetails({Key? key, required this.data, required this.type}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  var usedForCount = 0;
  int changeProductAvailability = 0;

  int listCountFromDB({input}) {
    if(input.toString() == "[]") {
      return 0;
    }
    String listB = input.toString().replaceAll("[", "").replaceAll("]", "").replaceAll("\n", "").replaceAll(" ", "").toString();
    var b = (listB.split(','));
    return (b.length);
  }

  List<int> ratingCount = [0, 0, 0, 0, 0];    // number of user who give rating 1 to 5
  double productRating = 0;                   // overall rating
  int totalRating = 0;                        // total users who rated product
  String productRatingReview = "";
  @override
  void initState() {
    for(int i = 0; i < 5; i++) {
      ratingCount[i] = widget.data['productRating${i+1}'].toString().replaceAll('[', '').replaceAll(']', '').isEmpty
          ? 0
          : widget.data['productRating${i+1}'].toString().replaceAll('[', '').replaceAll(']', '').split(',').length;
    }

    totalRating = ratingCount[0] + ratingCount[1] + ratingCount[2] + ratingCount[3] + ratingCount[4];
    totalRating != 0 ? productRating = ((1 * ratingCount[0])
        + (2 * ratingCount[1])
        + (3 * ratingCount[2])
        + (4 * ratingCount[3])
        + (5 * ratingCount[4])) / double.parse(totalRating.toString()): 0;

    productRating = double.parse(productRating.toStringAsFixed(1));

    if(productRating >= 0 && productRating <= 1){
      productRatingReview = "Very Poor";
    }
    else if(productRating > 1 && productRating <= 2){
      productRatingReview = "Poor";
    }
    else if(productRating > 2 && productRating <= 3){
      productRatingReview = "Average";
    }
    else if(productRating > 3 && productRating <= 4){
      productRatingReview = "Good";
    }
    else if(productRating > 4 && productRating <= 5){
      productRatingReview = "Very Good";
    }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.purple.shade900,
            )
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 15.0),
            child: InkWell(
                onTap: () async {
                  // final pdfFile = await PdfInvoiceApi.generate(invoice);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                    height: 35,
                    width: 35,
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            width: 0.2,
                            color: Colors.grey
                        )
                    ),
                    child: Image.asset("assets/print.gif", height: 20, width: 20, fit: BoxFit.fitWidth)
                )
            ),
          )
        ],
      ),

      body: backGroundTheme(
          child: Padding(
            padding: const EdgeInsets.only(top: 45.0, right: 10, left: 10, bottom: 5),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.network(widget.data['productImg'])),
                  Divider(color: Colors.purple.shade900, thickness: 0.5),
                  //Name
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.purple.shade900, width: 0.1)
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: Row(
                            children: [
                              const Text("Name "),
                              Expanded(child: Container()),
                              const Text(" : ")
                            ],
                          ),
                        ),
                        Text(widget.type == "Seeds" ? "${widget.data['productName']} Seeds" : "${widget.data['productName']}", style: TextStyle(
                            color: Colors.purple.shade900,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                      ],
                    )
                  ),

                  //Type
                  (widget.type == "Chemicals") ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.purple.shade900, width: 0.1)
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: Row(
                            children: [
                              const Text("Type"),
                              Expanded(child: Container()),
                              const Text(" : ")
                            ],
                          ),
                        ),
                        Text(widget.data['chemicalType'],
                            style: TextStyle(
                                color: Colors.purple.shade900,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ) : Container(),

                  //State
                  (widget.type != "Equipments" && widget.type != "Seeds") ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.purple.shade900, width: 0.1)
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: Row(
                            children: [
                              const Text("State"),
                              Expanded(child: Container()),
                              const Text(" : ")
                            ],
                          ),
                        ),
                        Text(widget.data['isSolid'], style: TextStyle(
                            color: Colors.purple.shade900,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ) : Container(),

                  //Prize
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.purple.shade900, width: 0.1)
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: Row(
                            children: [
                              const Text("Prize"),
                              Expanded(child: Container()),
                              const Text(" : ")
                            ],
                          ),
                        ),
                        Text("₹${widget.data['productPrize']}",
                            style: TextStyle(color: Colors.red.shade900,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                  // Rating
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.purple.shade900, width: 0.1)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        const Text("Product Rating :"),
                        const SizedBox(height: 2),
                        Divider(color: Colors.purple.shade900, thickness: 0.2, height: 10),
                        const SizedBox(height: 2),
                        totalRating != 0 ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Center(
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.width - 41) / 3,
                                child: Column(
                                  children: [
                                    Text(
                                        productRatingReview.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16
                                        ),
                                        textAlign: TextAlign.center
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                        width: 120,
                                        child: Divider(
                                          thickness: 0.2,
                                          color: Colors.purple.shade900,
                                          height: 1,
                                        )
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            productRating.toString(),
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: -1
                                            )
                                        ),
                                        const SizedBox(width: 5),
                                        Image.asset("assets/star.gif", height: 40, width: 40),
                                      ],
                                    ),
                                    Text(
                                        "$totalRating Rating's",
                                        style: TextStyle(color: Colors.grey.shade700)
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2 * (MediaQuery.of(context).size.width - 41) / 3,
                              child: Column(
                                verticalDirection: VerticalDirection.down,
                                children: List.generate(
                                    5,
                                    (index) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              "${index + 1}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15
                                              )
                                          ),
                                          Image.asset(
                                              "assets/star.gif",
                                              height: 18,
                                              width: 18
                                          ),
                                          const SizedBox(width: 5),
                                          Container(
                                            width: MediaQuery.of(context).size.width / 3,
                                            height: 5,
                                            decoration: BoxDecoration(
                                                color: Colors.purple.shade900,
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                              ratingCount[index].toString(),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade700
                                              )
                                          )
                                        ],
                                      );
                                    }
                                ),
                              ),
                            ),
                          ],
                        ) : const Text(
                            "No ratings yet ... ",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                            )
                        ),
                        const SizedBox(height: 5),
                      ],
                    )
                  ),

                  //Quantity
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.purple.shade900, width: 0.1)
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: Row(
                            children: [
                              const Text("Quantity"),
                              Expanded(child: Container()),
                              const Text(" : ")
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 151,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.data['productQuantityLastAdded'],
                                    style: TextStyle(
                                      color: Colors.green.shade900,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  Text(
                                    " (Last Added)",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500
                                    )
                                  )
                                ]
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.data['productTotalAdded'],
                                    style: TextStyle(
                                      color: Colors.green.shade900,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  Text(
                                    " (Total Added)",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500
                                    )
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.data['productAvailableQuantity'],
                                    style: TextStyle(
                                      color: Colors.green.shade900,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  Text(
                                    " (Total Available)",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500
                                    )
                                  )
                                ]
                              ),
                              const SizedBox(height: 5),
                              Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  border: Border.all(color: Colors.purple.shade900, width: 0.2),
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if((changeProductAvailability + int.parse(widget.data['productAvailableQuantity'])) > 0) {
                                              setState(() {
                                                changeProductAvailability--;
                                              });
                                            }
                                          },
                                          onLongPress: () {
                                            if((changeProductAvailability + int.parse(widget.data['productAvailableQuantity'])) < 5) {
                                              setState(() {
                                                changeProductAvailability = (0 - int.parse(widget.data['productAvailableQuantity']));
                                              });
                                            }
                                            else if((changeProductAvailability + int.parse(widget.data['productAvailableQuantity'])) > 0) {
                                              setState(() {
                                                changeProductAvailability -= 5;
                                              });
                                            }
                                          },
                                          child: Icon(Icons.remove_circle, color: Colors.red.shade900)
                                        ),
                                        const SizedBox(width: 5),

                                        Text(
                                          (changeProductAvailability + int.parse(widget.data['productAvailableQuantity'])).toString(),
                                          style: TextStyle(
                                            color: Colors.purple.shade900,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        const SizedBox(width: 5),

                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              changeProductAvailability++;
                                            });
                                          },
                                          onLongPress: () {
                                            setState(() {
                                              changeProductAvailability += 5;
                                            });
                                          },
                                          child: Icon(Icons.add_circle, color: Colors.green.shade900)
                                        ),
                                      ],
                                    ),

                                    InkWell(
                                      onTap: () {
                                        CollectionReference product = FirebaseFirestore.instance.collection(widget.type);
                                        if(changeProductAvailability != 0) {
                                          product.doc(widget.data.id).update({
                                            'productQuantityLastAdded': changeProductAvailability.toString(),
                                            'productTotalAdded': (changeProductAvailability + int.parse(widget.data['productTotalAdded'])).toString(),
                                            'productAvailableQuantity': (changeProductAvailability + int.parse(widget.data['productAvailableQuantity'])).toString()
                                          }).then((value) {
                                            customToastMsg("Product availability changed");
                                          }).onError((error, stackTrace) {
                                            customToastMsg(error.toString());
                                          });
                                        }

                                      },
                                      onLongPress: () {
                                        customToastMsg("Change product count . . .");
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.purple.shade900,
                                          border: Border.all(color: Colors.blue.shade50, width: 0.2),
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: Text(
                                          "Change availability",
                                          style: TextStyle(color: Colors.grey.shade50, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Manufacturer
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.purple.shade900, width: 0.1)
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: Row(
                            children: [
                              const Text("Manufacturer"),
                              Expanded(child: Container()),
                              const Text(" : ")
                            ],
                          ),
                        ),
                        Text(widget.data['productManufacturer'],
                            style: TextStyle(color: Colors.green.shade900,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                  //Content
                  (widget.type != "Equipments" && widget.type != "Seeds") ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.purple.shade900, width: 0.1)
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: Row(
                            children: [
                              const Text("Content"),
                              Expanded(child: Container()),
                              const Text(" : ")
                            ],
                          ),
                        ),
                        Text(widget.data['productContent'],
                            style: TextStyle(
                                color: Colors.purple.shade900,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ) : Container(),

                  //Instructions
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.purple.shade900, width: 0.1)
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: Row(
                            children: [
                              const Text("Instructions"),
                              Expanded(child: Container()),
                              const Text(" : ")
                            ],
                          ),
                        ),
                        Text(widget.data['productInstructionsToUse'],
                            style: TextStyle(
                                color: Colors.purple.shade900,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                  //Used For
                  (widget.type == "Chemicals" || widget.type == "Animal Products") ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5
                    ),
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.purple.shade900, width: 0.1)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 110,
                          child: Row(
                            children: [
                              const Text("Used For"),
                              Expanded(child: Container()),
                              const Text(" : ")
                            ],
                          ),
                        ),
                        SizedBox(
                          height: widget.type == "Chemicals" ? 200 : 135,
                          width: MediaQuery.of(context).size.width - 151,
                          child: GridView.builder(
                              itemCount: listCountFromDB(input: widget.data['usedFor'].toString()),
                              padding: const EdgeInsets.all(0),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 4/1
                              ),
                              itemBuilder: (context, index) {
                                String listB = widget.data['usedFor'].toString().replaceAll("[", "").replaceAll("]", "").replaceAll("\n", "").replaceAll(" ", "").toString();
                                var b = (listB.split(','));
                                return Text(b[index].toString(), style: TextStyle(color: Colors.purple.shade900, fontWeight: FontWeight.w500, fontSize: 16));
                              },
                          ),
                        )
                      ],
                    ),
                  ) : Container(),

                  //  wishlist count
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.purple.shade900, width: 0.1)
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: Row(
                            children: [
                              const Text("Wishlist Count"),
                              Expanded(child: Container()),
                              const Text(" : ")
                            ],
                          ),
                        ),
                        Text(
                            listCountFromDB(input: widget.data['wishlist']).toString(),
                            style: TextStyle(
                              color: Colors.purple.shade900,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            )
                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),
          )
      ),
    );
  }
}