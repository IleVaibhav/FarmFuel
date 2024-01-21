import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller/order/OrderScreen.dart';
import 'order_details.dart';

class AllOrders extends StatefulWidget {
  final orderTime;
  const AllOrders({Key? key, this.orderTime}) : super(key: key);

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {

  final orders = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String orderFilter = 'All';
  var filterTodayOrder = {
    'All',
    'Arrived',
    'Confirmed',
    'Delivered'
  };
  var filterAllOrder = {
    'All',
    'Arrived',
    'Confirmed',
    'On The Way',
    'Delivered',
    'Denied'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Container(
              height: 35,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
              ),
              alignment: Alignment.center,
              child: DropdownButton(
                underline: Container(
                    height: 0,
                    color: Colors.transparent
                ),
                dropdownColor: Colors.blue.shade50,
                value: orderFilter,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.purple.shade900),
                items: (widget.orderTime.toString() == "All Order" ? filterAllOrder : filterTodayOrder).map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(
                        items,
                        style: TextStyle(
                            color: Colors.purple.shade900,
                            fontWeight: FontWeight.w500
                        )
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    orderFilter = newValue!;
                  });
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: orders.collection('Order').where('sellerId', isEqualTo: _auth.currentUser!.uid).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(!snapshot.hasData) {
                        return Center(
                            child : CircularProgressIndicator(
                              color: Colors.purple.shade900,
                            )
                        );
                    }
                    if(snapshot.hasData) {
                        var allOrders = snapshot.data!.docs;

                        //  Sort wrt filter (based on time) (newest to oldest)
                        if(orderFilter == "All") {
                          allOrders.sort((a, b) => DateTime.parse(b['orderPlacedDate']).compareTo(DateTime.parse(a['orderPlacedDate'])));
                        }
                        else if(orderFilter == "Arrived" && widget.orderTime == "Today's Order") {
                          allOrders = allOrders.where(
                            (element) {
                              return !element['orderConfirmed'];
                          }).toList();
                          allOrders.sort((a, b) => DateTime.parse(b['orderPlacedDate']).compareTo(DateTime.parse(a['orderPlacedDate'])));
                        }
                        else if(orderFilter == "Arrived") {
                          allOrders = allOrders.where(
                            (element) {
                              return !element['orderConfirmed'] && !element['orderDenied'];
                          }).toList();
                          allOrders.sort((a, b) => DateTime.parse(b['orderPlacedDate']).compareTo(DateTime.parse(a['orderPlacedDate'])));
                        }
                        else if(orderFilter == "Confirmed") {
                          allOrders = allOrders.where(
                            (element) {
                              return element['orderConfirmed'] && !element['orderOnTheWay'] && !element['orderDelivered'];
                          }).toList();
                          allOrders.sort((a, b) => DateTime.parse(b['orderConfirmedDate']).compareTo(DateTime.parse(a['orderConfirmedDate'])));
                        }
                        else if(orderFilter == "On The Way") {
                          allOrders = allOrders.where(
                            (element) {
                              return element['orderOnTheWay'] && !element['orderDelivered'];
                          }).toList();
                          allOrders.sort((a, b) => DateTime.parse(b['orderConfirmedDate']).compareTo(DateTime.parse(a['orderConfirmedDate'])));
                        }
                        else if(orderFilter == "Delivered") {
                          allOrders = allOrders.where(
                            (element) {
                              return element['orderDelivered'];
                          }).toList();
                          allOrders.sort((a, b) => DateTime.parse(b['orderDeliveredDate']).compareTo(DateTime.parse(a['orderDeliveredDate'])));
                        }
                        else if(orderFilter == "Denied") {
                          allOrders = allOrders.where(
                            (element) {
                              return element['orderDenied'];
                          }).toList();
                          allOrders.sort((a, b) => DateTime.parse(b['orderPlacedDate']).compareTo(DateTime.parse(a['orderDeliveredDate'])));
                        }

                        allOrderCount = allOrders.length;
                        if(widget.orderTime == "Today's Order") {
                          allOrders = allOrders.where(
                            (element) {
                              if(orderFilter == "All") {
                                return (element['orderPlacedDate'].toString().split(' ')[0] == DateTime.now().toString().split(' ')[0])
                                    || (element['orderConfirmedDate'].toString().split(' ')[0] == DateTime.now().toString().split(' ')[0])
                                    || (element['orderDeliveredDate'].toString().split(' ')[0] == DateTime.now().toString().split(' ')[0]);
                              }
                              else if(orderFilter == "Confirmed") {
                                return element['orderConfirmedDate'].toString().split(' ')[0] == DateTime.now().toString().split(' ')[0];
                              }
                              else if(orderFilter == "Delivered") {
                                return element['orderDeliveredDate'].toString().split(' ')[0] == DateTime.now().toString().split(' ')[0];
                              }
                              return element['orderPlacedDate'].toString().split(' ')[0] == DateTime.now().toString().split(' ')[0];
                          }).toList();
                          todayOrderCount = allOrders.length;
                        }

                        return allOrders.isNotEmpty ? ListView.builder(
                            padding: const EdgeInsets.only(bottom: 55),
                            physics: const BouncingScrollPhysics(),
                            itemCount: allOrders.length,
                            itemBuilder: (context, index) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.purple.shade900, width: 0.1),
                                    color: Colors.grey.withOpacity(0.2)
                                ),
                                child: ListTile(
                                    leading: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: Colors.purple.shade900, width: 1)
                                        ),
                                        child: Center(
                                            child: Text(
                                                (index + 1).toString(),
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple.shade900)
                                            )
                                        ),
                                    ),
                                    title: Text(
                                        allOrders[index].id,
                                        style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold)
                                    ),
                                    subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text("Order Amount : ₹${allOrders[index]['orderAmount']} (${allOrders[index]['paymentMethod']})"),
                                            !allOrders[index]['orderDenied'] ? Row(
                                                children: [
                                                    Text("Date : ${allOrders[index]['orderPlacedDate'].toString().split(' ')[0]}"),
                                                    allOrders[index]['orderConfirmed'] ? Text(" | ${allOrders[index]['orderConfirmedDate'].toString().split(' ')[0]}") : const SizedBox(height: 0, width: 0),
                                                    allOrders[index]['orderDelivered'] ? Text(" | ${allOrders[index]['orderDeliveredDate'].toString().split(' ')[0]}") : const SizedBox(height: 0, width: 0)
                                                ],
                                            ) : const Text("Order Denied", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500))
                                        ],
                                    ),
                                    trailing: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 18,
                                        color: Colors.purple.shade900,
                                    ),
                                    onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => OrderDetails(orderData: allOrders[index]))
                                        );
                                    },
                                ),
                            ),
                        ) : Center(
                            child: Text(
                                "No orders found . . .",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple.shade900
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
              ),
            ),
          ],
        ),
    );
  }
}
