import 'package:blazebox/misc/initializer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blazebox/splash.dart';

void main() async {
  await Initializer.initialize();
  runApp(const TeraBox());
}

class TeraBox extends StatelessWidget {
  const TeraBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: "BlazeBox",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
