import 'package:flutter/material.dart';
import 'package:fox_mate_app/components/custom_text_field.dart';
import 'package:fox_mate_app/components/primary_button.dart';
import 'package:fox_mate_app/constants/custom_colors.dart';
import 'package:fox_mate_app/constants/spacing.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool emailSent = false;

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
                // Botón de regreso
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 10),

                // Logo
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

                // Título
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

                // Subtítulo
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

                // Campo de correo
                CustomTextField(
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

                // Botón enviar enlace
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    title: 'Enviar enlace de recuperación',
                    verticalPadding: 18,
                    onPressed: () {
                      setState(() {
                        emailSent = true;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 25),

                // Mensaje de confirmación
                if (emailSent)
                  Center(
                    child: Text(
                      '¡Listo! Revisa tu correo para continuar.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: CustomColors.secondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
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
