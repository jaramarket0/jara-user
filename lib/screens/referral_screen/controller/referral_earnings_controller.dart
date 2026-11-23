import 'dart:convert';
import 'dart:developer' as myLog;

import 'package:get/get.dart';
import 'package:jara_market/services/api_service.dart';

/// Refer & Earn totals, shared by the wallet and referral screens.
class ReferralEarningsController extends GetxController {
  final ApiService _api = ApiService(const Duration(seconds: 30));

  final RxDouble totalEarned = 0.0.obs;
  final RxDouble pending = 0.0.obs;
  final RxInt referralsCount = 0.obs;
  final RxBool isLoading = false.obs;

  static ReferralEarningsController get to =>
      Get.isRegistered<ReferralEarningsController>()
          ? Get.find<ReferralEarningsController>()
          : Get.put(ReferralEarningsController());

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      final res = await _api.fetchReferralEarnings();
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'] as Map<String, dynamic>?;
        if (data != null) {
          totalEarned.value =
              double.tryParse('${data['total_earned'] ?? 0}') ?? 0;
          pending.value = double.tryParse('${data['pending'] ?? 0}') ?? 0;
          referralsCount.value =
              int.tryParse('${data['referrals_count'] ?? 0}') ?? 0;
        }
      }
    } catch (e) {
      myLog.log('Could not load referral earnings: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
