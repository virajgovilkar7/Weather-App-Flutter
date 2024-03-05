import "package:flutter/material.dart";

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData iconData;
  final Color colors;
  final String temperature;
  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.iconData,
    required this.colors,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 8,
            ),
            //ICON
            Icon(
              iconData,
              size: 32,
              color: colors,
            ),
            const SizedBox(
              height: 8,
            ),
            //TEXT
            Text(
              temperature,
            ),
          ],
        ),
      ),
    );
  }
}
