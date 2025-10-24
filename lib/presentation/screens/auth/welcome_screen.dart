import 'package:flutter/material.dart';
import 'package:fox_mate_app/constants/spacing.dart';
import 'package:fox_mate_app/presentation/screens/auth/login_screen.dart';
import 'package:fox_mate_app/presentation/screens/auth/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(Spacing.padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Image.asset('assets/images/foxmate_logo.png', height: 150),
                SizedBox(height: 25),

                Text(
                  'FoxMate',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),

                SizedBox(height: 20),
                Text(
                  'Conecta, aprende y comparte con tu universidad',
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                Spacer(),

                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.8,
                      50,
                    ),
                  ),
                  child: Text(
                    'Iniciar sesión',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: Spacing.space),
                
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.8,
                      50,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    foregroundColor: Theme.of(context).colorScheme.onTertiary,
                  ),
                  child: Text(
                    'Registrarse',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
