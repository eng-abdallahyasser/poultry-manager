import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:poultry_manager/core/routes/routes.dart';

class MainScaffold extends StatelessWidget {
  final int currentIndex;
  final Widget body;
  final String title;

  const MainScaffold({
    super.key,
    required this.currentIndex,
    required this.body,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.toNamed(Routes.SETTINGS);
            },
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return; // Prevent re-navigation to the same page
          if (index == 0) Get.offAllNamed(Routes.DASHBOARD);
          if (index == 1) Get.offAllNamed(Routes.REPORTS);
          if (index == 2) Get.offAllNamed(Routes.STOCK);
          if (index == 3) Get.offAllNamed(Routes.REPORTS);
          if (index == 4) Get.offAllNamed(Routes.PHARMACY);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'الرئيسة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'التقارير',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'المخزون'),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture_rounded),
            label: 'الاعلاف',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'الأدوية',
          ),
        ],
      ),
    );
  }
}
