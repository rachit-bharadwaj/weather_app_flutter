import 'dart:convert';
import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/widgets/additional_info_card.dart';
import 'package:weather_app/widgets/hourly_forecast.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  int temp = 0;
  String iconCode = "";
  String cityName = "Bengaluru"; // default city
  TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cityController.text = cityName; // Initialize with default city
    getWeatherData(cityName);
  }

  Future<Map<String, dynamic>> getWeatherData(String city) async {
    String apiKey = dotenv.env['API_KEY'] ?? "";

    Map<String, dynamic> data = {};

    try {
      final res = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric",
      ));

      data = jsonDecode(res.body);

      if (data["cod"] != "200") {
        throw Exception(data["message"]);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return data;
  }

  void fetchWeather() {
    setState(() {
      cityName = cityController.text; // Update cityName with user input
      getWeatherData(cityName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => {fetchWeather()},
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cityController,
                      decoration: InputDecoration(
                        labelText: "Enter city name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: fetchWeather,
                  )
                ],
              ),
            ),
            FutureBuilder(
                future: getWeatherData(cityName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }

                  if (snapshot.hasData == false) {
                    return const Center(child: Text("Something went wrong"));
                  }

                  final data = snapshot.data;
                  temp = data!["list"][0]['main']['temp'].round();
                  iconCode = data["list"][0]["weather"][0]["icon"];
                  final currSky = data["list"][0]["weather"][0]["main"];
                  final weatherIconUrl =
                      "https://openweathermap.org/img/wn/$iconCode@2x.png";
                  final currPressure = data["list"][0]["main"]["pressure"];
                  final windSpeed = data["list"][0]["wind"]["speed"];
                  final humidity = data["list"][0]["main"]["humidity"];
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Center(
                                        child: Text(
                                      "$temp°C",
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                    const SizedBox(height: 10),
                                    Image.network(
                                      weatherIconUrl,
                                      height: 100,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      currSky,
                                      style: const TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Hourly Forecast",
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (int i = 1; i < 6; i++)
                                HourlyForecast(
                                  time: DateFormat.Hm().format(DateTime.parse(
                                      data["list"][i]["dt_txt"])),
                                  icon: iconCode,
                                  temp: data["list"][i]["main"]["temp"]
                                      .round()
                                      .toString(),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Additional Information",
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AdditionalInfoCard(
                                icon: Icons.water_drop,
                                label: "Humidity",
                                value: humidity.toString(),
                              ),
                              AdditionalInfoCard(
                                icon: Icons.air,
                                label: "Wind Speed",
                                value: windSpeed.toString(),
                              ),
                              AdditionalInfoCard(
                                icon: Icons.beach_access,
                                label: "Pressure",
                                value: currPressure.toString(),
                              ),
                            ])
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
