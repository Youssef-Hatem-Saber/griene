import 'package:flutter/material.dart';
import 'package:griene/Warning.dart';
import 'package:griene/calculate.dart';
import 'package:griene/clothes.dart';
import 'package:griene/plantPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const
        MyHomePage(title: 'الصفحة الرئيسية'),

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,

 // تحديد اتجاه النص للصفحة بالكامل
        ),
      );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double tempr = 0;
  String temperature = 'جاري التحميل...';
  String weatherStatus = '';
  String? weatherIcon;
  String humidity = 'جاري التحميل...';
  String windSpeed = 'جاري التحميل...';
  String precipitation = 'جاري التحميل...';
  String advice = 'جاري التحميل...';

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedTemperature = prefs.getString('temperature');
    String? storedWeatherStatus = prefs.getString('weatherStatus');


    const apiKey = 'a20392e762dd2b45c59dc37e7f25708a'; // Replace with your OpenWeatherMap API key
    const city = 'cairo'; // Replace with your desired city name
    const url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=ar';
    prefs.setString("cityName", city);
    try {
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
          tempr = temp;
          temperature = '$temp°C';
          weatherStatus = weatherDesc;
          weatherIcon = weatherIconCode;
          humidity = '$hum%';
          windSpeed = '$wind م/ث';
          precipitation = rain;
        });
        prefs.setDouble("temp", tempr);
        prefs.setString('temperature', temperature);
        prefs.setString('weatherStatus', weatherStatus);
        prefs.setString('humidity', weatherIcon!);
        prefs.setString('humidity', humidity);
        prefs.setString('windSpeed', weatherStatus);
        prefs.setString('precipitation', precipitation);



      } else {
        setState(() {
          temperature = 'فشل في تحميل البيانات';
          weatherStatus = '';
          weatherIcon = null;
          temperature = storedTemperature!;
          weatherStatus = storedWeatherStatus! ;
          Fluttertoast.showToast(
            msg: "تاكد من اتصال الانترنت",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        });
      }
    } on SocketException {
      weatherIcon = null;
      if(storedTemperature == null && storedWeatherStatus == null){
        setState(() {
        temperature = 'فشل في تحميل البيانات';
        weatherStatus = '';
        Fluttertoast.showToast(
          msg: "تاكد من اتصال الانترنت",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
      }else{
        temperature = storedTemperature!;
        weatherStatus =storedWeatherStatus!;
      }

    }
  }
  String getWeatherIconUrl() {
    final iconUrl = 'http://openweathermap.org/img/w/$weatherIcon.png';
    return iconUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Griene',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('الإعدادات'),
              onTap: () {
                // إضافة وظيفة للانتقال إلى صفحة الإعدادات
              },
            ),
            ListTile(
              title: const Text('حول'),
              onTap: () {
                // إضافة وظيفة للانتقال إلى صفحة حول التطبيق
              },
            ),
            ListTile(
              title: const Text('ملاحظات'),
              onTap: () {
                // إضافة وظيفة للانتقال إلى صفحة الملاحظات
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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

                  Image.asset('asset/Alert.png',
                    width: 200,
                    height: 200,),
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
          const SizedBox(height: 20.0),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(10.0),
              children: [
                HomePageButton(
                  icon: Icons.calculate_outlined,
                  label: 'حاسبة إطلاق الغاز',
                  onPressed: () {
                    // إضافة وظيفة للانتقال إلى صفحة حاسبة إطلاق الغازات
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GasReleasePage()),
                    );
                  },
                ),
                HomePageButton(
                  icon: Icons.cloud,
                  label: 'التكيف مع الطقس',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Clothes()),
                    );
                  },
                ),
                HomePageButton(
                  icon: Icons.warning,
                  label: 'التنبيهات الجوية',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  const WeatherAlertsPage()),
                    );
                  },
                ),
                HomePageButton(
                  icon: Icons.agriculture,
                  label: 'مساعد الزراعة',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  plantPage()),
                    );
                    },
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}

class HomePageButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const HomePageButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0, color: Colors.white),
            const SizedBox(height: 8.0),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
