import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'my_data.dart';

class AnimationControllerManager extends GetxController
    with GetTickerProviderStateMixin {
  final MyData data;

  final animations = <Animation<double>>[];
  final _controllers = <AnimationController>[];
  final ready = false.obs;

  AnimationControllerManager(this.data);

  void init() {
    everAll([
      data.selectedColor,
      data.sliderValue,
      data.totalItems,
      data.itemsInLine,
      data.isReversed,
    ], (_) => _restart());

    _restart(); // start initial animation
  }

  void _restart() {
    // Kill all controllers before restarting
    for (var c in _controllers) {
      c.dispose();
    }
    _controllers.clear();
    animations.clear();
    ready.value = false;

    final count = data.totalItems.value;
    final duration = _durationForSpeed(data.sliderValue.value);

    for (int i = 0; i < count; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: duration,
      );
      final animation = Tween<double>(begin: 0, end: 1).animate(controller);
      animations.add(animation);
      _controllers.add(controller);
    }

    ready.value = true;
    _startSequentially();
  }

  Duration _durationForSpeed(String speed) {
    switch (speed) {
      case "Fast":
        return Duration(milliseconds: 200);
      case "Smooth":
        return Duration(milliseconds: 500);
      default:
        return Duration(milliseconds: 1000);
    }
  }

  void _startSequentially() async {
    final count = _controllers.length;
    final isReverse = data.isReversed.value;

    for (int i = 0; i < count; i++) {
      final index = isReverse ? count - 1 - i : i;
      final controller = _controllers[index];
      await controller.forward();
    }

    // Restart the animation
    Future.delayed(Duration(milliseconds: 300), _restart);
  }
}
