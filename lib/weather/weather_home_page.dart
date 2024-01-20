import 'dart:async';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'forecast_card.dart';
import 'header.dart';
import 'icons.dart';
import 'info_card.dart';
import 'loading_page.dart';
import 'weather_api.dart';
import 'weather_service.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {

  WeatherService weatherService = WeatherService();
  Weather weather = Weather();

  String image = '';
  Color defaultColor = Colors.black;
  int hour = 0;
  bool isDay = false;
  bool isNight = false;
  String icon = '';
  bool _isLoading = true;


  Future getWeather() async {
    weather = await weatherService.getWeatherData();
    setState(() {
      getWeather();
      _isLoading = false;
    });
  }

  void setDay() async {
    List datetime = weather.date.split(' ');
    var hours = datetime[1].split(':');
    var turnInt = int.parse(hours[0]);
    if (turnInt >= 19 || turnInt <= 5) {
      debugPrint(turnInt.toString());
      setState(() {
        isDay = false;
        isNight = true;
        defaultColor = nightAppBarColor;
      });
    }
    if (turnInt > 5 && turnInt < 19) {
      setState(() {
        isNight = false;
        isDay = true;
        defaultColor = dayAppBarColor;
      });
    }
  }

  void day() async {
    setState(() {
      defaultColor = dayAppBarColor;
    });
    if (weather.text == 'Sunny') {
      setState(() {
        loadingIcon = sunnyIcon;
      });
    }
    if (weather.text == 'Overcast') {
      setState(() {
        loadingIcon = overcastDayIcon;
      });
    }
    if (weather.text == 'Partly cloud') {
      setState(() {
        loadingIcon = partlyCloudDayIcon;
      });
    }
  }

  void night() async {
    setState(() {
      defaultColor = nightAppBarColor;
    });

    if (weather.text == 'Partly Cloud') {
      setState(() {
        loadingIcon = partlyCloudyIconNight;
      });
    }
    if (weather.text == 'Clear') {
      setState(() {
        loadingIcon = clearNightIcon;
      });
    }
  }

  void getHour() {
    List datetime = weather.date.split(' ');
    var hours = datetime[1].split(':');
    var turnInt = int.parse(hours[0]);
    setState(() {
      hour = turnInt;
    });
  }

  @override
  void initState() {
    getWeather();
    Timer.periodic(const Duration(seconds: 2), (timer) {
      setDay();
    });
    Timer.periodic(const Duration(seconds: 3), (timer) {
      isDay ? day() : night();
    });
    Timer.periodic(const Duration(seconds: 3), (timer) {
      getHour();
    });
    Future.delayed(const Duration(seconds: 2), () async {
      weatherService.getWeatherData;
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _isLoading
    ? const LoadingPage()
    : Scaffold(
    appBar: PreferredSize(
        preferredSize: const Size.fromHeight(300),
        child: Header(
            backgroundColor: defaultColor,
            cityName: weather.city,
            description: weather.text,
            descriptionIMG: loadingIcon,
            stateName: weather.state,
            temp: weather.temp
        )
    ),
    body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          gradient: isDay
              ? LinearGradient(
              begin: const Alignment(-1.5, 8),
              end: const Alignment(-1.5, -0.5),
              colors: [Colors.white, defaultColor])
              : LinearGradient(
              begin: const Alignment(-1.5, 8),
              end: const Alignment(-1.5, -0.5),
              colors: [Colors.white, defaultColor])),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(0, 255, 255, 255),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: weather.forecast.length - hour,
                itemBuilder: (context, index) => SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                  child: Center(
                      child: ForecastCard(
                          hour: weather.forecast[hour + index]['time'].toString().split(' ')[1],
                          averageTemp: weather.forecast[hour + index]['temp_c'],
                          description: weather.forecast[hour + index]['condition']['text'],
                          descriptionIMG: weather.forecast[hour + index]['condition']['icon'].toString().replaceAll('//', 'http://')
                      )
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: InformationCard(
                humidity: weather.humidity,
                uvIndex: weather.uvIndex,
                wind: weather.wind
            )
          )
        ],
      ),
    ),
  );
}
