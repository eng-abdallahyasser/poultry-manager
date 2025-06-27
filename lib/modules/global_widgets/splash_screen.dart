import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_manager/core/routes/routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2)); // Display for 2 seconds
    Get.offNamed(Routes.DASHBOARD); // Navigate to main screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Your brand color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'assets/images/logo.jpg', // Your logo path
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            // App Name with animation
            const Text(
              'Poultry Manager',
              style: TextStyle(
                color: Color(0xff1b1889),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'built by Eng.',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Abdallah Yasser',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),

            // Loading indicator
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
