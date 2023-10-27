// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService("d086cb3306e314e4f43f03aa271438dd");
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get city
    String cityName = await _weatherService.getCurrentCity();

    // get weather
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'mist':
      case 'haze':
      case 'fog':
        return 'assets/mist.json';
      case 'dust':
      case 'smoke':
      case 'clouds':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/sunrain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return "assets/sunny.json";
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: "Weather",
                applicationVersion: "1.0",
                applicationLegalese: '''Weather app
Copyright (C) 2023  Mr.X
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.''',
                children: [
                  GestureDetector(
                    onTap: () {
                      launchUrl(
                        Uri.parse("https://github.com/n30mrx/weather"),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Text(
                      "Github link",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  )
                ],
              );
            },
            icon: const Icon(Icons.info_outline_rounded),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // city name
            Text(
              _weather?.cityName ?? "Loading city...",
              style: const TextStyle(
                fontSize: 50,
                fontFamily: "Bebas",
              ),
            ),

            // animation
            Column(
              children: [
                Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                Text(
                  _weather?.mainCondition ?? "",
                  style: const TextStyle(
                    fontSize: 40,
                    fontFamily: "Bebas",
                  ),
                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: Column(
                children: [
                  // temperature
                  Text(
                    "${_weather?.temperture}°C",
                    style: const TextStyle(
                      fontSize: 50,
                      fontFamily: "Bebas",
                    ),
                  ),

                  // condition
                  // Text(
                  //   _weather?.mainCondition ?? "",
                  //   style: const TextStyle(
                  //     fontSize: 40,
                  //     fontFamily: "Bebas",
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
