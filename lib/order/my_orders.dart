import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart' as intl;
import 'package:user/common_widget.dart';
import 'package:flutter/material.dart';
import 'order_detail.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {

  final orders = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade500,
        elevation: 1,
        title: const Text("My Orders"),
        centerTitle: true,
        leading: goBack(context),
      ),
      body: backGroundTheme(
          child: StreamBuilder(
            stream: orders.collection('Order').where('customerId', isEqualTo: _auth.currentUser!.uid).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData) {
                  return Center(
                      child : Image.asset(
                          "assets/animated_icon/loading.gif",
                          height: 80,
                          width: 80
                      )
                  );
              }
              else if(snapshot.hasData) {
                  final allOrders = snapshot.data!.docs;
                  allOrders.sort((a, b) => DateTime.parse(b['orderPlacedDate']).compareTo(DateTime.parse(a['orderPlacedDate'])));
                  return allOrders.isNotEmpty ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      physics: const BouncingScrollPhysics(),
                      itemCount: allOrders.length,
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 0.1)
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OrderDetail(orderData: allOrders[index]))
                          ),
                          child: ListTile(
                            leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: Colors.black, width: 1)
                                ),
                                child: Center(
                                    child: Text(
                                        "${index + 1}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500
                                        )
                                    )
                                )
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                    "Order Id : ${allOrders[index].id}",
                                    style: TextStyle(
                                        color: Colors.red.shade900,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    )
                                ),
                                Text(
                                    "Order amount : ₹${allOrders[index]['orderAmount']}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15
                                    )
                                ),
                                !allOrders[index]['orderDenied'] ? Row(
                                  children: [
                                    Text(
                                        intl.DateFormat('MMM d, y').format(DateTime.parse(allOrders[index]['orderPlacedDate'])),
                                        style: const TextStyle(fontSize: 14)
                                    ),
                                    allOrders[index]['orderDelivered'] ? Text(
                                        " | ${intl.DateFormat('MMM d, y').format(DateTime.parse(allOrders[index]['orderPlacedDate']))}",
                                        style: const TextStyle(fontSize: 14)
                                    ) : const SizedBox(height: 0, width: 0),
                                  ],
                                ) : Text(
                                    "Order denied / canceled",
                                    style: TextStyle(
                                        color: Colors.red.shade900,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                  ) : Center(
                      child: Text(
                          "No orders found . . .",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: darkGreen
                          )
                      ),
                  );
              }
              else {
                  return const Center(
                      child: Text("Error while loading data"),
                  );
              }

            }
          )
      ),
    );
  }
}
