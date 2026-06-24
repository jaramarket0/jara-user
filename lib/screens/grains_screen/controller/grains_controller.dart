import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/address_google/address_google.dart';
import 'package:jara_market/screens/grains_screen/models/models.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:jara_market/services/api_service.dart';
import 'dart:developer' as myLog;

class GrainsController extends GetxController {
  ApiService apiService = ApiService(Duration(seconds: 60 * 5));
  RxBool isLoading = false.obs;

  IngredientResorceModel ingredientResorceModel =
      IngredientResorceModel(message: 'something went wrong', data: []);
  Data data = Data(
      createdAt: '',
      description: '',
      id: -1,
      imageUrl: '',
      name: '',
      price: 0.0,
      stock: '',
      unit: '');
  RxList<Data> dataList = <Data>[].obs;
  @override
  onInit() {
    super.onInit();
//fetchIngredients();
    fetchIngredientByCondition();
  }

  fetchIngredientByCondition() async {
    var stateId = await dataBase.getStateAddressId();
    myLog.log('Found a state id: $stateId', name: 'GrainsController');
    if (stateId.isNotEmpty) {
      if (dataList.isNotEmpty) return;
      fetchIngredients();
      return;
    }
    Navigator.push(
        Get.context!,
        MaterialPageRoute(
          builder: (context) => AddressGoogleChangeScreen(),
        ));
  }

  Future<void> fetchIngredients() async {
    isLoading.value = true;

    try {
      var response = await apiService.fetchIngredients();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // myLog.log(response.body, name: 'INGREDIENTS');
        ingredientResorceModel = ingredientResorceModelFromJson(response.body);
        dataList.value = ingredientResorceModel.data!;
        myLog.log(dataList.value.toString(), name: 'INGREDIENTS');
      } else {
        isLoading.value = false;
        Get.snackbar('Error', response.body,
            colorText: Colors.white, backgroundColor: Colors.red);
      }
    } catch (e) {
      myLog.log(e.toString(), name: 'ERROR FETCHING INGREDIENTS');
      isLoading.value = false;
      // Get.snackbar('Error', e.toString(),
      //     colorText: Colors.white, backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
}
