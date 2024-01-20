import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user/common_widget.dart';
import 'package:user/product_details.dart';

class AllProduct extends StatefulWidget {
  final title;
  final type;
  final data;
  const AllProduct({Key? key, this.title, this.data, this.type}) : super(key: key);

  @override
  State<AllProduct> createState() => _AllProductState();
}

class _AllProductState extends State<AllProduct> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: backGroundTheme(
          child: GridView.builder(
              padding: const EdgeInsets.all(3),
              itemCount: widget.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: (MediaQuery.of(context).size.width / 9) / (MediaQuery.of(context).size.height / 13)
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductDetails(type: widget.type.toString(), data: widget.data[index]))
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 0.2)
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(widget.data[index]['productImg']),
                          const SizedBox(height: 5),
                          Text(widget.data[index]['productName']),
                          const SizedBox(height: 3),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              int.parse(widget.data[index]['productPrize']) != 0 ? Text("₹${widget.data[index]['productPrize']}") : Text("Unavailable", style: TextStyle(color: Colors.red.shade900)),
                              widget.data[index]['wishlist'].contains(_auth.currentUser!.uid) ? Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: const Text("❤", style: TextStyle(fontSize: 12))
                              ) : Container()
                            ],
                          ),
                          Text(widget.data[index]['productManufacturer'])
                        ],
                      ),
                  ),
                );
              },
          )
      ),
    );
  }
}
