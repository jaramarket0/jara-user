import 'package:flutter/material.dart';

class MeasurementSelector extends StatelessWidget {
  final List<String> measurements;
  final String selectedMeasurement;
  final Function(String) onMeasurementChanged;

  const MeasurementSelector({
    Key? key,
    required this.measurements,
    required this.selectedMeasurement,
    required this.onMeasurementChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: measurements.map((measurement) {
        final isSelected = measurement == selectedMeasurement;
        return GestureDetector(
          onTap: () => onMeasurementChanged(measurement),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isSelected ? Colors.orange : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              measurement,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}