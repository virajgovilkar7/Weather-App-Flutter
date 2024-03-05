import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

class AdditionalInfotItem extends StatelessWidget {
  final IconData iconData;
  final Color iconx;
  final String label;
  final String value;
  const AdditionalInfotItem({
    super.key,
    required this.iconData,
    required this.iconx,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          iconData,
          size: 40,
          color: iconx,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          label,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
