import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waste_mangement_app/firebase_options.dart';
import 'package:waste_mangement_app/pages/MainNavigationPage.dart';
import 'package:waste_mangement_app/pages/WelcomePage.dart';
import 'package:waste_mangement_app/themes/theme_notifier.dart';
import 'package:waste_mangement_app/themes/themes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';



void main() async  {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      
      title: 'Waste Management App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.lightBackground,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.accent,

        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.lightText),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.darkText),
        ),
      ),
      themeMode: themeNotifier.themeMode, // Uses system setting by default
      home: WelcomeScreen(),
    );
  }
}
