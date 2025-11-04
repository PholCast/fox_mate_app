import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fox_mate_app/presentation/screens/auth/login_screen.dart';
import 'package:fox_mate_app/presentation/screens/navigation/main_navigation_screen.dart';
import 'package:fox_mate_app/presentation/screens/splash_screen.dart';
import 'package:fox_mate_app/providers/auth_provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        Widget targetScreen;
        switch (authProvider.authStatus) {
          case AuthStatus.initial:
          case AuthStatus.loading:
            targetScreen = SplashScreen();
            break;

          case AuthStatus.authenticated:
            targetScreen = MainNavigationScreen();
            break;

          case AuthStatus.unauthenticated:
          case AuthStatus.error:
          print(AuthStatus.error);
            targetScreen = LoginScreen();
            break;
        }

        return targetScreen;
      },
    );
  }
}