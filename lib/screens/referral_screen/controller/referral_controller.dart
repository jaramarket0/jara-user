import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer' as myLog;
import 'package:get/get.dart';
import 'package:jara_market/screens/referral_screen/models/models.dart';
import 'package:jara_market/services/api_service.dart';
import 'package:overlay_kit/overlay_kit.dart';

class ReferralController extends GetxController {
  RxBool isLoading = false.obs;
ReferalModel referalModel = ReferalModel();
RxList<Data> data = <Data>[].obs;
  ApiService apiClient = ApiService(const Duration(seconds: 60 * 5));

  /// The signed-in user's own referral code, read from the server.
  ///
  /// It used to arrive via Get.arguments, so opening this screen any other
  /// way left it null and the UI fell back to a hardcoded sample code --
  /// which customers were then sharing. Fetching it here means the screen is
  /// correct however it's reached.
  final RxString referralCode = ''.obs;
  final RxBool isLoadingCode = false.obs;

  Future<void> fetchMyCode() async {
    isLoadingCode.value = true;
    try {
      final response = await apiClient.fetchUser();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        final payload = body['data'];
        if (payload is Map<String, dynamic>) {
          referralCode.value = payload['referral_code']?.toString() ?? '';
        }
      }
    } catch (e) {
      myLog.log('Could not load referral code: $e');
    } finally {
      isLoadingCode.value = false;
    }
  }

// @override
// onInit(){
//   super.init();
//   fetchReferals();  
// }

  @override
  onInit() {
    super.onInit();
    fetchMyCode();
    fetchReferals();
  }



  Future<void> fetchReferals() async {
    isLoading.value = true;

//OverlayLoadingProgress.start(circularProgressColor: Colors.amber);
    try {
      var response = await apiClient.fetchReferal();

      if (response.statusCode == 200 || response.statusCode == 201) {
        //OverlayLoadingProgress.stop();
        isLoading.value = false;
        referalModel = referalModelFromJson(response.body);
        data.value = referalModel.data!;
        
      } else {
        //OverlayLoadingProgress.stop();
        isLoading.value = false;
        myLog.log(jsonDecode(response.body));
      }
    } catch (e) {
      //OverlayLoadingProgress.stop();
      isLoading.value = false;
      myLog.log(e.toString());
    } finally {
     // OverlayLoadingProgress.stop();
      isLoading.value = false;
    }
  }
}
