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
import 'package:fox_mate_app/presentation/wrappers/auth_wrapper.dart';
import 'package:fox_mate_app/presentation/wrappers/main_navigation_wrapper.dart';
import 'package:fox_mate_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

   @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().addListener(_authStateListener);
    });
  }

  void _authStateListener() {
    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();

    if (authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      authProvider.clearError();
    }

    if (authProvider.authStatus == AuthStatus.authenticated &&
        authProvider.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthWrapper()),
        );
      });
    }
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      authProvider.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(padding: EdgeInsets.all(Spacing.padding),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                  controller: _emailController,
                  validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                  prefixIcon: Icon(Icons.email_outlined, color: CustomColors.grayTextColor,),
                ),
                SizedBox(height: 20),
                CustomTextField(label: 'Contraseña',
                  isPassword: true, 
                  placeholder: 'tuemail@soyudemedellin.edu.co',
                  maxLines:1,
                  controller: _passwordController,
                  validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
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
                  Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: PrimaryButton(
                      onPressed: () {
                              if (authProvider.authStatus == AuthStatus.loading) {
                                return;
                              }
                              _handleLogin();
                            },
                      title: authProvider.authStatus == AuthStatus.loading
                                    ? 'Loading...'
                                    :'Iniciar Sesión',
                      verticalPadding: 18,
                    ),
                  );}),
                  
                  SizedBox(height: 18),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: OutlinedButton(
                      onPressed: () => print('Iniciar sesión con Microsoft'),
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
          ),
        ) ,
      ),
    ));
  }
}