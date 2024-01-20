import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user/common_widget.dart';
import '../top_navigation.dart';

class OrderDelivery extends StatefulWidget {
  final productData;
  final productCount;
  const OrderDelivery({Key? key, this.productData, this.productCount}) : super(key: key);

  @override
  State<OrderDelivery> createState() => _OrderDeliveryState();
}

class _OrderDeliveryState extends State<OrderDelivery> {

bool isProceedPressed = false;

    final Razorpay _razorpay = Razorpay();

    void _handlePaymentSuccess(PaymentSuccessResponse response) {
        // Do something when payment succeeds
    }

    void _handlePaymentError(PaymentFailureResponse response) {
        // Do something when payment fails
    }

    void _handleExternalWallet(ExternalWalletResponse response) {
        // Do something when an external wallet is selected
    }

    @override
    void initState() {
        _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
        _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
        _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
        super.initState();
    }

    @override
    void dispose() {
        _razorpay.clear();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                leading: goBack(context),
                elevation: 0,
                backgroundColor: Colors.blue.shade500,
            ),
            body: backGroundTheme(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: darkGreen,
                                        width: 1
                                    )
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                            "Customer Details",
                                            style: TextStyle(
                                                color: darkGreen,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold
                                            ),
                                        ),
                                        Divider(color: darkGreen.withOpacity(0.2), thickness: 0.2),
                                        Text(
                                            "Name : ${userData['name']}",
                                            style: TextStyle(
                                                color: darkGreen,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500
                                            ),
                                        ),
                                        Text(
                                            "Delivery Address : ${userData['address']}",
                                            style: TextStyle(
                                                color: darkGreen,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500
                                            ),
                                        ),
                                        Text(
                                            "Contact number : ${userData['mobile']}",
                                            style: TextStyle(
                                                color: darkGreen,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500
                                            ),
                                        ),
                                    ],
                                )
                            ),
                            const SizedBox(height: 15),

                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    border: Border.all(color: darkGreen,  width: 1),
                                    borderRadius: BorderRadius.circular(15.0)
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                            "Product Details",
                                            style: TextStyle(
                                                color: darkGreen,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold
                                            ),
                                        ),
                                        Divider(color: darkGreen.withOpacity(0.2), thickness: 0.2),
                                        Row(
                                            children: [
                                                Image.network(widget.productData['productImg'], height: 170, width: 170),
                                                Expanded(
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                            Text(
                                                                "Product : ${widget.productData['productName']}",
                                                                style: TextStyle(
                                                                    color: darkGreen,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500
                                                                ),
                                                            ),
                                                            Text(
                                                                "Prize : ₹${widget.productData['productPrize']} per product",
                                                                style: TextStyle(
                                                                    color: darkGreen,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500
                                                                ),
                                                                textAlign: TextAlign.end,
                                                            ),
                                                            Text(
                                                                "Manufacturer : ${widget.productData['productManufacturer']}",
                                                                style: TextStyle(
                                                                    color: darkGreen,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500
                                                                ),
                                                                textAlign: TextAlign.end,
                                                            ),
                                                            Divider(color: darkGreen, thickness: 1, height: 10),
                                                            Text(
                                                                "Total Products : ${widget.productCount}",
                                                                style: TextStyle(
                                                                    color: darkGreen,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500
                                                                ),
                                                            ),
                                                            Text(
                                                                "Total prize : ₹${int.parse(widget.productData['productPrize']) * widget.productCount}",
                                                                style: TextStyle(
                                                                    color: darkGreen,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500
                                                                ),
                                                            )
                                                        ],
                                                    ),
                                                ),
                                            ],
                                        )
                                    ],
                                ),
                            ),
                            const SizedBox(height: 10),
                            !isProceedPressed ? Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                        isProceedPressed = true;
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade50,
                                        shadowColor: darkGreen,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: darkGreen,
                                                width: 0.2
                                            ),
                                            borderRadius: BorderRadius.circular(8)
                                        )
                                    ),
                                    child: Text(
                                        "Proceed",
                                        style: TextStyle(
                                            color: darkGreen,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                        ),
                                    )
                                ),
                            ) :
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                    ElevatedButton(
                                        onPressed: () {
                                            CollectionReference newOrder = FirebaseFirestore.instance.collection("Order");
                                            newOrder.add({
                                                'paymentMethod': 'Cash On Delivery',
                                                'customerId': userData['user_id'],
                                                'customerName': userData['name'],
                                                'customerContact': userData['mobile'],
                                                'customerAddress': userData['address'],
                                                'sellerId': widget.productData['addedByUID'],
                                                'productId': widget.productData.id,
                                                'productCount': widget.productCount.toString(),
                                                'paidAmount': '0',
                                                'orderAmount': widget.productCount * int.parse(widget.productData['productPrize']),
                                                'orderPlacedDate': DateTime.now().toString(),
                                                'orderPlaced': true,
                                                'orderConfirmed': false,
                                                'orderConfirmedDate': "",
                                                'orderOnTheWay': false,
                                                'orderDelivered': false,
                                                'orderDeliveredDate': "",
                                                'orderDenied': false,
                                                'productType': widget.productData['productType']
                                            }).then((value) {
                                                CollectionReference editProductDetails = FirebaseFirestore.instance.collection(widget.productData['productType']);
                                                var updatedProductCount = int.parse(widget.productData['productAvailableQuantity']) - widget.productCount;
                                                editProductDetails.doc(widget.productData.id).update({
                                                    'productAvailableQuantity': updatedProductCount.toString()
                                                }).then((value) {
                                                    final DatabaseReference userDetails = FirebaseDatabase.instance.ref('User');
                                                    int orderCount = int.parse(userData['order_count'].toString());
                                                    orderCount++;
                                                    debugPrint("$orderCount");
                                                    userDetails.child(userData['user_id']).update({
                                                        'order_count': orderCount.toString()
                                                    });
                                                }).onError((error, stackTrace) {
                                                    customToastMsg(error.toString());
                                                });
                                                customToastMsg("Order placed successfully . . .");
                                                Navigator.of(context).pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) => const Navigation()
                                                    ),
                                                   (Route route) => false
                                                );
                                            }).onError((error, stackTrace) {
                                                customToastMsg(error.toString());
                                            });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey.shade50,
                                            shadowColor: darkGreen,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: darkGreen,
                                                    width: 0.2
                                                ),
                                                borderRadius: BorderRadius.circular(8)
                                            )
                                        ),
                                        child: Text(
                                            "Cash On Delivery",
                                            style: TextStyle(
                                                color: darkGreen,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500
                                            ),
                                        )
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                            var options = {
                                                'key': 'rzp_test_R56w3rnf7a78N8',
                                                'amount': widget.productCount * int.parse(widget.productData['productPrize']) * 100, //in the smallest currency sub-unit.
                                                'name': widget.productData['addedByEmail'],
                                                'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
                                                'description': 'Fine T-Shirt',
                                                'timeout': 120, // in seconds
                                                'prefill': {
                                                    'contact': '9123456789',
                                                    'email': 'gaurav.kumar@example.com'
                                                }
                                            };
                                            _razorpay.open(options);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey.shade50,
                                            shadowColor: darkGreen,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: darkGreen,
                                                    width: 0.2
                                                ),
                                                borderRadius: BorderRadius.circular(8)
                                            )
                                        ),
                                        child: Text(
                                            "Pay Now",
                                            style: TextStyle(
                                                color: darkGreen,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500
                                            ),
                                        )
                                    ),
                                ],
                            ),
                            const SizedBox(height: 50)
                        ],
                    ),
                  ),
                )
            )
        );
    }
}
