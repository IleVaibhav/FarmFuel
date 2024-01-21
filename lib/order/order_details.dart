import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seller/common_widget.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  final orderData;
  const OrderDetails({Key? key, this.orderData}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  final product = FirebaseFirestore.instance;

  bool isOrderConfirmed = false;
  bool isOrderOnTheWay = false;
  bool isOrderDelivered = false;
  bool isOrderDenied = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isOrderConfirmed = widget.orderData['orderConfirmed'];
      isOrderOnTheWay = widget.orderData['orderOnTheWay'];
      isOrderDelivered = widget.orderData['orderDelivered'];
      isOrderDenied = widget.orderData['orderDenied'];
      isOrderDenied = widget.orderData['orderDenied'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.orderData.id),
          backgroundColor: Colors.purple.shade900,
      ),
      body: backGroundTheme(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  // Customer Details
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.purple.shade900,
                            width: 1
                        )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Customer Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple.shade900)),
                        Divider(color: Colors.purple.shade900, thickness: 1, height: 10),
                        Text("Customer name : ${widget.orderData['customerName']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black)),
                        Text("Contact details : ${widget.orderData['customerContact']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black)),
                        Text("Shipping address : ${widget.orderData['customerAddress']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Product Details
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.purple.shade900,
                            width: 1
                        )
                    ),
                    child: StreamBuilder(
                        stream: product.collection(widget.orderData['productType']).doc(widget.orderData['productId']).snapshots(),
                        builder: (context, snapshot) {
                          if(!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.purple.shade900
                              ),
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
                                          Divider(color: Colors.purple.shade900, thickness: 0.1, height: 4),
                                          Text("Contact type : ${orderedProductData['productType']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black), textAlign: TextAlign.end),
                                          Divider(color: Colors.purple.shade900, thickness: 0.1, height: 4),
                                          Text("Prize per product : ₹${orderedProductData['productPrize']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black), textAlign: TextAlign.end),
                                          Divider(color: Colors.purple.shade900, thickness: 0.1, height: 4),
                                          Text("Manufacturer : ${orderedProductData['productManufacturer']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black), textAlign: TextAlign.end),
                                          Divider(color: Colors.purple.shade900, thickness: 0.1, height: 4),
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
                            return Center(
                              child: Text(
                                  "Error while loading data",
                                  style: TextStyle(
                                      color: Colors.purple.shade900,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500
                                  )
                              )
                            );
                          }
                        }
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Order Details
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.purple.shade900,
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
                                color: Colors.purple.shade900
                            )
                        ),
                        Divider(color: Colors.purple.shade900, thickness: 1, height: 10),
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
                        Divider(color: Colors.purple.shade900, thickness: 0.1, height: 4),
                        Text(
                            "Order Placed : ${widget.orderData['orderPlaced']}",
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                            )
                        ),
                        Text(
                            "Order Placed date : ${widget.orderData['orderPlacedDate'].toString().split(' ')[0]}",
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                            )
                        ),
                        Text(
                            "Order Denied : $isOrderDenied",
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                            )
                        ),
                        Divider(color: Colors.purple.shade900, thickness: 0.1, height: 4),
                        Text(
                            "Order Confirmed : $isOrderConfirmed",
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                            )
                        ),
                        isOrderConfirmed ? Text(
                            "Order Confirmed date : ${widget.orderData['orderConfirmedDate'].toString().split(' ')[0]}",
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                            )
                        ) : const SizedBox(height: 0, width: 0),
                        Divider(color: Colors.purple.shade900, thickness: 0.1, height: 4),
                        Text(
                            "Order On the way : $isOrderOnTheWay",
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                            )
                        ),
                        Divider(color: Colors.purple.shade900, thickness: 0.1, height: 4),
                        Text(
                            "Order delivered : $isOrderDelivered",
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                            )
                        ),
                        isOrderDelivered ? Text(
                            "Order Delivered date : ${widget.orderData['orderDeliveredDate'].toString().split(' ')[0]}",
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

                  // Payment Details
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.purple.shade900,
                            width: 1
                        )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Payment Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple.shade900)),
                        Divider(color: Colors.purple.shade900, thickness: 1, height: 10),
                        Text("Payment method : ${widget.orderData['paymentMethod']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black)),
                        Text("Paid amount : ₹${widget.orderData['paidAmount']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black)),
                        Text("Order amount : ₹${widget.orderData['orderAmount']}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  !isOrderConfirmed && !isOrderDenied ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          CollectionReference order = FirebaseFirestore.instance.collection("Order");
                          order.doc(widget.orderData.id).update({
                            'orderConfirmed': true,
                            'orderConfirmedDate': DateTime.now().toString()
                          }).then((value) {
                            setState(() {
                              isOrderConfirmed = true;
                            });
                            customToastMsg("Order Accepted");
                          }).onError((error, stackTrace) {
                            customToastMsg(error.toString());
                          });
                        },
                        onLongPress: () {
                          customToastMsg("Accept Order");
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 40) / 2,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade900,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "Accept",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            )
                          )
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          CollectionReference order = FirebaseFirestore.instance.collection("Order");
                          order.doc(widget.orderData.id).update({
                            'orderDenied': true
                          }).then((value) {
                            setState(() {
                              isOrderDenied = true;
                            });
                            customToastMsg("Order Denied");
                          }).onError((error, stackTrace) {
                            customToastMsg(error.toString());
                          });
                        },
                        onLongPress: () {
                          customToastMsg("Order Denied");
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 40) / 2.1,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade900,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "Decline",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            )
                          )
                        ),
                      )
                    ],
                  )
                  : !isOrderOnTheWay && !isOrderDenied ? InkWell(
                    onTap: () {
                      CollectionReference order = FirebaseFirestore.instance.collection("Order");
                      order.doc(widget.orderData.id).update({
                        'orderOnTheWay': true
                      }).then((value) {
                        setState(() {
                          isOrderOnTheWay = true;
                        });
                        customToastMsg("Order Status updated to \"On The Way\"");
                      }).onError((error, stackTrace) {
                        customToastMsg(error.toString());
                      });
                    },
                    onLongPress: () {
                      customToastMsg("Decline Order");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade900,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "On The Way",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ),
                  )
                  : !isOrderDelivered && !isOrderDenied ? InkWell(
                    onTap: () {
                      CollectionReference order = FirebaseFirestore.instance.collection("Order");
                      order.doc(widget.orderData.id).update({
                        'orderDelivered': true,
                        'orderDeliveredDate': DateTime.now().toString()
                      }).then((value) {
                        setState(() {
                          isOrderDelivered = true;
                        });
                        customToastMsg("Order Delivered Successfully");
                      }).onError((error, stackTrace) {
                        customToastMsg(error.toString());
                      });
                    },
                    onLongPress: () {
                      customToastMsg("Order Delivered");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade900,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Delivered",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ),
                  ) : const SizedBox(height: 0),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          )
      ),
    );
  }
}
