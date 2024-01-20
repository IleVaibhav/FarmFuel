import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:user/common_widget.dart';
import 'package:user/search_screen.dart';
import 'package:user/shops/all_shops.dart';
import 'package:user/weather/weather_home_page.dart';
import 'package:user/weather/weather_service.dart';
import 'account/account.dart';
import 'fertilizers_seeds/all_fertilizer_seeds.dart';
import 'animals/animals.dart';
import 'chemicals/all_chemicals.dart';
import 'farm_equipment/equipments.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'weather/weather_api.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> with TickerProviderStateMixin {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference userDetails = FirebaseDatabase.instance.ref('User');

  var currentPageIndex = 0;

  final tabName = [
    "Chemicals",
    "Fertilizers",
    "Equipments",
    "Seeds",
    "Animal Home"
  ];

  final tabScreen = const [
    AllChemicals(),
    AllFertilizersAndSeeds(type: "Fertilizers"),
    FarmEquipments(),
    AllFertilizersAndSeeds(type: "Seeds"),
    AnimalsHome()
  ];

  late BannerAd bannerAd;
  bool isAdLoaded = false;

  initBannerAd() {
      bannerAd = BannerAd(
          size: AdSize.banner,
          adUnitId: 'ca-app-pub-3940256099942544/6300978111',
          listener: BannerAdListener(
              onAdLoaded: (ad) {
                  setState(() {
                      isAdLoaded = true;
                  });
              },
              onAdFailedToLoad: (ad, error) {
                  ad.dispose();
                  customToastMsg("Please check your internet connection . . .");
              }
          ),
          request: const AdRequest()
      );

      bannerAd.load();
  }

  WeatherService weatherService = WeatherService();
  Weather weather = Weather();
  Future getWeather() async {
    weather = await weatherService.getWeatherData();
    setState(() {
      getWeather();
    });
  }

  @override
  void initState() {
      super.initState();
      initBannerAd();
      getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: tabName.length,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            backgroundColor: Colors.blue.shade500,
            title: Container(
              width: MediaQuery.of(context).size.width - 200,
              alignment: Alignment.center,
              child: Text(
                  tabName[currentPageIndex],
                  style: const TextStyle(
                      decoration: TextDecoration.underline,
                      decorationThickness: 0.3
                  )
              ),
            ),
            centerTitle: false,

            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WeatherHomePage())
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 11),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 0.1)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.cloud),
                          const SizedBox(width: 5),
                          Text(
                            "${weather.temp}°",
                            style: const TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        weather.city,
                        style: const TextStyle(
                          fontSize: 8
                        ),
                      ),
                      const SizedBox(height: 2)
                    ],
                  ),
                )
              ),
              const SizedBox(width: 7),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(productType: tabName[currentPageIndex]),
                      )
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 11),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 0.1)
                  ),
                  child: const Icon(Icons.search_outlined, size: 26)
                )
              ),
              const SizedBox(width: 10)
            ],

            leading: StreamBuilder(
                stream: userDetails.child(_auth.currentUser!.uid).onValue,
                builder: (context, AsyncSnapshot snapshot) {
                  if(!snapshot.hasData) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3
                      ),
                    );
                  }
                  else if(snapshot.hasData) {
                    userData = snapshot.data!.snapshot.value;
                    selectedLangCode = userData['languageCode'].toString();
                    selectedLangName = userData['languageName'].toString();
                    return Container(
                      margin: const EdgeInsets.all(10),
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Account(data: userData),
                            )
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(userData['image'].toString()),
                          radius: 20,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    );
                  }
                  else {
                    return Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)
                      ),
                    );
                  }
                }
            ),

            bottom: TabBar(
                onTap: (index) {
                  setState(() {
                    currentPageIndex = index;
                  });
                },
                // controller: _tabController,
                labelPadding: const EdgeInsets.only(bottom: 10),
                overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                indicatorWeight: 1,
                tabs: [
                  Container(
                    height: 33,
                    width: 60,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: currentPageIndex == 0 ? Colors.blue.shade50 : Colors.transparent,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Image.asset(
                        "assets/icons/chemical.png",
                        height: 27,
                        width: 27
                    ),
                  ),
                  Container(
                    height: 33,
                    width: 60,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: currentPageIndex == 1 ? Colors.blue.shade50 : Colors.transparent,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Image.asset(
                        "assets/icons/fertilizer.png",
                        height: 25,
                        width: 25
                    ),
                  ),
                  Container(
                    height: 33,
                    width: 60,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: currentPageIndex == 2 ? Colors.blue.shade50 : Colors.transparent,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Image.asset(
                        "assets/icons/farming-tools.png",
                        height: 33,
                        width: 33
                    ),
                  ),
                  Container(
                    height: 33,
                    width: 60,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: currentPageIndex == 3 ? Colors.blue.shade50 : Colors.transparent,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Image.asset(
                        "assets/icons/seed.png",
                        height: 28,
                        width: 28
                    ),
                  ),
                  Container(
                    height: 33,
                    width: 60,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: currentPageIndex == 4 ? Colors.blue.shade50 : Colors.transparent,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Image.asset(
                        "assets/icons/animals.png",
                        height: 30,
                        width: 30
                    ),
                  )
                ]
            ),
          ),

          floatingActionButton: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllShops(),
                    )
                );
              },
              child: Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 0.7)
                  ),
                  child: Image.asset("assets/icons/shop.png")
              )
          ),

          body: TabBarView(
              children: tabScreen,
          ),

          extendBody: true,
          bottomNavigationBar: isAdLoaded ? Container(
              height: bannerAd.size.height.toDouble(),
              width: bannerAd.size.width.toDouble(),
              color: Colors.transparent,
              child: AdWidget(ad: bannerAd),
          )
          : const SizedBox(height: 0),

        ),
      ),
    );
  }
}
