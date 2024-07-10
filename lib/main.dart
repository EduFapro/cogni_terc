import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app/database_helper.dart';
import 'constants/translation/ui_strings.dart';
import 'global/global_binding.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");

    // Initialize sqflite for FFI (used in desktop applications)
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // Now initialize the database
    await DatabaseHelper().initDb();


    runApp(MyApp());
  } catch (e) {
    print("Initialization Error: $e");
    // Handle the initialization error
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: UiStrings(),
      locale: Locale('pt','BR'),
      fallbackLocale: Locale('pt','BR'),
      initialBinding: GlobalBinding(),
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.login,
      getPages: routes,
    );
  }
}
