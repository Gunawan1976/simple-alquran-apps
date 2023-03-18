import 'package:flutter/material.dart';
import 'package:flutter_alquran/app/constants/color.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "AL-QURAN APPS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: appWhite,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Bacalah Al-Quran karena sesungguhnya ia akan menjadi syafaat bagi para pembacanya di hari kiamat ( HR. Muslim )",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: appWhite,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 300,
              height: 300,
              child: Lottie.asset("assets/lotties/animasi.json"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.offAllNamed("/home");
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: appWhite,
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
              child: Text(
                "Get Started",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w800),
              ),
            )
          ],
        ),
      ),
    );
  }
}
