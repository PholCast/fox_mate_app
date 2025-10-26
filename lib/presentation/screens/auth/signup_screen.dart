import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fox_mate_app/components/custom_text_field.dart';
import 'package:fox_mate_app/components/primary_button.dart';
import 'package:fox_mate_app/constants/custom_colors.dart';
import 'package:fox_mate_app/constants/spacing.dart';
import 'package:fox_mate_app/presentation/screens/auth/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Spacing.padding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // LOGO
                Text(
                  'FoxMate',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 60,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -3,
                      ),
                ),
                SizedBox(height: 30),

                // TÍTULO PRINCIPAL
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    'Crea tu cuenta',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: Spacing.space),

                // SUBTÍTULO
                Text(
                  '¡Únete a la comunidad de FoxMate!',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: CustomColors.grayTextColor,
                      ),
                ),
                SizedBox(height: 40),

                // CAMPOS DE TEXTO
                CustomTextField(
                  label: 'Nombre completo',
                  placeholder: 'Juan Pérez',
                  maxLines: 1,
                  prefixIcon: Icon(Icons.person_outline,
                      color: CustomColors.grayTextColor),
                ),
                SizedBox(height: 20),

                CustomTextField(
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  placeholder: 'tu.email@universidad.com',
                  maxLines: 1,
                  prefixIcon:
                      Icon(Icons.email_outlined, color: CustomColors.grayTextColor),
                ),
                SizedBox(height: 20),

                CustomTextField(
                  label: 'Contraseña',
                  isPassword: true,
                  placeholder: 'Crea una contraseña',
                  maxLines: 1,
                  prefixIcon:
                      Icon(Icons.lock_outline_rounded, color: CustomColors.grayTextColor),
                ),
                SizedBox(height: 20),

                CustomTextField(
                  label: 'Confirmar Contraseña',
                  isPassword: true,
                  placeholder: 'Confirma tu contraseña',
                  maxLines: 1,
                  prefixIcon: Icon(Icons.lock_reset_rounded,
                      color: CustomColors.grayTextColor),
                ),

                SizedBox(height: 40),

                // BOTÓN REGISTRARSE
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: PrimaryButton(
                    onPressed: () {
                      // TODO: Lógica de registro
                    },
                    title: 'Registrarse',
                    verticalPadding: 18,
                  ),
                ),

                SizedBox(height: 25),

                // TEXTO INFERIOR: ¿YA TIENES UNA CUENTA?
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: '¿Ya tienes una cuenta? ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CustomColors.grayTextColor,
                        ),
                    children: [
                      TextSpan(
                        text: 'Inicia sesión',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: CustomColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                            );
                          },
                      ),
                    ],
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
