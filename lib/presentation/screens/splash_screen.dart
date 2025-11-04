import 'package:flutter/material.dart';
import 'package:fox_mate_app/constants/spacing.dart';
import 'package:fox_mate_app/presentation/screens/home/post_screen.dart';
import 'package:provider/provider.dart';
import 'package:fox_mate_app/presentation/screens/auth/welcome_screen.dart';
import 'package:fox_mate_app/providers/auth_provider.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  void _checkAuthState() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final authProvider = context.read<AuthProvider>();
        if (authProvider.authStatus == AuthStatus.authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PostScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
          );
        }
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(Spacing.padding),
            child: Image.asset(
              'assets/images/foxmate_logo.png',
              height: 150,
            ),
          ),
        ),
      ),
    );
  }
}
