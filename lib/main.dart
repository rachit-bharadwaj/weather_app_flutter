import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/screens/weather.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const WeatherScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true));
  }
}
