import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:seller/common_widget.dart';
import 'package:seller/download.dart';
import 'package:seller/product/add_equipments.dart';
import 'package:seller/product/add_fertilizer.dart';
import 'package:seller/product/add_seeds.dart';
import 'add_animal_product.dart';
import 'add_chemicals.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  DatabaseReference sellerDetails = FirebaseDatabase.instance.ref('Seller');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final products = FirebaseFirestore.instance;

  bool isAddButtonExpand = false;

  bool showAllChemicals = false;
  bool showAllFertilizers = false;
  bool showAllFarmTools = false;
  bool showAllSeeds = false;
  bool showAllAnimalProduct = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          toolbarHeight: 90,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue.shade50,
          centerTitle: true,
          titleSpacing: 0,
          title: StreamBuilder(
            stream: sellerDetails.child(_auth.currentUser!.uid).onValue,
            builder: (context, AsyncSnapshot snapshot) {
              if(!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.purple.shade900,
                  ),
                );
              }
              else if(snapshot.hasData) {
                Map<dynamic, dynamic> sellerData = snapshot.data!.snapshot.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width / 2.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.purple.shade900,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                              "Total Product",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                              )
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Divider(color: Colors.white, thickness: 0.3),
                          ),
                          Text(
                              sellerData['product_count'].toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24
                              )
                          ),
                        ],
                      ),
                    ),

                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width / 2.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.purple.shade900,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                              "Total Order",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                              )
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Divider(color: Colors.white, thickness: 0.3),
                          ),
                          Text(
                              sellerData['order_count'].toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              else {
                return const Center(
                  child: Text("Something went wrong"),
                );
              }
            },
          ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
              Expanded(child: Container()),

              Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                      Expanded(child: Container()),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.linear,
                        reverseDuration: const Duration(milliseconds: 400),
                        child: SizedBox(
                          height: isAddButtonExpand ? 500 : 0,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                  ElevatedButton(
                                      onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const AddChemicals())
                                          );
                                      },
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.blue.shade700),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(500))
                                          ),
                                      ),
                                      child: const Text("Add Chemicals")
                                  ),

                                  ElevatedButton(
                                      onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const AddFertilizer())
                                          );
                                      },
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.blue.shade700),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(500))
                                          ),
                                      ),
                                      child: const Text("Add Fertilizers"),
                                  ),

                                  ElevatedButton(
                                      onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const AddEquipments())
                                          );
                                      },
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.blue.shade700),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(500))
                                          ),
                                      ),
                                      child: const Text("Add Farming Tools")
                                  ),

                                  ElevatedButton(
                                      onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const AddSeed())
                                          );
                                      },
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.blue.shade700),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(500))
                                          ),
                                      ),
                                      child: const Text("Add Seeds")
                                  ),

                                  ElevatedButton(
                                      onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const AddAnimalProduct())
                                          );
                                      },
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.blue.shade700),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(500))
                                          ),
                                      ),
                                      child: const Text("Add Animal Products")
                                  )
                              ],
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          ElevatedButton(
                            onLongPress: () {
                              customToastMsg('Download all product data as Excel Sheet');
                            },
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const DownloadProduct())
                              );
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(500),
                                        side: BorderSide(color: Colors.purple.shade900, width: 0.5)
                                    )
                                )
                            ),
                            child: Icon(Icons.file_download_outlined, size: 25, color: Colors.purple.shade900)
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                              onLongPress: () {
                                customToastMsg('Add Product');
                              },
                              onPressed: () {
                                  setState(() {
                                    isAddButtonExpand = !isAddButtonExpand;
                                  });
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.purple.shade900),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(500),
                                          side: const BorderSide(color: Colors.white, width: 0.5)
                                      )
                                  )
                              ),
                              child: Transform.rotate(
                                  angle: isAddButtonExpand ? pi/4 : 0,
                                  child: const Icon(Icons.add, size: 30)
                              ),
                              // child: isAddButtonExpand ? const Text("X", style: TextStyle(fontSize: 19)) : const Icon(Icons.add, size: 30)
                          ),
                        ],
                      ),
                  ],
              ),

          ],
        ),
      ),

      body: backGroundTheme(
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 50, right: 5, left: 5),
          child: Column(
            children: [
                const SizedBox(height: 5),
                //chemicals
                customInkwell(
                    showText: "  Chemicals : ",
                    onTap: () {
                      setState(() {
                        isAddButtonExpand = false;
                        showAllChemicals = !showAllChemicals;
                        showAllFertilizers = false;
                        showAllFarmTools = false;
                        showAllSeeds = false;
                        showAllAnimalProduct = false;
                      });
                    },
                    showAll: showAllChemicals
                ),
                const SizedBox(height: 5),
                showAllChemicals ? customGridViewBuilder(type: "Chemicals") : Container(),
                Divider(color: Colors.purple.shade900, thickness: 0.3),

                //Fertilizers
                customInkwell(
                    showText: "  Fertilizers : ",
                    onTap: () {
                      setState(() {
                        isAddButtonExpand = false;
                        showAllFertilizers = !showAllFertilizers;
                        showAllChemicals = false;
                        showAllFarmTools = false;
                        showAllSeeds = false;
                        showAllAnimalProduct = false;
                      });
                    },
                    showAll: showAllFertilizers
                ),
                const SizedBox(height: 5),
                showAllFertilizers ? customGridViewBuilder(type: "Fertilizers") : Container(),
                Divider(color: Colors.purple.shade900, thickness: 0.3),

                //Farming Tools
                customInkwell(
                    showText: "  Farming Tools : ",
                    onTap: () {
                      setState(() {
                        isAddButtonExpand = false;
                        showAllFarmTools = !showAllFarmTools;
                        showAllChemicals = false;
                        showAllFertilizers = false;
                        showAllSeeds = false;
                        showAllAnimalProduct = false;
                      });
                    },
                    showAll: showAllFarmTools
                ),
                const SizedBox(height: 5),
                showAllFarmTools ? customGridViewBuilder(type: "Equipments") : Container(),
                Divider(color: Colors.purple.shade900, thickness: 0.3),

                //Seeds
                customInkwell(
                    showText: "  Seeds : ",
                    onTap: () {
                      setState(() {
                        isAddButtonExpand = false;
                        showAllSeeds = !showAllSeeds;
                        showAllChemicals = false;
                        showAllFertilizers = false;
                        showAllFarmTools = false;
                        showAllAnimalProduct = false;
                      });
                    },
                    showAll: showAllSeeds
                ),
                const SizedBox(height: 5),
                showAllSeeds ? customGridViewBuilder(type: "Seeds") : Container(),
                Divider(color: Colors.purple.shade900, thickness: 0.3),

                //Animal Product
                customInkwell(
                    showText: "  Animal Products : ",
                    onTap: () {
                      setState(() {
                        isAddButtonExpand = false;
                        showAllAnimalProduct = !showAllAnimalProduct;
                        showAllChemicals = false;
                        showAllFertilizers = false;
                        showAllFarmTools = false;
                        showAllSeeds = false;
                      });
                    },
                    showAll: showAllAnimalProduct
                ),
                const SizedBox(height: 5),
                showAllAnimalProduct ? customGridViewBuilder(type: "Animal Products") : Container(),

            ],
          ),
        )
      ),
    );
  }
}