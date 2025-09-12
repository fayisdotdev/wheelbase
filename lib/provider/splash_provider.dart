import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wheelbase/screens/auth/login_page.dart';
import 'package:wheelbase/provider/auth_provider.dart';
import 'package:wheelbase/screens/home/home_screen.dart';

class SplashProvider extends ChangeNotifier {
  Widget? _nextScreen;
  Widget? get nextScreen => _nextScreen;

  SplashProvider();

Future<void> init(BuildContext context) async {
  // 👇 Wake up Supabase here
  await Provider.of<AuthProvider>(context, listen: false).pingSupabase();

  await Future.delayed(const Duration(seconds: 3));

  final session = Supabase.instance.client.auth.currentSession;

  if (session != null) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.fetchUserProfile(session.user.id);

    _nextScreen = const HomePage();
  } else {
    _nextScreen = const LoginScreen();
  }

  notifyListeners();
}

}
