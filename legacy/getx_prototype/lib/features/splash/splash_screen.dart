import 'dart:async';
import 'package:dallala/features/navigation/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 4),
      () => Get.offAll(
        duration: Duration(seconds: 2),
        transition: Transition.circularReveal,
        () => NavigationScreen(),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/splash/Dallala-Splash-Animation.gif',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
