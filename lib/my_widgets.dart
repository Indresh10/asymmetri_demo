import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'my_data.dart';

class Dropdown extends StatelessWidget {
  final data = Get.find<MyData>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          width: 200,
          constraints: BoxConstraints(maxWidth: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<MaterialColor>(
              value: data.selectedColor.value,
              items: data.colorOptions.entries
                  .map(
                    (e) => DropdownMenuItem<MaterialColor>(
                      value: e.value,
                      child: Text(e.key),
                    ),
                  )
                  .toList(),
              onChanged: (newValue) {
                data.selectedColor.value = newValue!;
              },
            ),
          ),
        ));
  }
}

class SliderWidget extends StatelessWidget {
  final data = Get.find<MyData>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
          width: 220,
          child: Slider(
            value:
                data.sliderLabel.indexOf(data.sliderValue.value).ceilToDouble(),
            divisions: 2,
            label: data.sliderValue.value,
            max: 2,
            min: 0,
            onChanged: (value) => data.sliderValue.value =
                data.sliderLabel[value.round()].toString(),
            activeColor: data.selectedColor.value,
          ),
        ));
  }
}

class InputFields extends StatelessWidget {
  final data = Get.find<MyData>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputBox(
          label: 'Total Items',
          value: data.totalItems,
          color: data.selectedColor,
        ),
        const SizedBox(height: 10),
        InputBox(
          label: 'Items in Line',
          value: data.itemsInLine,
          color: data.selectedColor,
        ),
      ],
    );
  }
}

class InputBox extends StatelessWidget {
  final String label;
  final RxInt value;
  final Rx<MaterialColor> color;

  InputBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
          width: 200,
          child: TextFormField(
            initialValue: value.value.toString(),
            keyboardType: TextInputType.number,
            onChanged: (text) => value.value = int.tryParse(text) ?? 1,
            decoration: InputDecoration(
              labelText: label,
              labelStyle:
                  TextStyle(color: color.value, fontWeight: FontWeight.bold),
              hintText: value.value.toString(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: color.value),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: color.value),
              ),
            ),
          ),
        ));
  }
}

class ReverseSwitch extends StatelessWidget {
  final data = Get.find<MyData>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: 240,
        child: SwitchListTile(
          title: Text(
            'Reverse',
            style: TextStyle(
                color: data.selectedColor.value, fontWeight: FontWeight.bold),
          ),
          value: data.isReversed.value,
          onChanged: (val) => data.isReversed.value = val,
          activeColor: data.selectedColor.value,
        ),
      ),
    );
  }
}

class ProgressBars extends StatelessWidget {
  final data = Get.find<MyData>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final manager = data.animationManager;

      // Don't build if animations not ready or empty
      if (!manager.ready.value) {
        return const SizedBox(); // You can show a loader if needed
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(data.totalItems.value, (index) {
              if (index >= manager.animations.length) return SizedBox();
              return SizedBox(
                width:
                    MediaQuery.of(context).size.width / data.itemsInLine.value -
                        20, // dynamic width minus spacing
                height: 30,
                child: AnimatedBar(
                  animation: manager.animations[index],
                  color: data.selectedColor,
                  isReversed: data.isReversed,
                ),
              );
            }),
          ),
        ),
      );
    });
  }
}

class AnimatedBar extends StatelessWidget {
  final Animation<double> animation;
  final Rx<MaterialColor> color;
  final RxBool isReversed;

  AnimatedBar({
    required this.animation,
    required this.color,
    required this.isReversed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          child: FractionallySizedBox(
            widthFactor: animation.value,
            alignment:
                isReversed.value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.all(2),
              height: 20,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.value.shade400,
                    color.value.shade900,
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }
}
