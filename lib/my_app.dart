import 'package:flutter/material.dart';
import 'package:wheelbase/screens/home/splash_screen.dart';
import 'package:wheelbase/themes/appcolors.dart';
import 'package:wheelbase/themes/appfonts.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wheelbase',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
        textTheme: AppFonts.textTheme,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
