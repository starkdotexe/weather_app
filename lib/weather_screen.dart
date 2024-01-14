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
  String cityName = 'delhi';
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&APPID=$openWeatherAPIKey',
        ),
      );
      final res2 = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&units=metric&APPID=$openWeatherAPIKey',
        ),
      );
      final weatherData = jsonDecode(res.body);
      final forecastData = jsonDecode(res2.body);

      return {'weather': weatherData, 'forecast': forecastData};
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
          } else {
            final weatherData = snapshot.data!['weather'];
            final forecastData = snapshot.data!['forecast'];
            final currentTemp = weatherData['main']['temp'];
            final currentSky = weatherData['weather'][0]['main'];
            final humidity = weatherData['main']['humidity'];
            final windSpeed = weatherData['wind']['speed'];
            final pressure = weatherData['main']['pressure'];
            final icon = weatherData['weather'][0]['main'];
            final hourlyForecast = forecastData['list'];
            // final forecastIcon = forecastData['list'][0];

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
                          // Icon(
                          //   currentSky == 'smoke' || currentSky == 'rain'
                          //       ? Icons.cloud
                          //       : Icons.water_rounded,
                          //   size: 100,
                          // ),

                          // getWeatherIcon(currentSky),

                          getWeatherCondition(icon),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0; i < 9; i++)
                            HourlyWeatherForcast(
                              time: hourlyForecast[i]["dt_txt"].toString(),
                              url: getUrl(
                                  hourlyForecast[i]['weather'][0]['main']),
                              temp: hourlyForecast[i]['main']['temp']
                                  .toInt()
                                  .toString(),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Additional Information',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AdditionalInfoItem(
                            icon: Icons.water_drop,
                            label: 'humidity',
                            value: '${humidity.toString()}%'),
                        AdditionalInfoItem(
                            icon: Icons.air,
                            label: 'Wind Speed',
                            value: '${windSpeed.toString()} m/s'),
                        AdditionalInfoItem(
                            icon: Icons.beach_access,
                            label: 'Pressure',
                            value: '${pressure.toString()} hPa'),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

Image getWeatherCondition(String iconMain) {
  switch (iconMain) {
    case 'Thunderstorm':
      return Image.network('https://openweathermap.org/img/wn/11d@2x.png');
    case 'Drizzle':
      return Image.network('https://openweathermap.org/img/wn/09d@2x.png');
    case 'Rain':
      return Image.network('https://openweathermap.org/img/wn/10d@2x.png');
    case 'Snow':
      return Image.network('https://openweathermap.org/img/wn/13d@2x.png');
    case 'Mist' || 'Smoke' || 'Haze' || 'Fog':
      return Image.network('https://openweathermap.org/img/wn/50d@2x.png');
    case 'Clear':
      return Image.network('https://openweathermap.org/img/wn/01d@2x.png');
    case 'Clouds':
      return Image.network('https://openweathermap.org/img/wn/02d@2x.png');
    default:
      return Image.network('');
  }
}

String getUrl(url) {
  switch (url) {
    case 'Thunderstorm':
      return 'https://openweathermap.org/img/wn/11d@2x.png';
    case 'Drizzle':
      return 'https://openweathermap.org/img/wn/09d@2x.png';
    case 'Rain':
      return 'https://openweathermap.org/img/wn/10d@2x.png';
    case 'Snow':
      return 'https://openweathermap.org/img/wn/13d@2x.png';
    case 'Mist' || 'Smoke' || 'Haze' || 'Fog':
      return 'https://openweathermap.org/img/wn/50d@2x.png';
    case 'Clear':
      return 'https://openweathermap.org/img/wn/01d@2x.png';
    case 'Clouds':
      return 'https://openweathermap.org/img/wn/02d@2x.png';
    default:
      return '';
  }
}
