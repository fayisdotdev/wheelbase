import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wheelbase/screens/auth/login_page.dart';
import 'package:wheelbase/screens/home/home_screen.dart';

class SplashProvider extends ChangeNotifier {
  Widget? _nextScreen;
  Widget? get nextScreen => _nextScreen;

  SplashProvider() {
    _init();
  }

  void _init() {
    // Splash delay
    Timer(const Duration(seconds: 2), () {
      final session = Supabase.instance.client.auth.currentSession;

      if (session != null) {
        // Logged in → Go to home
        _nextScreen = MyHomePage();
      } else {
        // Not logged in → Go to login
        _nextScreen = LoginPage();
      }

      notifyListeners();
    });
  }
}
