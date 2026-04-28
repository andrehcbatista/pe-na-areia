import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/primary_button.dart';

class EstablishmentSignupScreen extends StatefulWidget {
  const EstablishmentSignupScreen({super.key});

  @override
  State<EstablishmentSignupScreen> createState() =>
      _EstablishmentSignupScreenState();
}

class _EstablishmentSignupScreenState extends State<EstablishmentSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ownerController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ownerController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar estabelecimento')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              const Text('Solicitacao de cadastro', style: AppTextStyles.title),
              const SizedBox(height: 8),
              const Text(
                'Formulario visual para simular interesse de bares. Nenhum dado e enviado para backend nesta fase.',
                style: AppTextStyles.bodyMuted,
              ),
              const SizedBox(height: 20),
              _Field(
                controller: _nameController,
                label: 'Nome do estabelecimento',
              ),
              const SizedBox(height: 12),
              _Field(
                controller: _ownerController,
                label: 'Responsavel',
              ),
              const SizedBox(height: 12),
              _Field(
                controller: _phoneController,
                label: 'Telefone',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              _Field(
                controller: _addressController,
                label: 'Localizacao na praia',
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Enviar solicitacao simulada',
                icon: Icons.send_rounded,
                onPressed: _submit,
              ),
              const SizedBox(height: 14),
              const Text(
                'Cadastro real, validacao documental e painel operacional ficam fora do MVP 1.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon:
              const Icon(Icons.check_circle_rounded, color: AppColors.success),
          title: const Text('Solicitacao registrada'),
          content: const Text(
            'Esta e uma confirmacao simulada. Nenhuma informacao foi enviada para um servidor.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _nameController.clear();
                _ownerController.clear();
                _phoneController.clear();
                _addressController.clear();
              },
              child: const Text('Entendi'),
            ),
          ],
        );
      },
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Preencha este campo';
        }
        return null;
      },
    );
  }
}
