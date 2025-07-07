import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Poultry Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
