// lib/widgets/balance_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BalanceCard extends StatelessWidget {
  final String balance;
  final String subtitle;
  final bool isBalanceVisible;
  final VoidCallback onToggleVisibility;

  const BalanceCard({
    Key? key,
    required this.balance,
    required this.subtitle,
    required this.isBalanceVisible,
    required this.onToggleVisibility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 145,
      padding: const EdgeInsets.only(left: 20, top: 15, bottom: 17, right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: const AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
          //  opacity: 0.1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Available Balance',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
              IconButton(
                icon: Icon(
                  isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                  size: 14,
                ),
                onPressed: onToggleVisibility,
              ),
            ],
          ),
          //const SizedBox(height: 8),
          Text(
            isBalanceVisible ? '₦$balance' : '****',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
            ),
          ),
          //const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
