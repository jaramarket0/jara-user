import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:jara_market/screens/wallet_screen/models/models.dart';
import 'package:jara_market/screens/wallet_screen/models/single_transaction_model.dart';
import 'package:jara_market/screens/wallet_screen/models/transaction_model.dart';
import 'package:jara_market/screens/wallet_screen/receipt.dart';
import 'package:jara_market/services/api_service.dart';
import 'dart:developer' as myLog;
import 'dart:convert';

import 'package:overlay_kit/overlay_kit.dart';

class WalletController extends GetxController {
  ApiService apiService = ApiService(Duration(seconds: 60 * 5));
  RxBool isLoading = false.obs;
  RxBool isTransactionLoading = false.obs;
  RxBool isTransactionLoading1 = false.obs;
  WalletModel walletModel = WalletModel(
      status: false,
      message: 'error retrieving balance',
      data: Data(id: 0, balance: 'N/A'));
  TransactionModel transactionModel = TransactionModel(data: []);
  SingleTransactionModel singleTransactionModel = SingleTransactionModel();
  SingleTransactionData? singleTransactionData;
  RxList<TransactionData> transactions = <TransactionData>[].obs;
  TransactionData transactionData = TransactionData(
      id: 1,
      txnRef: '',
      amount: '0',
      userName: '',
      transactionMode: '',
      gatewayResponse: '',
      provider: '',
      status: 'failed',
      createdAt: '');
  RxList<dynamic> banks = <dynamic>[].obs;
  @override
  onInit() {
    super.onInit();
    fetchWallet().then((_) => fetchTransactions());
  }

  Future<void> fetchWallet() async {
    isLoading.value = true;

    var response = await apiService.fetchWallet();

    if (response.statusCode == 200 || response.statusCode == 201) {
      isLoading.value = false;
      walletModel = walletModelFromJson(response.body);
    }
  }

  Future<double> fetchBalance() async {
    isLoading.value = true;

    var response = await apiService.fetchWallet();

    if (response.statusCode == 200 || response.statusCode == 201) {
      isLoading.value = false;
      walletModel = walletModelFromJson(response.body);
      myLog.log('printing wallet balance: ${walletModel.data!.balance}',
          name: 'Wallet Balance');
      final cleanedBalanceStr =
          walletModel.data!.balance.toString().replaceAll(',', '');
      return double.tryParse(cleanedBalanceStr) ?? -1;
    }
    return -1;
  }

  Future<void> fetchTransactions() async {
    isTransactionLoading.value = true;
    try {
      var response = await apiService.fetchTransactions();
      if (response.statusCode == 200 || response.statusCode == 201) {
        isTransactionLoading.value = false;
        myLog.log(response.body);
        transactionModel = transactionModelFromJson(response.body);
        transactions.value = transactionModel.data;
        myLog.log('printing Transactions: ${transactions.length}',
            name: 'Transaction Data List');
      }
      ;
    } catch (e) {
      isTransactionLoading.value = false;
      myLog.log(e.toString());
    } finally {
      isTransactionLoading.value = false;
    }
  }

  Future<void> fetchTransaction(int id) async {
    OverlayLoadingProgress.start(circularProgressColor: Colors.amber);
    isTransactionLoading1.value = true;
    try {
      var response = await apiService.fetchTransaction(id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        isTransactionLoading1.value = false;
        OverlayLoadingProgress.stop();
        myLog.log(response.body);
        singleTransactionModel = singleTransactionModelFromJson(response.body);
        singleTransactionData = singleTransactionModel.data;
        myLog.log('printing Transactions: ${transactions.length}',
            name: 'Transaction Data List');
        Navigator.of(Get.context!).push(CupertinoPageRoute(
            builder: (context) =>
                Receipt(singleTransactionData: singleTransactionData!)));
      }
      ;
    } catch (e) {
      isTransactionLoading1.value = false;
      OverlayLoadingProgress.stop();
      myLog.log(e.toString());
    } finally {
      isTransactionLoading1.value = false;
      OverlayLoadingProgress.stop();
    }
  }

  Future<void> fetchBanks() async {
    try {
      // Check if token exists first
      var token = await dataBase.getToken();
      if (token.isEmpty) {
        myLog.log('Token is empty - user not authenticated');
        Get.snackbar('Session Expired', 'Please login again',
            colorText: Colors.white, backgroundColor: Colors.red);
        // Navigate to login
        return;
      }

      var response = await apiService.fetchBanks();

      // Check if response is HTML (redirect)
      if (response.body.contains('<!DOCTYPE') ||
          response.body.contains('<html')) {
        myLog.log('Received HTML redirect instead of JSON');
        Get.snackbar('Session Expired', 'Please login again',
            colorText: Colors.white, backgroundColor: Colors.red);
        return;
      }

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null) {
          banks.value = decoded['data'] as List;
          myLog.log('Banks fetched successfully: ${banks.length}');
        }
      } else if (response.statusCode == 401) {
        myLog.log('Unauthorized - Token may be invalid or expired');
        Get.snackbar('Session Expired', 'Please login again',
            colorText: Colors.white, backgroundColor: Colors.red);
      } else {
        myLog.log(
            'Error fetching banks: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      myLog.log('Error fetching banks: $e');
      Get.snackbar('Error', 'Failed to load banks: $e',
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }

  Future<void> withdrawToBank(
      int amount, int bankId, String currency, String remark) async {
    OverlayLoadingProgress.start(circularProgressColor: Colors.amber);
    try {
      var body = {
        'amount': amount,
        'bank_id': bankId,
        'currency': currency,
        'remark': remark,
      };
      var response = await apiService.post('/wallet/transfer-to-bank', body);
      myLog.log('Withdraw response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        OverlayLoadingProgress.stop();
        Get.snackbar('Success', 'Withdraw successful',
            colorText: Colors.white,
            backgroundColor: Colors.green,
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ));
        fetchWallet(); // Refresh balance
        Navigator.of(Get.context!).pop(); // Go back
      } else {
        OverlayLoadingProgress.stop();
        Get.snackbar('Error', 'Withdraw failed: ${response.body}',
            colorText: Colors.white, backgroundColor: Colors.red);
      }
    } catch (e) {
      OverlayLoadingProgress.stop();
      Get.snackbar('Error', 'Withdraw failed: $e',
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }
}
