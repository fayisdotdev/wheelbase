import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheelbase/my_app.dart';
import 'package:wheelbase/provider/auth_provider.dart';
import 'package:wheelbase/provider/splash_provider.dart';
import 'package:wheelbase/provider/vehicle_provider.dart';

/// Example App-wide state
class AppState extends ChangeNotifier {
  String appName = "Wheelbase";
}

class ProviderWrapper extends StatelessWidget {
  const ProviderWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
      ],
      child: const MyApp(),  // ⬅️ MyApp is child now
    );
  }
}
