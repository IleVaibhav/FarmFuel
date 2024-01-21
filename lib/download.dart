import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller/common_widget.dart';

class DownloadProduct extends StatefulWidget {
  const DownloadProduct({Key? key}) : super(key: key);

  @override
  State<DownloadProduct> createState() => _DownloadProductState();
}

class _DownloadProductState extends State<DownloadProduct> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final products = FirebaseFirestore.instance;

  final productTypes = [
    "Chemicals",
    "Fertilizers",
    "Equipments",
    "Seeds",
    "Animal Products"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        title: const Text("Download Product Data"),
        centerTitle: true
      ),

      body: backGroundTheme(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            productTypes.length,
            (index) => Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(
                  color: Colors.purple.shade900,
                  width: 0.5
                ),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: [
                  Text(
                    productTypes[index] == "Equipments" ? "Farming Tools" : productTypes[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade900
                    ),
                  ),
                  Expanded(child: Container()),
                  StreamBuilder(
                    stream: products.collection(productTypes[index].toString()).where('addedByUID', isEqualTo: _auth.currentUser!.uid).snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(!snapshot.hasData) {
                        return Container(
                            height: 20,
                            width: 20,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: Colors.purple.shade900,
                              strokeWidth: 2.5
                            )
                        );
                      }
                      else if(snapshot.hasData) {
                        var allProducts = snapshot.data!.docs;
                        return allProducts.isEmpty
                            ? const Text("No Products Found")
                            : Icon(Icons.download_rounded, color: Colors.purple.shade900);
                      }
                      else {
                        return const Center(
                          child: Text(
                            "Error while loading data"
                          )
                        );
                      }
                    }
                  )
                ],
              ),
            )
        )
        )
      ),
    );
  }
}
