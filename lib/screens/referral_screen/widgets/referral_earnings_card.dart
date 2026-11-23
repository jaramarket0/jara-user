import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/referral_screen/controller/referral_earnings_controller.dart';

/// Referral earnings at a glance: total paid into the wallet, what is still
/// pending on friends' orders, and how many friends joined. Pass [onTap] to
/// make it open Refer & Earn (wallet screen); leave it null on that screen.
/// Refreshes the totals each time it appears.
class ReferralEarningsCard extends StatefulWidget {
  final VoidCallback? onTap;

  const ReferralEarningsCard({super.key, this.onTap});

  @override
  State<ReferralEarningsCard> createState() => _ReferralEarningsCardState();
}

class _ReferralEarningsCardState extends State<ReferralEarningsCard> {
  @override
  void initState() {
    super.initState();
    ReferralEarningsController.to.fetch();
  }

  static String _naira(double v) {
    final whole = v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2);
    final parts = whole.split('.');
    final grouped = parts[0].replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
    return '₦$grouped${parts.length > 1 ? '.${parts[1]}' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    final c = ReferralEarningsController.to;
    final onTap = widget.onTap;
    return Material(
      color: const Color(0xFFFFF8EC),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x4DFFAA00)),
          ),
          child: Obx(() => Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                        color: Color(0x26FFAA00), shape: BoxShape.circle),
                    child: const Icon(Icons.card_giftcard_rounded,
                        color: Color(0xFFFFAA00)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Referral earnings',
                            style: TextStyle(
                                fontSize: 13, color: Color(0xff6B7280))),
                        const SizedBox(height: 2),
                        Text(
                          c.isLoading.value && c.totalEarned.value == 0
                              ? '...'
                              : _naira(c.totalEarned.value),
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xff1F2937)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_naira(c.pending.value)} pending · '
                          '${c.referralsCount.value} '
                          '${c.referralsCount.value == 1 ? 'friend' : 'friends'} joined',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xff6B7280)),
                        ),
                      ],
                    ),
                  ),
                  if (onTap != null)
                    const Icon(Icons.chevron_right_rounded,
                        color: Color(0xFFFFAA00)),
                ],
              )),
        ),
      ),
    );
  }
}
