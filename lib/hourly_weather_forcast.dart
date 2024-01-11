import 'package:flutter/material.dart';

class HourlyWeatherForcast extends StatelessWidget {
  final String time;
  final String url;
  final String temp;
  const HourlyWeatherForcast({
    super.key,
    required this.time,
    required this.temp,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 100,
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Image.network(url),
              const SizedBox(height: 10),
              Text(
                temp,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
