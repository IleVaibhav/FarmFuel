import 'package:seller/account/account_screen.dart';
import 'package:seller/order/OrderScreen.dart';
import 'package:seller/product/product_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  int currentPageIndex = 0;

  var pages = [ const ProductScreen(),
                const Order(),
                const AccountScreen()];

  void onTap(int index)
  {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: false,
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            height: 50,
            color: Colors.purple.shade900,
            animationDuration: const Duration(milliseconds: 400),
            buttonBackgroundColor: Colors.transparent,
            items: [
              currentPageIndex == 0 ? Container(
                  height: 43,
                  width: 43,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(color: Colors.purple.shade900, width: 0.5)
                  ),
                  child: Image.asset("assets/home.gif")
              )
              : const Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 27
              ),

              currentPageIndex == 1 ? Container(
                  height: 44,
                  width: 44,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(color: Colors.purple.shade900, width: 0.5)
                  ),
                  child: Image.asset("assets/order.gif")
              )
              : const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 27
              ),

              currentPageIndex == 2 ? Container(
                  height: 45,
                  width: 45,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(color: Colors.purple.shade900, width: 0.5)
                  ),
                  child: Image.asset("assets/seller.gif")
              )
              : const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 27
              ),

            ],
            onTap: onTap
        ),
        body: pages[currentPageIndex]
    );
  }
}
