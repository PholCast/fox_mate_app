import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fox_mate_app/components/custom_text_field.dart';
import 'package:fox_mate_app/components/primary_button.dart';
import 'package:fox_mate_app/constants/custom_colors.dart';
import 'package:fox_mate_app/constants/spacing.dart';
import 'package:fox_mate_app/presentation/screens/auth/login_screen.dart';
import 'package:fox_mate_app/presentation/wrappers/auth_wrapper.dart';
import 'package:fox_mate_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      authProvider.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        confirmPassword: _confirmPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Spacing.padding),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el nombre';
                      }
                      return null;
                    },
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: CustomColors.grayTextColor,
                    ),
                  ),
                  SizedBox(height: 20),
              
                  CustomTextField(
                    label: 'Email',
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el correo';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    placeholder: 'tu.email@universidad.com',
                    maxLines: 1,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: CustomColors.grayTextColor,
                    ),
                  ),
                  SizedBox(height: 20),
              
                  CustomTextField(
                    label: 'Contraseña',
                    isPassword: true,
                    controller: _passwordController,
                    placeholder: 'Crea una contraseña',
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa la contraseña';
                      }
                      if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: CustomColors.grayTextColor,
                    ),
                  ),
                  SizedBox(height: 20),
              
                  CustomTextField(
                    label: 'Confirmar Contraseña',
                    isPassword: true,
                    placeholder: 'Confirma tu contraseña',
                    maxLines: 1,
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor confirma tu contraseña';
                      }
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                    prefixIcon: Icon(
                      Icons.lock_reset_rounded,
                      color: CustomColors.grayTextColor,
                    ),
                  ),
              
                  SizedBox(height: 40),
              
                  // BOTÓN REGISTRARSE
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: PrimaryButton(
                          onPressed: authProvider.authStatus == AuthStatus.loading
                              ? null
                              : _submitForm,
                          title: authProvider.authStatus == AuthStatus.loading
                              ? 'Cargando...'
                              : 'Registrarse',
                          verticalPadding: 18,
                        ),
                      );
                    },
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
                                  builder: (_) => const LoginScreen(),
                                ),
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
      ),
    );
  }
}
