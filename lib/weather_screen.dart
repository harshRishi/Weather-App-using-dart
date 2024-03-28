import "dart:ui";
import "package:flutter/material.dart";
import "package:weather_app/additional_info_card.dart";
import "package:weather_app/hourly_forecast_card.dart";

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  void _refreshData() {
    print("Refresh Data");
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
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "300K",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 32),
                          ),
                          Icon(
                            Icons.cloud,
                            size: 64,
                          ),
                          Text(
                            "Rain",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Weather Forecast",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // scroll in case cards overflow horizontally
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal, // make scroll axis horizontal
              child: Row(
                children: [
                  HourlyForeCastCard(
                    time: '09:00',
                    icon: Icons.cloud,
                    temp: '230.32',
                  ),
                  HourlyForeCastCard(
                    time: '12:00',
                    icon: Icons.sunny,
                    temp: '230.32',
                  ),
                  HourlyForeCastCard(
                    time: '13:00',
                    icon: Icons.sunny_snowing,
                    temp: '230.32',
                  ),
                  HourlyForeCastCard(
                    time: '15:00',
                    icon: Icons.air,
                    temp: '230.32',
                  ),
                  HourlyForeCastCard(
                    time: '17:00',
                    icon: Icons.cloud,
                    temp: '230.32',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Additional Information",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround, // works as justified-content
              children: [
                AdditionalInfoItem(
                  icon: Icons.water_drop_rounded,
                  label: "Humidity",
                  value: "94",
                ),
                AdditionalInfoItem(
                  icon: Icons.air,
                  label: "Wind Speed",
                  value: "7.67",
                ),
                AdditionalInfoItem(
                  icon: Icons.beach_access,
                  label: "Pressure",
                  value: "1006",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
