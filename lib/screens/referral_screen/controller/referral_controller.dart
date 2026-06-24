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

// @override
// onInit(){
//   super.init();
//   fetchReferals();  
// }

  @override
  onInit() {
    super.onInit();
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
