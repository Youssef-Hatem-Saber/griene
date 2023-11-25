import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WeatherAlertsPage extends StatefulWidget {
  const WeatherAlertsPage({Key? key}) : super(key: key);

  @override
  _WeatherAlertsPageState createState() => _WeatherAlertsPageState();
}

class _WeatherAlertsPageState extends State<WeatherAlertsPage> {
  List<WeatherAlert> weatherAlerts = [];

  @override
  void initState() {
    super.initState();
    fetchWeatherAlerts();
  }

  Future<void> fetchWeatherAlerts() async {
    const String apiKey = 'a20392e762dd2b45c59dc37e7f25708a';
    const String url = 'https://api.openweathermap.org/data/2.5/alerts?appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      weatherAlerts = json['alerts']
          .map((alert) => WeatherAlert(
        title: alert['event'],
        description: alert['description'],
        alertType: alert['event'],
      ))
          .toList();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تنبيهات الطقس'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Center(
            child: WeatherAlertCard()
          )
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}

class WeatherAlert {
  final String title;
  final String description;
  final String alertType;

  WeatherAlert({
    required this.title,
    required this.description,
    required this.alertType,
  });
}

class WeatherAlertCard extends StatelessWidget {

  WeatherAlertCard({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Image.asset(
            'asset/images/earthSmily.png',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 16.0),
          const Text(
            "كل شئ على ما يرام استمتع بيومك",
            style: TextStyle(fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          const SizedBox(height: 16.0),
        ],
    );
  }
}
