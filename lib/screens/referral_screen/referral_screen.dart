import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/referral_screen/controller/referral_controller.dart';
import 'package:jara_market/screens/referral_screen/models/models.dart';

ReferralController controller = Get.put(ReferralController());

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> names = [
      'Jessica Prince',
      'Mathew Paul',
      'Christopher Mark',
      'Nigal Nathan',
      'Jessica Prince',
    ];
    final data = Get.arguments;
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
                        child: Row(
                          children: [
                             Text(
                              data ?? 'mir20220320',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Mont',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: data));
                              },
                              child: const Text(
                                'Copy',
                                style: TextStyle(
                                    fontFamily: 'Mont',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 50,
                        width: 85,
                        child: ElevatedButton(
                          onPressed: () {
                              Clipboard.setData(ClipboardData(text: data));
                            // TODO: Implement share functionality
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
                      return _buildFriendItem(
                        name: controller.data[index],
                        isInvited: index > 1,
                      );
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

  Widget _buildFriendItem({
    required Data name,
    required bool isInvited,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person, color: Colors.grey),
        ),
        title: Text(
          name.name!,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: SizedBox(height: 50,width: 70,
          child: ElevatedButton(
            onPressed: isInvited ? null : () {},
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: isInvited ? Colors.grey : Colors.black,
              backgroundColor: isInvited ? Colors.grey[200] : Colors.orange[100],
            ),
            child: Text(isInvited ? 'Invited' : 'Invite'),
          ),
        ),
      ),
    );
  }
}
