import 'package:asymmetri_demo/animation_controller_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyData extends GetxController {
  var selectedColor = Colors.green.obs;
  var sliderValue = "Slow".obs;
  var totalItems = 1.obs;
  var itemsInLine = 1.obs;
  var isReversed = false.obs;

  Map<String, MaterialColor> colorOptions = {
    "Green": Colors.green,
    "Red": Colors.red,
    "Blue": Colors.blue,
    "Purple": Colors.purple,
  };

  List<String> sliderLabel = ["Slow", "Smooth", "Fast"];

  late AnimationControllerManager animationManager;

  @override
  void onInit() {
    super.onInit();
    animationManager = AnimationControllerManager(this);
    animationManager.init(); // call explicitly here

    totalItems.listen((val) {
      if (val > 30) {
        final value = totalItems.value % 10;
        totalItems.value = value > 0 ? value : 1;
        Get.snackbar(
          'Error',
          'Maximum total items allowed is 30',
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
        );
      }
    });

    itemsInLine.listen((val) {
      if (val > 15) {
        final value = itemsInLine.value % 10;
        itemsInLine.value = value > 0 ? value : 1;
        Get.snackbar(
          'Error',
          'Maximum items per line is 15',
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
        );
      }
    });
  }
}
