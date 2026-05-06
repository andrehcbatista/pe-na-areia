import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/primary_button.dart';
import 'utils/auth_validators.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Entrar no Pé na Areia',
      subtitle:
          'A consulta pública continua livre. O login será ativado em uma próxima etapa.',
      icon: Icons.beach_access_rounded,
      footer: _PublicAccessFooter(
        onPressed: _returnToPublicFlow,
      ),
      children: [
        Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthTextField(
                controller: _emailController,
                label: 'E-mail',
                icon: Icons.alternate_email_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: emailValidator,
              ),
              const SizedBox(height: 12),
              AuthTextField(
                controller: _passwordController,
                label: 'Senha',
                icon: Icons.lock_outline_rounded,
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: passwordValidator,
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Entrar',
                icon: Icons.login_rounded,
                onPressed: _submit,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.passwordRecovery);
          },
          child: const Text('Esqueci minha senha'),
        ),
        const Divider(height: 22, color: AppColors.border),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Flexible(
              child: Text(
                'Ainda não tem conta?',
                style: AppTextStyles.bodyMuted,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.userSignup);
              },
              child: const Text('Criar conta'),
            ),
          ],
        ),
      ],
    );
  }

  void _submit() {
    _showMessage('Login será ativado na próxima etapa do Pé na Areia.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  void _returnToPublicFlow() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }
}

class _PublicAccessFooter extends StatelessWidget {
  const _PublicAccessFooter({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.explore_rounded),
      label: const Text('Continuar explorando sem login'),
    );
  }
}
