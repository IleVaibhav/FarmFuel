import 'package:flutter/material.dart';
import 'package:seller/common_widget.dart';
import 'package:seller/order/all_orders.dart';

int allOrderCount = 0;
int todayOrderCount = 0;

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.purple.shade900,
                title: const Text(
                    "Your Orders",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)
                ),
                actions: [
                    Container(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text("Today Order : $todayOrderCount", style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 5),
                                Text("All Order : $allOrderCount", style: const TextStyle(fontSize: 16))
                            ],
                        ),
                    )
                ],
                bottom: TabBar(
                    labelPadding: const EdgeInsets.only(bottom: 10),
                    overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    indicatorColor: Colors.white,
                    tabs: const [
                        Text("Today's Order", style: TextStyle(fontSize: 16)),
                        Text("All Order", style: TextStyle(fontSize: 16)),
                    ],
                ),

            ),

            body: backGroundTheme(
              child: const TabBarView(
                  children: [
                      AllOrders(orderTime: "Today's Order"),
                      AllOrders(orderTime: "All Order")
                  ],
              ),
            ),
        ),
    );
  }
}
