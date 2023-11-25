// الكود في الملف الخاص بالشاشة
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Clothes extends StatefulWidget {
  const Clothes({Key? key}) : super(key: key);

  @override
  _ClothesState createState() => _ClothesState();
}

class _ClothesState extends State<Clothes> {
  String temperature = 'جاري التحميل...';
  String weatherStatus = '';
  String? weatherIcon;
  String humidity = 'جاري التحميل...';
  String windSpeed = 'جاري التحميل...';
  String precipitation = 'جاري التحميل...';
  String tempAdvice = '';
  String humAdvice = '';
  String windAdvice = '';
  String rainAdvice = '';

  IconData? iconTemp;
  IconData? iconHum;
  IconData? iconWind;
  IconData? iconRain;

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedTemperature = prefs.getString('temperature');
    String? storedWeatherStatus = prefs.getString('weatherStatus');
    String? storedWeatherIcon = prefs.getString('weatherIcon');
    String? storedHumidity = prefs.getString('humidity');
    String? storedWindSpeed = prefs.getString('windSpeed');
    String? storedPrecipitation = prefs.getString('precipitation');
    String? cityName = prefs.getString("cityName");

    if (storedTemperature != null &&
        storedHumidity != null &&
        storedWindSpeed != null &&
        storedPrecipitation != null &&
        storedWeatherIcon != null &&
        storedWeatherStatus != null) {
      setState(() {
        temperature = storedTemperature;
        humidity = storedHumidity;
        windSpeed = storedWindSpeed;
        precipitation = storedPrecipitation;
        weatherIcon = storedWeatherIcon;
        weatherStatus = storedWeatherStatus;
      });
    } else {
      const apiKey =
          'a20392e762dd2b45c59dc37e7f25708a'; // Replace with your OpenWeatherMap API key
      const city = 'cairo'; // Replace with your desired city name
      const url =
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=ar';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final temp = data['main']['temp'];
        final weatherDesc = data['weather'][0]['description'];
        final weatherIconCode = data['weather'][0]['icon'];
        final hum = data['main']['humidity'];
        final wind = data['wind']['speed'];
        final rain = data['weather'][0]['main'];

        setState(() {
          temperature = '$temp°C';
          humidity = '$hum%';
          windSpeed = '$wind m/s';
          precipitation = rain;
          weatherIcon = weatherIconCode;
          setWeatherAdvice(temp, hum, wind, rain); // قم بإستدعاء الدالة هنا
        });
      } else {
        setState(() {
          temperature = 'فشل في تحميل البيانات';
          humidity = '';
          windSpeed = '';
          precipitation = '';
          tempAdvice = '';
          humAdvice = '';
          windAdvice = '';
          rainAdvice = '';
        });
      }
    }
  }

  void setWeatherAdvice(double temp, int hum, double wind, String rain) {
    iconTemp = Icons.ac_unit;
    iconWind = Icons.air;
    iconHum = Icons.wb_cloudy;
    iconRain = Icons.umbrella;

    // توفير نصائح التكيف مع الطقس حسب البيانات الحالية
    if (temp >= 25) {
      tempAdvice = 'ضرورة ارتداء ملابس خفيفة وشرب الكثير من الماء.';
      iconTemp = Icons.wb_sunny;
    } else if (temp < 25) {
      tempAdvice = 'ضرورة ارتداء ملابس دافئة وتجنب البقاء في الهواء الطلق لفترات طويلة.';
      iconTemp = Icons.severe_cold;
    } else {
      tempAdvice = 'يمكنك ارتداء ملابس مريحة ومناسبة لدرجة الحرارة الحالية.';
      iconTemp = Icons.help_outline;
    }

    if (hum > 80) {
      humAdvice = 'يجب البقاء مترطبًا وشرب السوائل بانتظام.';
      iconHum = Icons.water_drop_outlined;
    } else {
      humAdvice = 'يمكنك الاستمتاع بالجو الرطب بدون قلق كبير.';
      iconHum = Icons.wb_cloudy;
    }

    if (wind > 10) {
      windAdvice = 'ينصح بتثبيت الأشياء الخفيفة في الهواء الطلق وتجنب المناطق المكشوفة.';
      iconWind = Icons.air;
    } else {
      windAdvice = 'يمكنك الاستمتاع بالهواء النقي والمنعش.';
      iconWind = Icons.air_outlined;
    }

    if (rain == 'Rain') {
      rainAdvice = 'يجب اصطحاب مظلة أو ملابس مقاومة للماء.';
      iconRain = Icons.umbrella;
    } else {
      rainAdvice = 'استمتع بيوم جميل ومشمس بدون أمطار.';
      iconRain = Icons.wb_sunny;
    }

    setState(() {});
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('tempAdvice', tempAdvice);
      prefs.setString('humAdvice', humAdvice);
      prefs.setString('windAdvice', windAdvice);
      prefs.setString('rainAdvice', rainAdvice);
    });
  }

  String getWeatherIconUrl() {
    final iconUrl = 'http://openweathermap.org/img/w/$weatherIcon.png';
    return iconUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cairo"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    if (weatherIcon != null)
                      Image.network(
                        getWeatherIconUrl(),
                        width: 200,
                        height: 200,
                      )
                    else
                      Image.asset(
                        'asset/Alert.png',
                        width: 130,
                        height: 200,
                      ),
                    const SizedBox(width: 10.0),
                    Column(
                      children: [
                        Text(
                          temperature,
                          style: const TextStyle(fontSize: 26.0, color: Colors.white),
                        ),
                        const SizedBox(height: 7.0),
                        Text(
                          weatherStatus,
                          style: const TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl, // تحديد اتجاه الصفحة
                child: Card(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'نصائح التكيف مع الطقس:',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                        const SizedBox(height: 10.0),
                        WeatherTipCard(icon: iconTemp!, tip: tempAdvice),
                        WeatherTipCard(icon: iconHum!, tip: humAdvice),
                        WeatherTipCard(icon: iconWind!, tip: windAdvice),
                        WeatherTipCard(icon: iconRain!, tip: rainAdvice),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

class WeatherTipCard extends StatelessWidget {
  final IconData icon;
  final String tip;

  WeatherTipCard({
    required this.icon,
    required this.tip,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 36,
        color: Colors.white,
      ),
      title: Text(
        tip,
        style: const TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );
  }
}
