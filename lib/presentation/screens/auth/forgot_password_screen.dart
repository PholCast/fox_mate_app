import 'package:flutter/material.dart';
import 'package:fox_mate_app/components/custom_text_field.dart';
import 'package:fox_mate_app/components/primary_button.dart';
import 'package:fox_mate_app/constants/custom_colors.dart';
import 'package:fox_mate_app/constants/spacing.dart';
import 'package:fox_mate_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().resetPasswordResetState();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showErrorSnackBar('Por favor ingresa tu correo electrónico');
      return;
    }

    if (!email.contains('@')) {
      _showErrorSnackBar('Por favor ingresa un correo válido');
      return;
    }

    final authProvider = context.read<AuthProvider>();
    await authProvider.sendPasswordResetEmail(email);

    if (!mounted) return;

    if (authProvider.passwordResetError != null) {
      _showErrorSnackBar(authProvider.passwordResetError!);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Spacing.padding),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    context.read<AuthProvider>().resetPasswordResetState();
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 10),

                Center(
                  child: Text(
                    'FoxMate',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: 60,
                          fontWeight: FontWeight.w800,
                          color: CustomColors.primaryColor,
                          letterSpacing: -3,
                        ),
                  ),
                ),
                const SizedBox(height: 30),

                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'Recupera tu contraseña',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.space),

                Center(
                  child: Text(
                    'Ingresa el correo electrónico asociado a tu cuenta.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: CustomColors.grayTextColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),

                CustomTextField(
                  controller: _emailController,
                  label: 'Correo Electrónico',
                  keyboardType: TextInputType.emailAddress,
                  placeholder: 'tu_correo@universidad.edu',
                  maxLines: 1,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: CustomColors.grayTextColor,
                  ),
                ),
                const SizedBox(height: 30),

                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        title: authProvider.isSendingPasswordReset
                            ? 'Enviando...'
                            : 'Enviar enlace de recuperación',
                        verticalPadding: 18,
                        onPressed: authProvider.isSendingPasswordReset
                            ? null
                            : _handleSendResetEmail,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 25),

                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    if (authProvider.passwordResetEmailSent) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: CustomColors.secondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: CustomColors.secondaryColor,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: CustomColors.secondaryColor,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  '¡Listo! Revisa tu correo para continuar.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: CustomColors.secondaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}