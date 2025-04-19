import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'my_data.dart';
import 'my_widgets.dart';

class AsymmetriApp extends StatelessWidget {
  final data = Get.put(MyData());

  AsymmetriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F1F8),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Image.network(
                    'https://tinyurl.com/3hfa26cx',
                    width: 200,
                    height: 100,
                    fit: BoxFit.cover,
                  )),
              const SizedBox(height: 20),
              Dropdown(),
              const SizedBox(height: 10),
              SliderWidget(),
              const SizedBox(height: 10),
              InputFields(),
              const SizedBox(height: 10),
              ReverseSwitch(),
              const SizedBox(height: 20),
              ProgressBars(),
            ],
          ),
        ),
      ),
    );
  }
}
