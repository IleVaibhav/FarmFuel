import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:user/order/delivery_info.dart';
import 'package:user/seller_details.dart';
import 'common_widget.dart';

class ProductDetails extends StatefulWidget {
  final dynamic data;
  final String type;
  const ProductDetails({Key? key, this.data, required this.type}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference userDetails = FirebaseDatabase.instance.ref('User');

  late bool isAddedToWishlist;

  int productCount = 1;
  void increaseProductCount(int productAvailability) {
    if(productCount < productAvailability) {
      setState(() {
        productCount = productCount + 1;
      });
    }
    else {
      customToastMsg("Maximum availability of product is $productAvailability");
    }
  }
  void decreaseProductCount() {
    if(productCount > 1) {
      setState(() {
        productCount = productCount - 1;
      });
    }
    else {
      customToastMsg("Product count does not go below one");
    }
  }
  int calculateFinalPrice(int productPrice) {
    return productCount * productPrice;
  }

  void isAlreadyAddedToWishlist() {
    if(widget.data['wishlist'].contains(_auth.currentUser!.uid)) {
        setState(() {
          isAddedToWishlist = true;
        });
    }
    else {
        setState(() {
            isAddedToWishlist = false;
        });
    }
  }

  int setProductRating = 3;
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 250,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25)
              )
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                  width: 80,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5)
                  )
              ),
              const SizedBox(height: 15),
              const Text(
                  "Give Rating",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  )
              ),
              const SizedBox(height: 15),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      5,
                      (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  setProductRating = index + 1;
                                });
                              },
                              child: Column(
                                  children: [
                                      Image.asset(
                                          setProductRating <= index ? "assets/animated_icon/star_empty.gif" : "assets/animated_icon/star_filled.gif",
                                          height: 50,
                                          width: 50
                                      ),
                                      const SizedBox(height: 10),
                                      Text(index == 0 ? "Very\nPoor"
                                          : index == 1 ? "Poor"
                                          : index == 2 ? "Average"
                                          : index == 3 ? "Good"
                                          : "Very\nGood",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500
                                          ),
                                          textAlign: TextAlign.center
                                      )
                                  ],
                              )
                          )
                      )
                  )
              ),
              const Expanded(child: SizedBox(height: 0, width: 0)),
              InkWell(
                onTap: () {
                  FirebaseFirestore product =  FirebaseFirestore.instance;
                  product.collection(widget.type.toString()).doc(widget.data.id).set(
                    {
                      'productRating$setProductRating': FieldValue.arrayUnion([_auth.currentUser!.uid])
                    },
                    SetOptions(merge: true)
                  ).then((value) {
                    customToastMsg("Rating Submitted");
                    Navigator.of(context).pop();
                    setState(() {
                      isProductRatedByYou = true;
                      yourRating = setProductRating;
                      productRatingOverall = (totalRatingUserCount * productRatingOverall + yourRating) / (totalRatingUserCount + 1);
                      totalRatingUserCount++;
                      ratingCountList[setProductRating - 1]++;
                    });
                  }).onError((error, stackTrace) {
                    customToastMsg(error.toString());
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: darkGreen,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.green.shade50
                      )
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                      "Submit",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      )
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }
    );
  }

  List<int> ratingCountList = [0, 0, 0, 0, 0];    // number of user who give rating 1 to 5
  double productRatingOverall = 0;                // overall rating
  int totalRatingUserCount = 0;                   // total users who rated product
  bool isProductRatedByYou = false;               // check if current user rated a product or not
  int yourRating = 0;                             // rating given by current user
  String productRatingReview = " ";               // review based on rating
  @override
  void initState() {
    isAlreadyAddedToWishlist();

    if(widget.data['productRating1'].contains(_auth.currentUser!.uid)) {
      isProductRatedByYou = true;
      yourRating = 1;
    }
    else if(widget.data['productRating2'].contains(_auth.currentUser!.uid)) {
      isProductRatedByYou = true;
      yourRating = 2;
    }
    else if(widget.data['productRating3'].contains(_auth.currentUser!.uid)) {
      isProductRatedByYou = true;
      yourRating = 3;
    }
    else if(widget.data['productRating4'].contains(_auth.currentUser!.uid)) {
      isProductRatedByYou = true;
      yourRating = 4;
    }
    else if(widget.data['productRating5'].contains(_auth.currentUser!.uid)) {
      isProductRatedByYou = true;
      yourRating = 5;
    }

    for(int i = 0; i < 5; i++) {
      ratingCountList[i] = widget.data['productRating${i+1}'].toString().replaceAll('[', '').replaceAll(']', '').isEmpty
          ? 0
          : widget.data['productRating${i+1}'].toString().replaceAll('[', '').replaceAll(']', '').split(',').length;
    }

    totalRatingUserCount = ratingCountList[0] + ratingCountList[1] + ratingCountList[2] + ratingCountList[3] + ratingCountList[4];
    totalRatingUserCount != 0 ? productRatingOverall = ((1 * ratingCountList[0])
                    + (2 * ratingCountList[1])
                    + (3 * ratingCountList[2])
                    + (4 * ratingCountList[3])
                    + (5 * ratingCountList[4])) / double.parse(totalRatingUserCount.toString()): 0;
    productRatingOverall = double.parse(productRatingOverall.toStringAsFixed(1));

    if(productRatingOverall >= 0 && productRatingOverall <= 1){
      productRatingReview = "Very Poor";
    }
    else if(productRatingOverall > 1 && productRatingOverall <= 2){
      productRatingReview = "Poor";
    }
    else if(productRatingOverall > 2 && productRatingOverall <= 3){
      productRatingReview = "Average";
    }
    else if(productRatingOverall > 3 && productRatingOverall <= 4){
      productRatingReview = "Good";
    }
    else if(productRatingOverall > 4 && productRatingOverall <= 5){
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
          leading: goBack(context),
          actions: [
              if (userData.isNotEmpty)
                InkWell(
                    onTap: () {
                      FirebaseFirestore product =  FirebaseFirestore.instance;

                      setState(() {
                        isAddedToWishlist = !isAddedToWishlist;
                      });

                      product.collection(widget.type.toString()).doc(widget.data.id).set(
                        {
                          'wishlist': isAddedToWishlist
                              ? FieldValue.arrayUnion([_auth.currentUser!.uid])
                              : FieldValue.arrayRemove([_auth.currentUser!.uid])
                        },
                        SetOptions(merge: true)
                      ).then((value) {
                        int wishlistCount = int.parse(userData['wishlist_count'].toString());
                        isAddedToWishlist ? wishlistCount++ : wishlistCount--;
                        userDetails.child(_auth.currentUser!.uid).update({
                          'wishlist_count': wishlistCount.toString()
                        }).then((value) {
                          isAddedToWishlist ? customToastMsg("Added To Cart") : customToastMsg("Removed from Cart");
                        }).onError((error, stackTrace) {
                          customToastMsg(error.toString());
                        });
                      }).onError((error, stackTrace) {
                        setState(() {
                          isAddedToWishlist = !isAddedToWishlist;
                        });
                        customToastMsg(error.toString());
                      });
                    },
                    child: Image.asset(
                      isAddedToWishlist ? "assets/animated_icon/heart.gif" : "assets/animated_icon/heart_white.gif",
                      height: 35,
                      width: 35
                    )
                ),
              const SizedBox(width: 15)
          ],
      ),

      body: backGroundTheme(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //  productImg
                      const SizedBox(height: 50),
                      Center(
                          child: Image.network(widget.data['productImg'].toString())
                      ),

                      Divider(color: Colors.green.shade900, thickness: 0.5),

                      //  productName
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              border: Border.all(
                                  color: Colors.black,
                                  width: 0.2
                              ),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: !(widget.type == "Equipments" || widget.type == "Seeds") ? Text(
                              "${widget.data['productName']} ( ${widget.data['isSolid']} )",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18
                              )
                          ) : Text(
                              widget.data['productName'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18
                              )
                          )
                      ),
                      const SizedBox(height: 5),

                      //  productPrize
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              border: Border.all(
                                  color: Colors.black,
                                  width: 0.2
                              ),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Text("₹${widget.data['productPrize']}",style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 18))
                      ),
                      const SizedBox(height: 5),

                      //  Rating
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            border: Border.all(
                                color: Colors.black,
                                width: 0.2
                            ),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Product Rating",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18
                                  )
                                ),
                                !isProductRatedByYou && userData.isNotEmpty ? InkWell(
                                  onTap: () {
                                    _showBottomSheet(context);
                                  },
                                  child: Container(
                                    width: 100,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: darkGreen, width: 0.3)
                                    ),
                                    child: Text(
                                        "Rate Product",
                                        style: TextStyle(color: darkGreen)
                                    ),
                                  ),
                                ) : const SizedBox(height: 0, width: 0)
                              ],
                            ),
                            const SizedBox(height: 5),
                            Divider(color: darkGreen, thickness: 0.2, height: 10),
                            const SizedBox(height: 5),
                            totalRatingUserCount != 0 ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Center(
                                  child: SizedBox(
                                    width: (MediaQuery.of(context).size.width - 37) / 3,
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
                                                color: darkGreen,
                                                height: 1,
                                            )
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                productRatingOverall.toString(),
                                                style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: -1
                                                )
                                            ),
                                            const SizedBox(width: 5),
                                            Image.asset("assets/animated_icon/star.gif", height: 40, width: 40),
                                          ],
                                        ),
                                        Text(
                                          "$totalRatingUserCount Rating's",
                                          style: TextStyle(color: Colors.grey.shade700)
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2 * (MediaQuery.of(context).size.width - 37) / 3,
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
                                              "assets/animated_icon/star.gif",
                                              height: 18,
                                              width: 18
                                            ),
                                            const SizedBox(width: 5),
                                            Container(
                                              width: MediaQuery.of(context).size.width / 3,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                color: darkGreen,
                                                borderRadius: BorderRadius.circular(10)
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              ratingCountList[index].toString(),
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
                            ) : Column(
                              children: [
                                const Text(
                                  "No ratings yet ... ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                  )
                                ),
                                Text(
                                  "Become first to submit rating",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: darkGreen
                                  )
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            isProductRatedByYou ? Column(
                              children: [
                                Divider(color: darkGreen, thickness: 0.2, height: 10),
                                Text("You Rated this product as $yourRating star"),
                                const SizedBox(height: 5)
                              ],
                            ) : const SizedBox(height: 0, width: 0)
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),

                      //  productQuantity
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              border: Border.all(
                                  color: Colors.black,
                                  width: 0.2
                              ),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Quantity : ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18)),
                              widget.data['productAvailableQuantity'] != '0' ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(color: Colors.black)
                                    ),
                                    height: 40,
                                    child: Row(
                                      children: [
                                        productCount > 1 ? IconButton(
                                            onPressed: decreaseProductCount,
                                            icon: Icon(Icons.remove_circle_outline, color: Colors.red.shade900, size: 20)
                                        ) : const SizedBox(height: 0, width: 20),
                                        Text(productCount.toString(), style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 18)),
                                        productCount < int.parse(widget.data['productAvailableQuantity']) ? IconButton(
                                            onPressed: () {
                                              increaseProductCount(int.parse(widget.data['productAvailableQuantity']));
                                            },
                                            icon: Icon(Icons.add_circle_outline, color: Colors.green.shade900, size: 20)
                                        ) : const SizedBox(height: 0, width: 20)
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                      "Total price : ₹${calculateFinalPrice(int.parse(widget.data['productPrize'])).toString()}",
                                      style: const TextStyle(fontWeight: FontWeight.w500)
                                  )
                                ],
                              )
                              : Text("Product Unavailable", style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18, color: Colors.red.shade900), textAlign: TextAlign.start),
                              widget.data['productAvailableQuantity'] != '0' ? Text("Available ${widget.data['productAvailableQuantity']} units", style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 18)) : const SizedBox(height: 0, width: 0),
                            ],
                          )
                      ),
                      const SizedBox(height: 5),

                      //  addedByEmail
                      Container(
                          width: double.infinity,
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              border: Border.all(
                                  color: Colors.black,
                                  width: 0.2
                              ),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Seller : ${widget.data['addedByEmail']}",style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 18)),
                              IconButton(
                                  onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SellerDetails(sellerUID: widget.data['addedByUID'])));
                                  },
                                  icon: Icon(Icons.double_arrow_rounded, size: 20, color: Colors.blue.shade900,)
                              )
                            ],
                          )
                      ),
                      const SizedBox(height: 5),

                      //  Manufacturer
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              border: Border.all(
                                  color: Colors.black,
                                  width: 0.2
                              ),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Text("Manufacturer : ${widget.data['productManufacturer']}",style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 18))
                      ),
                      const SizedBox(height: 5),

                      //  productContent
                      !(widget.type == "Equipments" || widget.type == "Seeds") ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              border: Border.all(
                                  color: Colors.black,
                                  width: 0.2
                              ),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Content : ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18)),
                              Text(widget.data['productContent'],style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 17))
                            ],
                          ),
                      ) : const SizedBox(height: 0, width: 0),

                      //  usedFor
                      (widget.type == "Chemicals" || widget.type == "Animal Products" || widget.type == "Animal Home") ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              border: Border.all(
                                  color: Colors.black,
                                  width: 0.2
                              ),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Used For : ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18)),
                              Text(widget.data['usedFor'].toString().replaceAll("[", "").replaceAll("]", "").replaceAll("\n", " "),style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 17))
                            ],
                          ),
                      ) : const SizedBox(height: 5, width: 0),

                      //  productInstructionsToUse
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            border: Border.all(
                                color: Colors.black,
                                width: 0.2
                            ),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Instruction's to use : ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18)),
                            Text(widget.data['productInstructionsToUse'],style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 17))
                          ],
                        ),
                      ),
                      // const SizedBox(height: 5),

                    ],
                  ),
                ),
              ),

              if(userData.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0, left: 5, right: 5),
                  child: InkWell(
                    onTap: () {
                      widget.data['productAvailableQuantity'] != '0' ? Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OrderDelivery(productData: widget.data, productCount: productCount))
                      ) : customToastMsg("Products unavailable, can't purchase");
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        height: 40,
                        child: Center(
                            child: Text(
                                "Purchase",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade900
                                )
                            )
                        ),
                    ),
                  ),
                )
            ],
          )
      ),
    );
  }
}
