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

  // Pagination state — mirrors HomeController's category load-more pattern.
  int _currentPage = 1;
  int _lastPage = 1;
  bool _hasMore = true;
  RxBool isLoadingMore = false.obs;
  bool get hasMore => _hasMore;

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
      fetchIngredients();
      return;
    }
    Navigator.push(
        Get.context!,
        MaterialPageRoute(
          builder: (context) => AddressGoogleChangeScreen(),
        ));
  }

  Future<void> fetchIngredients({bool reset = true}) async {
    if (reset) {
      _currentPage = 1;
      _hasMore = true;
      isLoading.value = true;
    } else {
      if (!_hasMore || isLoadingMore.value) return;
      isLoadingMore.value = true;
    }

    try {
      var response = await apiService.fetchIngredients(page: _currentPage);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // myLog.log(response.body, name: 'INGREDIENTS');
        ingredientResorceModel = ingredientResorceModelFromJson(response.body);
        _lastPage = ingredientResorceModel.lastPage ?? 1;
        _hasMore = _currentPage < _lastPage;
        if (reset) {
          dataList.value = ingredientResorceModel.data ?? [];
        } else {
          dataList.addAll(ingredientResorceModel.data ?? []);
        }
        _currentPage++;
        myLog.log(dataList.value.toString(), name: 'INGREDIENTS');
      } else {
        Get.snackbar('Error', response.body,
            colorText: Colors.white, backgroundColor: Colors.red);
      }
    } catch (e) {
      myLog.log(e.toString(), name: 'ERROR FETCHING INGREDIENTS');
      // Get.snackbar('Error', e.toString(),
      //     colorText: Colors.white, backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreIngredients() async {
    if (!_hasMore || isLoadingMore.value) return;
    await fetchIngredients(reset: false);
  }
}
