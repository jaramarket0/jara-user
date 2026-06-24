import 'package:flutter/material.dart';

class SummaryBreakdown extends StatelessWidget {
  final double itemsTotal;
  final double serviceChargePercentage;
  final double deliveryFee;
  final double mealPrep;
  final double total;

  const SummaryBreakdown({
    Key? key,
    required this.itemsTotal,
    required this.serviceChargePercentage,
    required this.deliveryFee,
    required this.mealPrep,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Items',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
            Text('\u20A6${itemsTotal.toStringAsFixed(0)}'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Service Charge',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
            Text('\u20A6${serviceChargePercentage.toStringAsFixed(0)}(10%)'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Meal Preparation',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
            Text('\u20A6${mealPrep.toStringAsFixed(0)}'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Delivery Fee',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
            Text('\u20A6${deliveryFee.toStringAsFixed(0)}'),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 2),
          // child: Divider(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\u20A6${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Text(
                  'VAT included',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

