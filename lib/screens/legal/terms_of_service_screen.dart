import 'package:flutter/material.dart';
import '../../widgets/back_header.dart';
import '../../widgets/custom_button.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BackHeader(title: 'Terms Of Services'),
                  const Text(
                    'Last updated on 18/03/2025',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildClause(
                      'Welcome to JaraMarket!',
                      'By using our platform, you agree to these Terms of Service.',
                    ),
                    const SizedBox(height: 24),
                    _buildClause(
                      '1. Services',
                      'JaraMarket connects users with a selection of food recipes, sources the necessary ingredients, and delivers them through Ryda dispatch. We charge a 10% service fee on the total purchase cost, along with an additional fee for meal preparation services.',
                    ),
                    const SizedBox(height: 24),
                    _buildClause(
                      '2. User Responsibilities',
                      'Please provide accurate delivery information.\n\nMake sure you are available to receive your orders.\n\nPayment for orders must be completed before fulfillment.\n\nUse JaraMarket solely for personal or authorized purposes.',
                    ),
                    const SizedBox(height: 24),
                    _buildClause(
                      '3. Order Processing & Delivery',
                      'Orders will be processed once payment is confirmed.\n\nDelivery times may vary depending on your location and item availability.\n\nIf an item is out of stock, we may offer a replacement or a refund.',
                    ),
                    const SizedBox(height: 24),
                    _buildClause(
                      '4. Cancellations & Refunds',
                      'Once an order is processed, it cannot be canceled.\n\nRefunds will only be issued for items that are unavailable or in cases of service failures.',
                    ),
                    const SizedBox(height: 24),
                    _buildClause(
                      '5. Liability',
                      'JaraMarket is not liable for delays caused by third-party logistics or unforeseen events. While we aim for quality, we cannot guarantee that ingredients will meet specific dietary requirements.',
                    ),
                    const SizedBox(height: 24),
                    _buildClause(
                      '6. Account Suspension',
                      'We reserve the right to suspend accounts in cases of fraud, policy violations, or abuse of our services.',
                    ),
                    const SizedBox(height: 24),
                    _buildClause(
                      '7. Changes to Terms',
                      'We may revise these Terms at any time. Your continued use of JaraMarket indicates your acceptance of any changes.',
                    ),
                    const SizedBox(height: 24),
                    _buildClause(
                      'For inquiries, please contact jaramarket101@gmail.com.',
                      'By using JaraMarket, you agree to these Terms.',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomButton(
                text: 'Accept',
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClause(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}