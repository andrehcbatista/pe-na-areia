import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/primary_button.dart';
import 'utils/auth_validators.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/auth_text_field.dart';

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({super.key});

  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Criar conta',
      subtitle:
          'Cadastro visual para preparar a área do consumidor, sem criar usuário real agora.',
      icon: Icons.person_add_alt_1_rounded,
      children: [
        Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthTextField(
                controller: _nameController,
                label: 'Nome',
                icon: Icons.person_outline_rounded,
                textInputAction: TextInputAction.next,
                validator: requiredValidator,
              ),
              const SizedBox(height: 12),
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
                textInputAction: TextInputAction.next,
                validator: passwordValidator,
              ),
              const SizedBox(height: 12),
              AuthTextField(
                controller: _confirmPasswordController,
                label: 'Confirmar senha',
                icon: Icons.lock_reset_rounded,
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: _confirmPasswordValidator,
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                value: _acceptedTerms,
                onChanged: (value) {
                  setState(() => _acceptedTerms = value ?? false);
                },
                activeColor: AppColors.ocean,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'Aceito os termos futuros de uso do Pé na Areia',
                  style: AppTextStyles.bodyMuted,
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                label: 'Criar conta',
                icon: Icons.person_add_alt_1_rounded,
                onPressed: _submit,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Flexible(
              child: Text(
                'Já tem conta?',
                style: AppTextStyles.bodyMuted,
              ),
            ),
            TextButton(
              onPressed: _returnToLogin,
              child: const Text('Entrar'),
            ),
          ],
        ),
      ],
    );
  }

  String? _confirmPasswordValidator(String? value) {
    final passwordError = passwordValidator(value);
    if (passwordError != null) {
      return passwordError;
    }

    if (value!.trim() != _passwordController.text.trim()) {
      return 'As senhas precisam ser iguais';
    }
    return null;
  }

  void _submit() {
    _showMessage('Cadastro será ativado na próxima etapa do Pé na Areia.');
  }

  void _returnToLogin() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }
}
