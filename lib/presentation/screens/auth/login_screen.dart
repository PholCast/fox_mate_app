import 'package:flutter/material.dart';
import 'package:fox_mate_app/components/custom_text_field.dart';
import 'package:fox_mate_app/components/primary_button.dart';
import 'package:fox_mate_app/constants/custom_colors.dart';
import 'package:fox_mate_app/constants/spacing.dart';
import 'package:fox_mate_app/main.dart';
import 'package:fox_mate_app/presentation/screens/auth/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
      Center(
        child: Padding(padding: EdgeInsets.all(Spacing.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('FoxMate', style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 60,
              fontWeight: FontWeight.w800,
              letterSpacing: -3, // más compacta
            )),
            SizedBox(height: 30),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text('Inicia Sesión en FoxMate', style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: Spacing.space),
            Text('¡Qué bueno verte de nuevo!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: CustomColors.grayTextColor,
              ),
            ),
            SizedBox(height: 40,),
            
            CustomTextField(label: 'Correo Electrónico',
              keyboardType: TextInputType.emailAddress, 
              placeholder: 'tuemail@soyudemedellin.edu.co',
              maxLines:1,
              prefixIcon: Icon(Icons.email_outlined, color: CustomColors.grayTextColor,),
            ),
            SizedBox(height: 20),
            CustomTextField(label: 'Contraseña',
              isPassword: true, 
              placeholder: 'tuemail@soyudemedellin.edu.co',
              maxLines:1,
              prefixIcon: Icon(Icons.lock_outline_rounded, color: CustomColors.grayTextColor,),
            ),
            SizedBox(height:Spacing.space),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                  ),
                child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CustomColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),  
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: PrimaryButton(
                  onPressed: () => () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyHomePage(title:'Mi Inicio')),
                  ),
                  title: 'Iniciar Sesión',
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text('Iniciar sesión con Microsoft', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: CustomColors.primaryColor
                  ),),

                ),
              )
            
          ],
        ) ,
      )),
    ));
  }
}