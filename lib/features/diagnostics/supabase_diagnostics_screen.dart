import 'package:flutter/material.dart';

import '../../core/services/supabase_client_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/supabase_public_data_repository.dart';
import '../../shared/widgets/primary_button.dart';

class SupabaseDiagnosticsScreen extends StatefulWidget {
  const SupabaseDiagnosticsScreen({super.key});

  @override
  State<SupabaseDiagnosticsScreen> createState() {
    return _SupabaseDiagnosticsScreenState();
  }
}

class _SupabaseDiagnosticsScreenState
    extends State<SupabaseDiagnosticsScreen> {
  bool _isLoading = true;
  _DiagnosticStep _connectionStep = _DiagnosticStep.waiting('Conexao');
  _DiagnosticStep _beachesStep = _DiagnosticStep.waiting('Praias ativas');
  _DiagnosticStep _establishmentsStep = _DiagnosticStep.waiting(
    'Estabelecimentos ativos/aprovados',
  );

  @override
  void initState() {
    super.initState();
    _runDiagnostics();
  }

  Future<void> _runDiagnostics() async {
    setState(() {
      _isLoading = true;
      _connectionStep = _DiagnosticStep.waiting('Conexao');
      _beachesStep = _DiagnosticStep.waiting('Praias ativas');
      _establishmentsStep = _DiagnosticStep.waiting(
        'Estabelecimentos ativos/aprovados',
      );
    });

    final configurationMessage = SupabaseClientService.configurationMessage;
    if (configurationMessage != null) {
      setState(() {
        _isLoading = false;
        _connectionStep = _DiagnosticStep.warning(
          'Conexao',
          configurationMessage,
        );
        _beachesStep = _DiagnosticStep.waiting(
          'Praias ativas',
          'Aguardando configuracao local.',
        );
        _establishmentsStep = _DiagnosticStep.waiting(
          'Estabelecimentos ativos/aprovados',
          'Aguardando configuracao local.',
        );
      });
      return;
    }

    final repository = SupabasePublicDataRepository();

    try {
      await repository.testConnection();
      setState(() {
        _connectionStep = _DiagnosticStep.success(
          'Conexao',
          'Cliente Supabase respondeu a uma leitura publica.',
        );
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _connectionStep = _DiagnosticStep.error(
          'Conexao',
          _friendlyError(error),
        );
        _beachesStep = _DiagnosticStep.waiting(
          'Praias ativas',
          'Nao testado porque a conexao falhou.',
        );
        _establishmentsStep = _DiagnosticStep.waiting(
          'Estabelecimentos ativos/aprovados',
          'Nao testado porque a conexao falhou.',
        );
      });
      return;
    }

    try {
      final beaches = await repository.fetchActiveBeaches();
      setState(() {
        _beachesStep = _DiagnosticStep.success(
          'Praias ativas',
          '${beaches.length} registro(s) retornado(s).',
          items: beaches.map((beach) {
            return _labelFrom(beach, fallback: 'Praia sem nome');
          }).toList(),
        );
      });
    } catch (error) {
      setState(() {
        _beachesStep = _DiagnosticStep.error(
          'Praias ativas',
          _friendlyError(error),
        );
      });
    }

    try {
      final establishments =
          await repository.fetchApprovedActiveEstablishments();
      setState(() {
        _establishmentsStep = _DiagnosticStep.success(
          'Estabelecimentos ativos/aprovados',
          '${establishments.length} registro(s) retornado(s).',
          items: establishments.map((establishment) {
            return _labelFrom(establishment, fallback: 'Bar sem nome');
          }).toList(),
        );
      });
    } catch (error) {
      setState(() {
        _establishmentsStep = _DiagnosticStep.error(
          'Estabelecimentos ativos/aprovados',
          _friendlyError(error),
        );
      });
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _labelFrom(
    Map<String, dynamic> record, {
    required String fallback,
  }) {
    final name = record['name'];
    if (name is String && name.trim().isNotEmpty) {
      return name.trim();
    }

    return fallback;
  }

  String _friendlyError(Object error) {
    final text = error.toString();
    if (text.trim().isEmpty) {
      return 'Erro desconhecido ao consultar o Supabase.';
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnostico Supabase'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const Text(
              'Teste interno de leitura publica',
              style: AppTextStyles.title,
            ),
            const SizedBox(height: 8),
            const Text(
              'Esta tela nao altera dados, nao faz login e nao troca os mocks da Home.',
              style: AppTextStyles.bodyMuted,
            ),
            const SizedBox(height: 18),
            _DiagnosticCard(step: _connectionStep),
            const SizedBox(height: 12),
            _DiagnosticCard(step: _beachesStep),
            const SizedBox(height: 12),
            _DiagnosticCard(step: _establishmentsStep),
            const SizedBox(height: 20),
            PrimaryButton(
              label: _isLoading ? 'Testando...' : 'Testar novamente',
              icon: Icons.refresh_rounded,
              onPressed: _isLoading ? null : _runDiagnostics,
            ),
          ],
        ),
      ),
    );
  }
}

class _DiagnosticCard extends StatelessWidget {
  const _DiagnosticCard({required this.step});

  final _DiagnosticStep step;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(step.icon, color: step.color),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(step.title, style: AppTextStyles.sectionTitle),
                    const SizedBox(height: 4),
                    Text(step.message, style: AppTextStyles.bodyMuted),
                  ],
                ),
              ),
            ],
          ),
          if (step.items.isNotEmpty) ...[
            const SizedBox(height: 12),
            for (final item in step.items.take(6))
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: AppColors.success,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

enum _DiagnosticStatus { waiting, success, warning, error }

class _DiagnosticStep {
  const _DiagnosticStep._({
    required this.title,
    required this.message,
    required this.status,
    this.items = const [],
  });

  factory _DiagnosticStep.waiting(String title, [String? message]) {
    return _DiagnosticStep._(
      title: title,
      message: message ?? 'Aguardando teste.',
      status: _DiagnosticStatus.waiting,
    );
  }

  factory _DiagnosticStep.success(
    String title,
    String message, {
    List<String> items = const [],
  }) {
    return _DiagnosticStep._(
      title: title,
      message: message,
      status: _DiagnosticStatus.success,
      items: items,
    );
  }

  factory _DiagnosticStep.warning(String title, String message) {
    return _DiagnosticStep._(
      title: title,
      message: message,
      status: _DiagnosticStatus.warning,
    );
  }

  factory _DiagnosticStep.error(String title, String message) {
    return _DiagnosticStep._(
      title: title,
      message: message,
      status: _DiagnosticStatus.error,
    );
  }

  final String title;
  final String message;
  final _DiagnosticStatus status;
  final List<String> items;

  IconData get icon {
    return switch (status) {
      _DiagnosticStatus.waiting => Icons.schedule_rounded,
      _DiagnosticStatus.success => Icons.check_circle_rounded,
      _DiagnosticStatus.warning => Icons.info_rounded,
      _DiagnosticStatus.error => Icons.error_rounded,
    };
  }

  Color get color {
    return switch (status) {
      _DiagnosticStatus.waiting => AppColors.muted,
      _DiagnosticStatus.success => AppColors.success,
      _DiagnosticStatus.warning => AppColors.warning,
      _DiagnosticStatus.error => AppColors.danger,
    };
  }
}
