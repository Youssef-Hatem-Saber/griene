import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gas Release App',
      theme: ThemeData.dark(),
      home: GasReleasePage(),
    );
  }
}

class GasReleasePage extends StatefulWidget {
  @override
  _GasReleasePageState createState() => _GasReleasePageState();
}

class _GasReleasePageState extends State<GasReleasePage> {
  String resultText = 'لا يمكنك إطلاق الغازات حاليًا ';
  bool isSuitable = false;
   late double concentration;

  @override
  void initState() {
    super.initState();
    checkWeather();
  }

  Future<void> checkWeather() async {
    // Import the required packages
    const String IQAIR_API_KEY = "757b2d5e-fa46-4f29-896c-37a5087a4781"; // Replace with your own API key from IQAir
    const String OPENWEATHER_API_KEY = "a20392e762dd2b45c59dc37e7f25708a"; // Replace with your own API key from OpenWeatherMap
    const String CITY_NAME = "Cairo"; // Replace with the city name you want to check
    const double EMISSION_RATE = 100.0; // The emission rate of the gas in g/s
    const double SOURCE_HEIGHT = 10.0; // The height of the emission source in m
    const double RECEPTOR_X = 100.0; // The x-coordinate of the receptor location in m
    const double RECEPTOR_Y = 0.0; // The y-coordinate of the receptor location in m
    const String GAS_NAME = "CO"; // The name of the gas to check
    const double EXPOSURE_LIMIT = 10.0; // The exposure limit of the gas in mg/m3

    // Define a function to get the AQI value from IQAir API
    Future<int> getAQI(String city) async {
      // Construct the API url
      String url = "https://api.airvisual.com/v2/city?city=$city&key=$IQAIR_API_KEY";
      // Make a GET request and parse the response
      var response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body);
      // Return the AQI value as an integer
      return data["data"]["current"]["pollution"]["aqius"];
    }

    // Define a function to get the wind speed and direction from OpenWeatherMap API
    Future<List<double>> getWind(String city) async {
      // Construct the API url
      String url = "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$OPENWEATHER_API_KEY";
      // Make a GET request and parse the response
      var response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body);
      // Return the wind speed and direction as a list of doubles
      return [data["wind"]["speed"].toDouble(), data["wind"]["deg"].toDouble()];
    }

    // Define a function to calculate the dispersion coefficient using Pasquill-Gifford equation
    double getSigmaY(String stabilityClass, double distance) {
      // Define the coefficients for each stability class
      Map<String, List<double>> coefficients = {
        "A": [213.0, 0.678],
        "B": [156.0, 0.725],
        "C": [104.0, 0.781],
        "D": [68.0, 0.841],
        "E": [50.5, 0.91],
        "F": [34.0, 0.987]
      };
      // Get the corresponding coefficients for the given stability class
      List<double> coef = coefficients[stabilityClass]!;
      // Calculate and return the dispersion coefficient
      return coef[0] * pow(distance, coef[1]);
    }

    // Define a function to calculate the gas concentration using Gaussian Plume equation
    double getConcentration(
        double emissionRate,
        double sourceHeight,
        double windSpeed,
        double windDirection,
        double sigmaY,
        double receptorX,
        double receptorY) {
      // Define the parser and the context model for math expressions
      Parser parser = Parser();
      ContextModel model = ContextModel();

      // Define the math expression for the concentration
      String expression =
          "Q / (2 * pi * U * y) * exp(-0.5 * (H / y)^2) * (exp(-0.5 * ((x - x0) / y)^2) + exp(-0.5 * ((x + x0) / y)^2))";

      // Define the variables and their values
      model.bindVariableName("Q", Number(emissionRate));
      model.bindVariableName("U", Number(windSpeed));
      model.bindVariableName("H", Number(sourceHeight));
      model.bindVariableName("y", Number(sigmaY));
      model.bindVariableName(
          "x", Number(receptorX - receptorY * tan(windDirection * pi / 180)));
      model.bindVariableName("x0", Number(sourceHeight / tan(windDirection * pi / 180)));

      // Evaluate the expression and return the concentration
      Expression exp = parser.parse(expression);
      return exp.evaluate(EvaluationType.REAL, model);
    }

    // Define a function to check if the weather is suitable for gas release
    Future<bool> checkWeather() async {
      // Get the AQI value from IQAir API
      int aqi = await getAQI(CITY_NAME);
      // Get the wind speed and direction from OpenWeatherMap API
      List<double> wind = await getWind(CITY_NAME);
      // Determine the stability class based on the AQI value
      String stabilityClass;
      if (aqi <= 50) {
        stabilityClass = "A";
      } else if (aqi <= 100) {
        stabilityClass = "B";
      } else if (aqi <= 150) {
        stabilityClass = "C";
      } else if (aqi <= 200) {
        stabilityClass = "D";
      } else if (aqi <= 300) {
        stabilityClass = "E";
      } else {
        stabilityClass = "F";
      }

      // Calculate the dispersion coefficient using Pasquill-Gifford equation
      double sigmaY = getSigmaY(stabilityClass, RECEPTOR_X);

      // Calculate the gas concentration using Gaussian Plume equation
       concentration = getConcentration(
          EMISSION_RATE, SOURCE_HEIGHT, wind[0], wind[1], sigmaY, RECEPTOR_X, RECEPTOR_Y);

      // Compare the gas concentration with the exposure limit and return true or false
      return concentration <= EXPOSURE_LIMIT;
    }

    // Call the checkWeather function and update the state
    bool result = await checkWeather();
    setState(() {
      isSuitable = result;
      resultText = isSuitable
          ? "يمكنك إطلاق الغازات الآن ✅"
          : "لا يمكنك إطلاق الغازات حاليًا ❌";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحقق من إطلاق الغازات'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            EquationWidget('المعادلة الحقيقية 1: Q / (2 * pi * U * y) * exp(-0.5 * (H / y)^2) * (exp(-0.5 * ((x - x0) / y)^2) + exp(-0.5 * ((x + x0) / y)^2))',
                'النتيجة الخاصة بالمعادلة 1: ${concentration.toString()}'),
            EquationWidget('المعادلة الحقيقية 2', 'النتيجة الخاصة بالمعادلة 2'),
            EquationWidget('المعادلة الحقيقية 3', 'النتيجة الخاصة بالمعادلة 3'),

            const SizedBox(height: 16),

            // جملة النتيجة والايقونة
            Icon(
              isSuitable ? Icons.check_circle : Icons.cancel,
              color: isSuitable ? Colors.green : Colors.red,
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              resultText,
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class EquationWidget extends StatelessWidget {
  final String equation;
  final String result;

  EquationWidget(this.equation, this.result);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          equation,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 8),
        Text(
          result,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
