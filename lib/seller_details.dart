import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:user/common_widget.dart';

class SellerDetails extends StatefulWidget {
  final sellerUID;
  const SellerDetails({Key? key, required this.sellerUID}) : super(key: key);

  @override
  State<SellerDetails> createState() => _SellerDetailsState();
}

class _SellerDetailsState extends State<SellerDetails> {

  final DatabaseReference sellerDetail = FirebaseDatabase.instance.ref('Seller');

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: goBack(context),
      ),

      body: backGroundTheme(
        child: StreamBuilder(
          stream: sellerDetail.child(widget.sellerUID.toString()).onValue,
          builder: (context, AsyncSnapshot snapshot) {
            if(!snapshot.hasData) {
              return Center(
                child: Image.asset("assets/animated_icon/loading.gif", width: 100),
              );
            }
            else if(snapshot.hasData) {
              Map<dynamic, dynamic> sellerData = snapshot.data!.snapshot.value;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      sellerData['shopImg'],
                      fit: BoxFit.fill,
                      height: 300,
                      width: 300,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress)
                      {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Divider(color: darkGreen, thickness: 0.3),
                    ),
                    Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        border: Border.all(color: Colors.black, width: 0.2),
                        borderRadius: BorderRadius.circular(40)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              alignment: Alignment.centerRight,
                              width: (MediaQuery.of(context).size.width - 41) / 3,
                              padding: const EdgeInsets.only(right: 25),
                              child: const Icon(Icons.shopping_cart),
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              width: 2 * (MediaQuery.of(context).size.width - 41) / 3,
                              child: Text(sellerData['shop_name'], style: TextStyle(color: darkGreen, fontSize: 17, fontWeight: FontWeight.bold))
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          border: Border.all(color: Colors.black, width: 0.2),
                          borderRadius: BorderRadius.circular(40)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: (MediaQuery.of(context).size.width - 41) / 3,
                            padding: const EdgeInsets.only(right: 25),
                            child: const Icon(Icons.account_circle_rounded),
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              width: 2 * (MediaQuery.of(context).size.width - 41) / 3,
                              child: Text(sellerData['name'], style: TextStyle(color: darkGreen, fontSize: 17, fontWeight: FontWeight.bold))
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          border: Border.all(color: Colors.black, width: 0.2),
                          borderRadius: BorderRadius.circular(40)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: (MediaQuery.of(context).size.width - 41) / 3,
                            padding: const EdgeInsets.only(right: 25),
                            child: const Icon(Icons.mail),
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              width: 2 * (MediaQuery.of(context).size.width - 41) / 3,
                              child: Text(sellerData['email'], style: TextStyle(color: darkGreen, fontSize: 17, fontWeight: FontWeight.bold))
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          border: Border.all(color: Colors.black, width: 0.2),
                          borderRadius: BorderRadius.circular(40)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: (MediaQuery.of(context).size.width - 41) / 3,
                            padding: const EdgeInsets.only(right: 25),
                            child: const Icon(Icons.phone),
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              width: 2 * (MediaQuery.of(context).size.width - 41) / 3,
                              child: Text(sellerData['shop_contact'], style: TextStyle(color: darkGreen, fontSize: 17, fontWeight: FontWeight.bold))
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          border: Border.all(color: Colors.black, width: 0.2),
                          borderRadius: BorderRadius.circular(40)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: (MediaQuery.of(context).size.width - 41) / 3,
                            padding: const EdgeInsets.only(right: 25),
                            child: const Icon(Icons.location_on_sharp),
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              width: 2 * (MediaQuery.of(context).size.width - 41) / 3,
                              child: Text(sellerData['shop_address'], style: TextStyle(color: darkGreen, fontSize: 17, fontWeight: FontWeight.bold))
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
            else {
              return Center(
                child: Text(
                  "Something Went wrong",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
