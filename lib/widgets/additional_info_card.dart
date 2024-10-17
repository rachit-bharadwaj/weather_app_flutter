import 'package:flutter/material.dart';

class AdditionalInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AdditionalInfoCard({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(icon, size: 30),
      Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
      Text(
        value,
        style: const TextStyle(fontSize: 16),
      ),
    ]);
  }
}
