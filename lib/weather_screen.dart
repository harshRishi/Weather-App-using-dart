import "dart:convert";
import "dart:ui";
import "package:flutter/material.dart";
import "package:weather_app/additional_info_card.dart";
import "package:weather_app/hourly_forecast_card.dart";

import "package:weather_app/secrets.dart";
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weatherData;

  Future<Map<String, dynamic>> _getCurrentWeather() async {
    String cityName = 'London';
    try {
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherApiKey'),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw "An unexpected error occured!";
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weatherData = _getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weatherData = _getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      // use for api request and get data
      body: FutureBuilder(
        future: weatherData,
        builder: (context, snapshot) {
          // this checks the request status
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              // adaptive will give IOS style loader on apple and android type on android
              child: CircularProgressIndicator.adaptive(),
            );
          }

          // has error in request
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          // get data from api - we can also use snapshot.hasData
          final data = snapshot
              .data!; // this ! remarks the dart that this can't be a null value

          final currWeatherData = data['list'][0];
          final currtemp = currWeatherData['main']['temp'];
          final currCondition = currWeatherData['weather'][0]['main'];
          final currPressure = currWeatherData['main']['pressure'];
          final currHumidity = currWeatherData['main']['humidity'];
          final currWindSpeed = currWeatherData['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5.0,
                          sigmaY: 5.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currtemp k',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 32),
                              ),
                              Icon(
                                currCondition == "Rain"
                                    ? Icons.cloudy_snowing
                                    : currCondition == "Clouds"
                                        ? Icons.cloud
                                        : Icons.sunny,
                                size: 64,
                              ),
                              Text(
                                currCondition,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Weather Forecast",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    // scroll in case cards overflow horizontally
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data['cnt'],
                        itemBuilder: (context, i) {
                          final hourlyForecastData = data['list'][i];
                          final weatherCondition =
                              hourlyForecastData['weather'][0]['main'];
                          final time =
                              DateTime.parse(hourlyForecastData['dt_txt']);
                          return HourlyForeCastCard(
                            time: DateFormat.Hm().format(time),
                            icon: weatherCondition == "Rain"
                                ? Icons.cloudy_snowing
                                : weatherCondition == "Clouds"
                                    ? Icons.cloud
                                    : Icons.sunny,
                            temp: '${hourlyForecastData['main']['temp']}',
                          );
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Additional Information",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceAround, // works as justified-content
                      children: [
                        AdditionalInfoItem(
                          icon: Icons.water_drop_rounded,
                          label: "Humidity",
                          value: '$currHumidity',
                        ),
                        AdditionalInfoItem(
                          icon: Icons.air,
                          label: "Wind Speed",
                          value: '$currWindSpeed',
                        ),
                        AdditionalInfoItem(
                          icon: Icons.beach_access,
                          label: "Pressure",
                          value: '$currPressure',
                        ),
                      ],
                    )
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
