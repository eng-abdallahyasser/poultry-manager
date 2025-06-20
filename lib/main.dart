import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_manager/data/local/local_storge.dart';
import 'core/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync<LocalStorage>(() => LocalStorage().init());
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
