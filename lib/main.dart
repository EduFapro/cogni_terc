import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';
import 'app/database_helper.dart';
import 'constants/translation/ui_strings.dart';
import 'global/global_binding.dart';
import 'routes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    title: "CogniVoice",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setTitle("CogniVoice");
    // await windowManager.setIcon(iconPath);
  });

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
      locale: Locale('pt', 'BR'),
      fallbackLocale: Locale('pt', 'BR'),
      initialBinding: GlobalBinding(),
      title: 'CogniVoice',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.login,
      getPages: routes,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('pt', 'BR'), // Portuguese, Brazil
        const Locale('es', 'ES'),
      ],
    );
  }
}
