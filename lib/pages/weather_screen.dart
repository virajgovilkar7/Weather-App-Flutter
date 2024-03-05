import 'dart:convert';
// import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/pages/additional_info_item.dart';
import 'package:weather_app/pages/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/pages/weather_id.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Karli, IN';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occured';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //APPBAR
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          //REFRESH BUTTON
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),

      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.lightBlue,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final currentWeather = data['list'][0];
          //CURRENT TEMP
          final currentTemp = currentWeather['main']['temp'] - 273.15;
          String formattedValue = currentTemp.round().toString();
          //CURRENT SKY
          final currentSky = currentWeather['weather'][0]['main'];
          final pressure = currentWeather['main']['pressure'];
          final windSpeed = currentWeather['wind']['speed'];
          final humidity = currentWeather['main']['humidity'];
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //MAIN CARD
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              //DEGREE TEXT
                              Text(
                                '$formattedValue°C',
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              //CLOUD ICON
                              Icon(
                                currentSky == 'Sunny'
                                    ? Icons.sunny
                                    : currentSky == 'Rain'
                                        ? Icons.cloudy_snowing
                                        : currentSky == 'Clear'
                                            ? Icons.sunny
                                            : currentSky == 'Snow'
                                                ? Icons.cloudy_snowing
                                                : currentSky == 'Thunderstorm'
                                                    ? Icons.thunderstorm_rounded
                                                    : Icons.cloud,
                                size: 64,
                                color: currentSky == 'Sunny'
                                    ? Colors.yellow
                                    : currentSky == 'Rain'
                                        ? Colors.lightBlue
                                        : currentSky == 'Clear'
                                            ? Colors.orange
                                            : currentSky == 'Snow'
                                                ? Colors.white
                                                : currentSky == 'Thunderstorm'
                                                    ? Colors.redAccent
                                                    : const Color.fromARGB(
                                                        255, 162, 221, 244),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              //TEXT
                              Text(
                                '$currentSky',
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                //WEATHER FORECAST
                const Text(
                  'Weather Forecast',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),

                //LIST VIEW
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1];
                      double hourlyTemperature =
                          hourlyForecast['main']['temp'] - 273.15;
                      String tempValueInCel =
                          hourlyTemperature.toStringAsFixed(2);
                      final hourlySky =
                          data['list'][index + 1]['weather'][0]['main'];
                      final time = DateTime.parse(hourlyForecast['dt_txt']);
                      return HourlyForecastItem(
                        time: DateFormat.j().format(time),
                        iconData: hourlySky == 'Sunny'
                            ? Icons.sunny
                            : hourlySky == 'Rain'
                                ? Icons.cloudy_snowing
                                : hourlySky == 'Clear'
                                    ? Icons.sunny
                                    : hourlySky == 'Snow'
                                        ? Icons.cloudy_snowing
                                        : hourlySky == 'Thunderstorm'
                                            ? Icons.thunderstorm_rounded
                                            : Icons.cloud,
                        colors: hourlySky == 'Sunny'
                            ? Colors.yellow
                            : hourlySky == 'Rain'
                                ? Colors.lightBlue
                                : hourlySky == 'Clear'
                                    ? Colors.orange
                                    : hourlySky == 'Snow'
                                        ? Colors.white
                                        : hourlySky == 'Thunderstorm'
                                            ? Colors.redAccent
                                            : Color.fromARGB(
                                                255, 162, 221, 244),
                        temperature: tempValueInCel,
                      );
                    },
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                //ADDITIONAL INFO
                const Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfotItem(
                      iconData: Icons.water_drop,
                      iconx: Colors.lightBlue,
                      label: 'Humidity',
                      value: humidity.toString(),
                    ),
                    AdditionalInfotItem(
                      iconData: Icons.air,
                      iconx: Colors.white70,
                      label: 'Wind Speed',
                      value: windSpeed.toString(),
                    ),
                    AdditionalInfotItem(
                      iconData: Icons.water,
                      iconx: Colors.blueGrey,
                      label: 'Pressure',
                      value: pressure.toString(),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
