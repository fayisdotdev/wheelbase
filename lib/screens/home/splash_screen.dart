import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheelbase/provider/splash_provider.dart';
import 'package:wheelbase/themes/appcolors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  bool _navigated = false;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SplashProvider>(context, listen: false).init(context);
      // Start fade-in animation
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _opacity = 1.0;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, splashProvider, _) {
        if (!_navigated && splashProvider.nextScreen != null) {
          _navigated = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => splashProvider.nextScreen!),
            );
          });
        }

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(seconds: 2),
                  child: Text(
                    "Wheel Base",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(seconds: 2),
                  child: Text(
                    "Your journey, organized.",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}