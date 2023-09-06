
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingHelper {
  static void showLoading() {
    Get.dialog(
        Dialog(
          backgroundColor: Colors.white.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false);
  }

  static void hideLoading() {
    Get.back();
  }
}
