import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
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
  final _whatsappController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _beachController = TextEditingController(
    text: AppStrings.pilotLocation,
  );
  final _setsController = TextEditingController();
  final _hoursController = TextEditingController();
  final _notesController = TextEditingController();

  String _operationType = _operationTypes.first;
  bool _hasDigitalMenu = false;
  bool _wantsFutureCashback = false;
  bool _wantsFutureReservations = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ownerController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _beachController.dispose();
    _setsController.dispose();
    _hoursController.dispose();
    _notesController.dispose();
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
              const Text('Solicitação de cadastro', style: AppTextStyles.title),
              const SizedBox(height: 8),
              const Text(
                'Formulário visual e local para simular o interesse de estabelecimentos da Praia de Boa Viagem.',
                style: AppTextStyles.bodyMuted,
              ),
              const SizedBox(height: 18),
              _FormSection(
                title: 'Dados do estabelecimento',
                icon: Icons.storefront_rounded,
                children: [
                  _Field(
                    controller: _nameController,
                    label: 'Nome do estabelecimento',
                    requiredField: true,
                  ),
                ],
              ),
              _FormSection(
                title: 'Dados do responsável',
                icon: Icons.person_rounded,
                children: [
                  _Field(
                    controller: _ownerController,
                    label: 'Nome do responsável',
                    requiredField: true,
                  ),
                  _Field(
                    controller: _whatsappController,
                    label: 'WhatsApp',
                    requiredField: true,
                    keyboardType: TextInputType.phone,
                  ),
                  _Field(
                    controller: _emailController,
                    label: 'E-mail',
                    keyboardType: TextInputType.emailAddress,
                    validator: _optionalEmailValidator,
                  ),
                ],
              ),
              _FormSection(
                title: 'Localização e praia',
                icon: Icons.place_rounded,
                children: [
                  _Field(
                    controller: _addressController,
                    label: 'Endereço ou ponto de referência',
                    requiredField: true,
                    maxLines: 2,
                  ),
                  _Field(
                    controller: _beachController,
                    label: 'Praia de atuação',
                    readOnly: true,
                    helperText: 'Praia piloto selecionada para o MVP 1.',
                  ),
                ],
              ),
              _FormSection(
                title: 'Operação na praia',
                icon: Icons.beach_access_rounded,
                children: [
                  _Field(
                    controller: _setsController,
                    label: 'Quantidade aproximada de conjuntos',
                    requiredField: true,
                    keyboardType: TextInputType.number,
                    validator: _setsValidator,
                  ),
                  _Field(
                    controller: _hoursController,
                    label: 'Horário de funcionamento',
                    hintText: 'Ex.: 09h às 17h',
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: _operationType,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de operação',
                    ),
                    items: _operationTypes
                        .map(
                          (type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() => _operationType = value);
                    },
                  ),
                ],
              ),
              _FormSection(
                title: 'Cardápio e estrutura',
                icon: Icons.menu_book_rounded,
                children: [
                  _ToggleField(
                    title: 'Possui cardápio digital',
                    value: _hasDigitalMenu,
                    onChanged: (value) {
                      setState(() => _hasDigitalMenu = value);
                    },
                  ),
                  _ToggleField(
                    title: 'Deseja oferecer cashback futuramente',
                    value: _wantsFutureCashback,
                    onChanged: (value) {
                      setState(() => _wantsFutureCashback = value);
                    },
                  ),
                  _ToggleField(
                    title: 'Deseja aceitar reservas futuramente',
                    value: _wantsFutureReservations,
                    onChanged: (value) {
                      setState(() => _wantsFutureReservations = value);
                    },
                  ),
                ],
              ),
              _FormSection(
                title: 'Observações',
                icon: Icons.notes_rounded,
                children: [
                  _Field(
                    controller: _notesController,
                    label: 'Observações',
                    maxLines: 4,
                    hintText:
                        'Conte detalhes úteis para a análise do cadastro.',
                  ),
                ],
              ),
              const SizedBox(height: 4),
              PrimaryButton(
                label: 'Enviar solicitação',
                icon: Icons.send_rounded,
                onPressed: _submit,
              ),
              const SizedBox(height: 14),
              const Text(
                'Cadastro real, validação documental, login e integrações externas ficam fora do MVP 1.',
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

  String? _optionalEmailValidator(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return null;
    }
    if (!email.contains('@') || !email.contains('.')) {
      return 'Informe um e-mail válido';
    }
    return null;
  }

  String? _setsValidator(String? value) {
    final error = _requiredValidator(value);
    if (error != null) {
      return error;
    }
    final sets = int.tryParse(value!.trim());
    if (sets == null || sets <= 0) {
      return 'Informe uma quantidade válida';
    }
    return null;
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
          title: const Text('Solicitação enviada'),
          content: const Text(
            'Solicitação enviada. Nossa equipe analisará as informações e entrará em contato para validar o cadastro.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearForm();
              },
              child: const Text('Entendi'),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    _nameController.clear();
    _ownerController.clear();
    _whatsappController.clear();
    _emailController.clear();
    _addressController.clear();
    _setsController.clear();
    _hoursController.clear();
    _notesController.clear();
    setState(() {
      _operationType = _operationTypes.first;
      _hasDigitalMenu = false;
      _wantsFutureCashback = false;
      _wantsFutureReservations = false;
    });
  }
}

const _operationTypes = [
  'Bar',
  'Barraca',
  'Restaurante de praia',
  'Quiosque',
];

String? _requiredValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Preencha este campo';
  }
  return null;
}

class _FormSection extends StatelessWidget {
  const _FormSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.oceanLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.ocean, size: 19),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title, style: AppTextStyles.sectionTitle),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (var index = 0; index < children.length; index++) ...[
            children[index],
            if (index < children.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    this.requiredField = false,
    this.maxLines = 1,
    this.keyboardType,
    this.readOnly = false,
    this.helperText,
    this.hintText,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool requiredField;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool readOnly;
  final String? helperText;
  final String? hintText;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: requiredField ? '$label *' : label,
        helperText: helperText,
        hintText: hintText,
      ),
      validator: validator ?? (requiredField ? _requiredValidator : null),
    );
  }
}

class _ToggleField extends StatelessWidget {
  const _ToggleField({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      dense: true,
      activeThumbColor: AppColors.ocean,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.ink,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
