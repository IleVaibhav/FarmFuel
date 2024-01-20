import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:user/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class OrderDetail extends StatefulWidget {
  final orderData;
  const OrderDetail({Key? key, this.orderData}) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  final product = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade500,
        elevation: 1,
        title: Text(widget.orderData.id.toString()),
        centerTitle: true,
        leading: goBack(context),
      ),
      body: backGroundTheme(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: darkGreen,
                                    width: 1
                                )
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text("Customer Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkGreen)),
                                    Divider(color: darkGreen, thickness: 1, height: 10),
                                    Text("Customer name : ${widget.orderData['customerName']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black)),
                                    Text("Contact details : ${widget.orderData['customerContact']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black)),
                                    Text("Shipping address : ${widget.orderData['customerAddress']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black)),
                                ],
                            ),
                        ),
                        const SizedBox(height: 15),

                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: darkGreen,
                                    width: 1
                                )
                            ),
                            child: StreamBuilder(
                                stream: product.collection(widget.orderData['productType']).doc(widget.orderData['productId']).snapshots(),
                                builder: (context, snapshot) {
                                  if(!snapshot.hasData) {
                                    return Center(
                                      child: Image.asset("assets/animated_icon/loading.gif", height: 80, width: 80)
                                    );
                                  }
                                  else if(snapshot.hasData) {
                                    final orderedProductData = snapshot.data;
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Product Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple.shade900)),
                                        Divider(color: Colors.purple.shade900, thickness: 1, height: 10),
                                        Row(
                                          children: [
                                            Image.network(orderedProductData!['productImg'], height: 150, width: 150),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text("Product name : ${orderedProductData['productName']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black), textAlign: TextAlign.end),
                                                  Divider(color: darkGreen, thickness: 0.1, height: 4),
                                                  Text("Contact type : ${orderedProductData['productType']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black), textAlign: TextAlign.end),
                                                  Divider(color: darkGreen, thickness: 0.1, height: 4),
                                                  Text("Prize per product : ₹${orderedProductData['productPrize']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black), textAlign: TextAlign.end),
                                                  Divider(color: darkGreen, thickness: 0.1, height: 4),
                                                  Text("Manufacturer : ${orderedProductData['productManufacturer']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black), textAlign: TextAlign.end),
                                                  Divider(color: darkGreen, thickness: 0.1, height: 4),
                                                  Text("Seller : ${orderedProductData['addedByEmail']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black), textAlign: TextAlign.end),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }
                                  else {
                                    return const Center(
                                      child: Text("Error while loading data"),
                                    );
                                  }
                                }
                            ),
                        ),
                        const SizedBox(height: 15),

                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: darkGreen,
                                    width: 1
                                )
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                        "Order Details",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: darkGreen
                                        )
                                    ),
                                    Divider(color: darkGreen, thickness: 1, height: 10),
                                    Text(
                                        "Ordered product count : ${widget.orderData['productCount']}",
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black
                                        )
                                    ),
                                    Text(
                                        "Order amount : ₹${widget.orderData['orderAmount']}",
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black
                                        )
                                    ),
                                    Divider(color: darkGreen, thickness: 0.1, height: 4),
                                    Text(
                                        "Order Placed : ${widget.orderData['orderPlaced']}",
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black
                                        )
                                    ),
                                    Text(
                                        "Order Placed date : ${intl.DateFormat('MMM d, y').format(DateTime.parse(widget.orderData['orderPlacedDate']))}",
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black
                                        )
                                    ),
                                    Text(
                                        "Order Denied : ${widget.orderData['orderDenied']}",
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black
                                        )
                                    ),
                                    Divider(color: darkGreen, thickness: 0.1, height: 4),
                                    Text(
                                        "Order Confirmed : ${widget.orderData['orderConfirmed']}",
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black
                                        )
                                    ),
                                    widget.orderData['orderConfirmed'] ? Text(
                                        "Order Confirmed date : ${intl.DateFormat('MMM d, y').format(DateTime.parse(widget.orderData['orderConfirmedDate']))}",
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black
                                        )
                                    ) : const SizedBox(height: 0, width: 0),
                                    Divider(color: darkGreen, thickness: 0.1, height: 4),
                                    Text(
                                        "Order On the way : ${widget.orderData['orderOnTheWay']}",
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black
                                        )
                                    ),
                                    Divider(color: darkGreen, thickness: 0.1, height: 4),
                                    Text(
                                        "Order delivered : ${widget.orderData['orderDelivered']}",
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black
                                        )
                                    ),
                                    widget.orderData['orderDelivered'] ? Text(
                                        "Order Delivered date : ${intl.DateFormat('MMM d, y').format(DateTime.parse(widget.orderData['orderDeliveredDate']))}",
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black
                                        )
                                    ) : const SizedBox(height: 0, width: 0)
                                ],
                            ),
                        ),
                        const SizedBox(height: 15),

                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: darkGreen,
                                    width: 1
                                )
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text("Payment Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkGreen)),
                                    Divider(color: darkGreen, thickness: 1, height: 10),
                                    Text("Payment method : ${widget.orderData['paymentMethod']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black)),
                                    Text("Paid amount : ₹${widget.orderData['paidAmount']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black)),
                                    Text("Order amount : ₹${widget.orderData['orderAmount']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black)),
                                ],
                            ),
                        ),
                        const SizedBox(height: 15),

                        !widget.orderData['orderOnTheWay'] ? InkWell(
                          onTap: () {
                            CollectionReference order = FirebaseFirestore.instance.collection("Order");
                            order.doc(widget.orderData.id).update({
                              'orderDenied': true
                            }).then((value) {
                              customToastMsg("Order Canceled");
                            }).onError((error, stackTrace) {
                              customToastMsg(error.toString());
                            });
                          },
                          onLongPress: () {
                            customToastMsg("Cancel Order");
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 40,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: darkGreen, width: 0.2)
                            ),
                            child: Text(
                              "Cancel Order",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: darkGreen
                              ),
                            ),
                          ),
                        ) : const SizedBox(height: 0, width: 0)
                    ],
                ),
              ),
          )
      ),
    );
  }
}
