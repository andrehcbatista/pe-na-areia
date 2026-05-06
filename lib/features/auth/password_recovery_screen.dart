import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/primary_button.dart';
import 'utils/auth_validators.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/auth_text_field.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Recuperar senha',
      subtitle:
          'Informe o e-mail da conta. O envio real de instruções entrará em uma próxima etapa.',
      icon: Icons.mark_email_read_outlined,
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
                textInputAction: TextInputAction.done,
                validator: emailValidator,
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Enviar instruções',
                icon: Icons.send_rounded,
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
                'Lembrou a senha?',
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

  void _submit() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Recuperação de senha será ativada na próxima etapa.'),
        ),
      );
  }

  void _returnToLogin() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }
}
