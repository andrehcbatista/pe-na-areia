import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/services/supabase_client_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock/mock_beaches.dart';
import '../../data/mock/mock_establishments.dart';
import '../../data/repositories/supabase_public_data_repository.dart';
import '../../models/establishment.dart';
import '../../shared/widgets/coming_soon_dialog.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/secondary_button.dart';
import 'widgets/beach_header.dart';
import 'widgets/establishment_card.dart';
import 'widgets/mock_map_preview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum _HomeDataSource { local, supabase }

class _HomeScreenState extends State<HomeScreen> {
  List<Establishment> _establishments = mockEstablishments;
  _HomeDataSource _dataSource = _HomeDataSource.local;
  bool _isCheckingSupabase = true;

  @override
  void initState() {
    super.initState();
    _loadPublicEstablishments();
  }

  Future<void> _loadPublicEstablishments() async {
    if (!SupabaseClientService.isConfigured) {
      if (mounted) {
        setState(() {
          _isCheckingSupabase = false;
        });
      }
      return;
    }

    try {
      final establishments = await SupabasePublicDataRepository()
          .fetchBoaViagemApprovedActiveEstablishments();

      if (!mounted) {
        return;
      }

      if (establishments.isEmpty) {
        setState(() {
          _isCheckingSupabase = false;
          _dataSource = _HomeDataSource.local;
          _establishments = mockEstablishments;
        });
        return;
      }

      setState(() {
        _isCheckingSupabase = false;
        _dataSource = _HomeDataSource.supabase;
        _establishments = establishments;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isCheckingSupabase = false;
        _dataSource = _HomeDataSource.local;
        _establishments = mockEstablishments;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descobrir bares'),
        actions: [
          _LoginEntryButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.login);
            },
          ),
          IconButton(
            tooltip: 'QR Code em breve',
            icon: const Icon(Icons.qr_code_scanner_rounded),
            onPressed: () => ComingSoonDialog.show(
              context,
              featureName: 'QR Code',
            ),
          ),
          IconButton(
            tooltip: 'Admin mockado',
            icon: const Icon(Icons.admin_panel_settings_rounded),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.adminRequests);
            },
          ),
          IconButton(
            tooltip: 'Diagnostico Supabase',
            icon: const Icon(Icons.cloud_sync_rounded),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.supabaseDiagnostics,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            BeachHeader(
              beach: boaViagemBeach,
            ),
            const SizedBox(height: 16),
            MockMapPreview(
              establishments: _establishments,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.map),
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final stackButtons = constraints.maxWidth < 360;
                final mapButton = SecondaryButton(
                  label: 'Ver mapa',
                  icon: Icons.map_rounded,
                  onPressed: () => Navigator.of(context).pushNamed(
                    AppRoutes.map,
                  ),
                );
                final signupButton = SecondaryButton(
                  label: 'Cadastrar bar',
                  icon: Icons.storefront_rounded,
                  onPressed: () => Navigator.of(context).pushNamed(
                    AppRoutes.establishmentSignup,
                  ),
                );

                if (stackButtons) {
                  return Column(
                    children: [
                      mapButton,
                      const SizedBox(height: 10),
                      signupButton,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: mapButton),
                    const SizedBox(width: 10),
                    Expanded(child: signupButton),
                  ],
                );
              },
            ),
            const SizedBox(height: 22),
            const Text(
              'Bares na faixa de areia',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: 6),
            if (_dataSource == _HomeDataSource.supabase)
              const Text(
                'Dados publicos reais para descoberta, com detalhes e cardapio quando disponiveis.',
                style: AppTextStyles.bodyMuted,
              )
            else
              const Text(
                'Dados locais para validar descoberta, cardápio, distância e disponibilidade.',
                style: AppTextStyles.bodyMuted,
              ),
            if (_isCheckingSupabase) ...[
              const SizedBox(height: 10),
              const _PublicDataLoadingNotice(),
            ],
            if (kDebugMode) ...[
              const SizedBox(height: 8),
              _DataSourceIndicator(
                isCheckingSupabase: _isCheckingSupabase,
                dataSource: _dataSource,
              ),
            ],
            const SizedBox(height: 14),
            for (final establishment in _establishments) ...[
              EstablishmentCard(
                establishment: establishment,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.establishmentDetail,
                    arguments: establishment,
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 8),
            PrimaryButton(
              label: 'Abrir Admin mockado',
              icon: Icons.fact_check_rounded,
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.adminRequests,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sem login, pagamento, pedido real, reserva real ou integração externa nesta etapa.',
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
    );
  }
}

class _LoginEntryButton extends StatelessWidget {
  const _LoginEntryButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.person_outline_rounded, size: 18),
      label: const Text('Entrar'),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.oceanDark,
        textStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class _PublicDataLoadingNotice extends StatelessWidget {
  const _PublicDataLoadingNotice();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'Verificando dados publicos. Os dados locais seguem disponiveis.',
            style: AppTextStyles.caption,
          ),
        ),
      ],
    );
  }
}

class _DataSourceIndicator extends StatelessWidget {
  const _DataSourceIndicator({
    required this.isCheckingSupabase,
    required this.dataSource,
  });

  final bool isCheckingSupabase;
  final _HomeDataSource dataSource;

  @override
  Widget build(BuildContext context) {
    final label = isCheckingSupabase
        ? 'Verificando Supabase'
        : dataSource == _HomeDataSource.supabase
            ? 'Dados reais'
            : 'Dados locais';
    final icon = dataSource == _HomeDataSource.supabase
        ? Icons.cloud_done_rounded
        : Icons.storage_rounded;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.oceanLight,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.oceanDark),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.oceanDark,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
