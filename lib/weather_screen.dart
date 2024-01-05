import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather_app/secrets.dart';
import 'additional_info_item.dart';
import 'hourly_weather_forcast.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'delhi';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&units=metric&APPID=$openWeatherAPIKey',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] == '200') {
        return data;
      } else {
        throw 'an unexpected error occured';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          )
        ],
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        const Text(
                          'Delhi',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40),
                        ),
                        Text(
                          '${currentTemp.toInt()}° C',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 100),
                        ),
                        Icon(
                          currentSky == 'clouds' || currentSky == 'rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          size: 100,
                        ),
                        Text(
                          currentSky,
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Weather Forcast',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  const SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        HourlyWeatherForcast(
                            time: '03:00', icon: Icons.cloud, temp: '10° C'),
                        HourlyWeatherForcast(
                            time: '04:00', icon: Icons.sunny, temp: '20° C'),
                        HourlyWeatherForcast(
                            time: '05:00',
                            icon: Icons.thunderstorm,
                            temp: '22° C'),
                        HourlyWeatherForcast(
                            time: '06:00', icon: Icons.cloud, temp: '24° C'),
                        HourlyWeatherForcast(
                            time: '07:00', icon: Icons.cloud, temp: '25° C'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Additional Information',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AdditionalInfoItem(
                          icon: Icons.water_drop,
                          label: 'humidity',
                          value: '94'),
                      AdditionalInfoItem(
                          icon: Icons.air, label: 'Wind Speed', value: '20'),
                      AdditionalInfoItem(
                          icon: Icons.beach_access,
                          label: 'Pressure',
                          value: '1006'),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
