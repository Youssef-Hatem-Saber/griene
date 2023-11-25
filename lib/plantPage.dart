import 'dart:html';

import 'package:flutter/material.dart';
import 'package:griene/plant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class plantPage extends StatefulWidget {

  plantPage({super.key});

  @override
  State<plantPage> createState() => _plantPageState();
}

class _plantPageState extends State<plantPage> {

  @override
  Widget build(BuildContext context) {
    // Plant plant = Plant();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // double? temp = prefs.getDouble("temp");
    //
    // late String month = Plant().getMonthName(DateTime.now().month);
    //
    // late bool rice = plant.pRice(month, temp!);
    //
    //
    return Scaffold(
      appBar: AppBar(
        title: const Text('مساعد الزراعة'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.black,
      body: const Center(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "يمكن زراعة هذه النباتات في هذا الوقت من العام",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white, // لون النص
                fontSize: 35,
                fontWeight: FontWeight.bold,

              ),
            ),
          ),


        ],
      )),
    );
  }
}
class PlantCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String description;

  PlantCard({super.key,
    required this.imageAsset,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green, // لون الكارت
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white, // لون النص
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white, // لون النص
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  imageAsset,
                  height: 150, // ارتفاع الصورة
                  width: 100, // عرض الصورة
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
