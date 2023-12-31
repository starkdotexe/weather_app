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

  Future getCurrentWeather() async {
    String cityName = 'London';
    final res = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName,uk&APPID=$openWeatherAPIKey',
      ),
    );
    print(res.body);
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
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    'Delhi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                  Text(
                    '9° C',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 100),
                  ),
                  Icon(
                    Icons.cloud,
                    size: 100,
                  ),
                  Text(
                    'Clear',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Weather Forcast',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  HourlyWeatherForcast(
                      time: '03:00', icon: Icons.cloud, temp: '10° C'),
                  HourlyWeatherForcast(
                      time: '04:00', icon: Icons.sunny, temp: '20° C'),
                  HourlyWeatherForcast(
                      time: '05:00', icon: Icons.thunderstorm, temp: '22° C'),
                  HourlyWeatherForcast(
                      time: '06:00', icon: Icons.cloud, temp: '24° C'),
                  HourlyWeatherForcast(
                      time: '07:00', icon: Icons.cloud, temp: '25° C'),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Additional Information',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalInfoItem(
                    icon: Icons.water_drop, label: 'humidity', value: '94'),
                AdditionalInfoItem(
                    icon: Icons.air, label: 'Wind Speed', value: '20'),
                AdditionalInfoItem(
                    icon: Icons.beach_access, label: 'Pressure', value: '1006'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
