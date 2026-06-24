import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorSnackBar(String message) {
    try {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } catch (e, stackTrace) {
      print('Error showing snackbar: $e');
      print('Stack Trace: $stackTrace');
    }
  }