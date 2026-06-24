import 'package:flutter/material.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 10,
        children: [
          _buildPaymentMethodIcon('assets/images/Paypal.png', 'PayPal'),
          _buildPaymentMethodIcon('assets/images/Visa.png', 'Visa'),
          _buildPaymentMethodIcon('assets/images/Mastercard.png', 'Mastercard'),
          _buildPaymentMethodIcon('assets/images/GPay.png', 'Google Pay'),
          _buildPaymentMethodIcon('assets/images/ApplePay.png', 'Apple Pay'),
          _buildPaymentMethodIcon('assets/images/Amex.png', 'Amex'),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodIcon(String imagePath, String label) {
    return Container(
      width: 48,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Tooltip(
        message: label,
        child: Center(
          child: _getPaymentIcon(label),
        ),
      ),
    );
  }

  Widget _getPaymentIcon(String label) {
    switch (label) {
      case 'PayPal':
        return const Text('PP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF003087)));
      case 'Visa':
        return const Text('VISA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF1A1F71)));
      case 'Mastercard':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFFFF5F00), shape: BoxShape.circle)),
            Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFFEB001B), shape: BoxShape.circle)),
          ],
        );
      case 'Google Pay':
        return const Text('G Pay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF4285F4)));
      case 'Apple Pay':
        return const Text('A Pay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10));
      case 'Amex':
        return const Text('AMEX', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF006FCF)));
      default:
        return const SizedBox();
    }
  }
}