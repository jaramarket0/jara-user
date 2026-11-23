import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/referral_screen/controller/referral_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:jara_market/screens/referral_screen/models/models.dart';
import 'package:jara_market/screens/referral_screen/controller/referral_earnings_controller.dart';
import 'package:jara_market/screens/referral_screen/widgets/referral_earnings_card.dart';

ReferralController controller = Get.put(ReferralController());

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get.arguments is only a head start from the profile screen; the
    // authoritative value is the one the controller fetches.
    final passedIn = Get.arguments is String ? Get.arguments as String : '';
    String _code() => controller.referralCode.value.isNotEmpty
        ? controller.referralCode.value
        : passedIn;

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.chevron_left_rounded)),
        backgroundColor: Colors.transparent,
        actions: [
          SvgPicture.asset('assets/images/bag.svg'),
          SizedBox(
            width: 16,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Earn Money\nBy Refer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Mont',
                      color: Color(0xff2D2D2D),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.shopping_bag_outlined),
                  //   onPressed: () {
                  //     // TODO: Implement cart navigation
                  //   },
                  // ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width / 100) * 63,
                        height: 50,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Obx(() {
                          final code = _code();
                          return Row(
                            children: [
                              Expanded(
                                child: Text(
                                  controller.isLoadingCode.value && code.isEmpty
                                      ? 'Loading…'
                                      : (code.isEmpty ? 'Unavailable' : code),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Mont',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.1,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              TextButton(
                                // Copying null used to throw, which is why the
                                // button appeared to do nothing at all.
                                onPressed: code.isEmpty
                                    ? null
                                    : () {
                                        Clipboard.setData(
                                            ClipboardData(text: code));
                                        Get.snackbar('Copied',
                                            'Referral code $code copied',
                                            snackPosition: SnackPosition.BOTTOM,
                                            duration:
                                                const Duration(seconds: 2));
                                      },
                                child: Text(
                                  'Copy',
                                  style: TextStyle(
                                      fontFamily: 'Mont',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: code.isEmpty
                                          ? Colors.grey
                                          : Colors.black),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 50,
                        width: 85,
                        child: ElevatedButton(
                          onPressed: () {
                            final code = _code();
                            if (code.isEmpty) {
                              Get.snackbar('Referral code',
                                  'Your code is still loading. Try again in a moment.',
                                  snackPosition: SnackPosition.BOTTOM);
                              return;
                            }
                            SharePlus.instance.share(ShareParams(
                              text:
                                  'Join me on JaraMarket — fresh food and groceries delivered to you! '
                                  'Sign up with my referral code $code and we both earn rewards. '
                                  'Download the app to get started.',
                              subject: 'Join me on JaraMarket',
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Color(0xffF19A0D),
                              foregroundColor: Colors.white),
                          child: const Text('SHARE'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ReferralEarningsCard(),
            ),
            Container(
              height: 430,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Invited Friends',
                          style: TextStyle(
                              fontFamily: 'Mont',
                              fontSize: 24,
                              fontWeight: FontWeight.w800),
                        ),
                        Icon(Icons.search),
                      ],
                    ),
                  ),
                  Obx(() {
                    return controller.isLoading.value ? Center(child: CircularProgressIndicator(color: Colors.amber,),) : controller.data.isEmpty ? Center(child: Text('You don\'t have any referals yet'),) : ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: controller.data.length,
                    itemBuilder: (context, index) {
                      return _buildFriendItem(controller.data[index]);
                    },
                  );
                  },)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendItem(Data friend) {
    final name = (friend.name ?? '').trim();
    final label = name.isNotEmpty ? name : (friend.email ?? 'A friend');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange[100],
          child: Text(
            label.isNotEmpty ? label[0].toUpperCase() : '?',
            style: const TextStyle(
                color: Color(0xffF19A0D), fontWeight: FontWeight.w700),
          ),
        ),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: friend.createdAt == null
            ? null
            : Text('Joined ${_joinedOn(friend.createdAt!)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
              friend.earned > 0
                  ? '+\u20A6${friend.earned.toStringAsFixed(friend.earned.truncateToDouble() == friend.earned ? 0 : 2)}'
                  : 'Joined',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E7D32))),
        ),
      ),
    );
  }

  String _joinedOn(String raw) {
    try {
      final d = DateTime.parse(raw).toLocal();
      const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[d.month]} ${d.day}, ${d.year}';
    } catch (_) {
      return raw.length > 10 ? raw.substring(0, 10) : raw;
    }
  }
}
