import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fox_mate_app/components/custom_text_field.dart';
import 'package:fox_mate_app/components/primary_button.dart';
import 'package:fox_mate_app/constants/custom_colors.dart';
import 'package:fox_mate_app/constants/spacing.dart';
import 'package:fox_mate_app/main.dart';
import 'package:fox_mate_app/presentation/screens/auth/forgot_password_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fox_mate_app/presentation/screens/auth/signup_screen.dart';
import 'package:fox_mate_app/presentation/wrappers/main_navigation_wrapper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(padding: EdgeInsets.all(Spacing.padding),
        child: SingleChildScrollView(
          child: Column(
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
                SizedBox(height: 40),  
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: PrimaryButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MainNavigationWrapper()),
                    ),
                    title: 'Iniciar Sesión',
                    verticalPadding: 18,
                  ),
                ),
                SizedBox(height: 18),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: OutlinedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyHomePage(title:'Mi Inicio')),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
                      side: BorderSide(color: Theme.of(context).colorScheme.tertiary, width: 1.5),  // Borde azul de 2 de grosor
                      backgroundColor: Colors.transparent,  // Fondo transparente
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                      
                        children: [
                          SvgPicture.asset('assets/icons/microsoft-icon.svg', width: 25, height: 35),
                          SizedBox(width:Spacing.space),
                          Text('Iniciar sesión con Microsoft', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800
                          ),),
                        ],
                      ),
                    ),
          
                  ),
                ),
                SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    text: '¿No tienes una cuenta? ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CustomColors.grayTextColor,
                    ),
                    children: [
                      TextSpan(
                        text: 'Regístrate',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CustomColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const SignUpScreen()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              
            ],
          ),
        ) ,
      ),
    ));
  }
}