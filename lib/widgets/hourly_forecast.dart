import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String time;
  final String temp;
  final String icon;

  const HourlyForecast(
      {super.key, required this.time, required this.temp, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Container(
        width: 100,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Text(time, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          Image.network(
            "https://openweathermap.org/img/wn/$icon.png",
          ),
          const SizedBox(height: 20),
          Text("$temp°C", style: const TextStyle(fontSize: 16)),
        ]),
      ),
    );
  }
}
