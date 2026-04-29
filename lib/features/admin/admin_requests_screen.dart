import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock/mock_signup_requests.dart';
import '../../models/signup_request.dart';

class AdminRequestsScreen extends StatefulWidget {
  const AdminRequestsScreen({super.key});

  @override
  State<AdminRequestsScreen> createState() => _AdminRequestsScreenState();
}

class _AdminRequestsScreenState extends State<AdminRequestsScreen> {
  late List<SignupRequest> _requests;

  @override
  void initState() {
    super.initState();
    _requests = List.of(mockSignupRequests);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin mockado')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            const Text('Solicitações de bares', style: AppTextStyles.title),
            const SizedBox(height: 8),
            const Text(
              'Fluxo local para simular análise, aprovação e recusa de cadastros. Sem login, backend ou banco real.',
              style: AppTextStyles.bodyMuted,
            ),
            const SizedBox(height: 18),
            for (final request in _requests) ...[
              _RequestCard(
                request: request,
                onStatusChanged: (status) => _updateStatus(request.id, status),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  void _updateStatus(String id, SignupRequestStatus status) {
    setState(() {
      _requests = _requests.map((request) {
        if (request.id != id) {
          return request;
        }
        return request.copyWith(status: status);
      }).toList();
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(_statusMessage(status)),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  String _statusMessage(SignupRequestStatus status) {
    return switch (status) {
      SignupRequestStatus.pending =>
        'Solicitação voltou para pendente no mock.',
      SignupRequestStatus.approved => 'Solicitação aprovada no mock.',
      SignupRequestStatus.rejected => 'Solicitação recusada no mock.',
    };
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.onStatusChanged,
  });

  final SignupRequest request;
  final ValueChanged<SignupRequestStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      request.establishmentName,
                      style: AppTextStyles.sectionTitle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _StatusPill(status: request.status),
                ],
              ),
              const SizedBox(height: 10),
              _SummaryGrid(request: request),
            ],
          ),
          subtitle: const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Toque para ver detalhes da solicitação',
              style: AppTextStyles.caption,
            ),
          ),
          children: [
            const Divider(height: 22),
            _DetailRows(request: request),
            const SizedBox(height: 14),
            _RequestActions(
              status: request.status,
              onStatusChanged: onStatusChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.request});

  final SignupRequest request;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _InfoChip(
          icon: Icons.person_rounded,
          label: request.ownerName,
        ),
        _InfoChip(
          icon: Icons.chat_rounded,
          label: request.whatsapp,
        ),
        _InfoChip(
          icon: Icons.beach_access_rounded,
          label: request.beachName,
        ),
        _InfoChip(
          icon: Icons.storefront_rounded,
          label: request.operationType,
        ),
        _InfoChip(
          icon: Icons.event_seat_rounded,
          label: '${request.approximateSets} conjuntos',
        ),
      ],
    );
  }
}

class _DetailRows extends StatelessWidget {
  const _DetailRows({required this.request});

  final SignupRequest request;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DetailRow(
          icon: Icons.place_rounded,
          label: 'Endereço ou referência',
          value: request.address,
        ),
        _DetailRow(
          icon: Icons.schedule_rounded,
          label: 'Funcionamento',
          value: request.openingHours,
        ),
        _DetailRow(
          icon: Icons.menu_book_rounded,
          label: 'Cardápio digital',
          value: _yesNo(request.hasDigitalMenu),
        ),
        _DetailRow(
          icon: Icons.savings_rounded,
          label: 'Cashback futuro',
          value: _yesNo(request.wantsFutureCashback),
        ),
        _DetailRow(
          icon: Icons.event_available_rounded,
          label: 'Reservas futuras',
          value: _yesNo(request.wantsFutureReservations),
        ),
        _DetailRow(
          icon: Icons.notes_rounded,
          label: 'Observações',
          value: request.notes,
          isLast: true,
        ),
      ],
    );
  }

  String _yesNo(bool value) => value ? 'Sim' : 'Não';
}

class _RequestActions extends StatelessWidget {
  const _RequestActions({
    required this.status,
    required this.onStatusChanged,
  });

  final SignupRequestStatus status;
  final ValueChanged<SignupRequestStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        if (status != SignupRequestStatus.rejected)
          _ActionButton(
            label: 'Recusar',
            icon: Icons.close_rounded,
            onPressed: () => onStatusChanged(SignupRequestStatus.rejected),
          ),
        if (status != SignupRequestStatus.approved)
          _ActionButton(
            label: 'Aprovar',
            icon: Icons.check_rounded,
            filled: true,
            onPressed: () => onStatusChanged(SignupRequestStatus.approved),
          ),
        if (status != SignupRequestStatus.pending)
          _ActionButton(
            label: 'Voltar para pendente',
            icon: Icons.undo_rounded,
            onPressed: () => onStatusChanged(SignupRequestStatus.pending),
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    if (filled) {
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.ocean,
          foregroundColor: Colors.white,
        ),
        child: child,
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.oceanDark,
        side: const BorderSide(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 230),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.oceanLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.oceanDark, size: 15),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.oceanDark,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.violet, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final SignupRequestStatus status;

  @override
  Widget build(BuildContext context) {
    final style = switch (status) {
      SignupRequestStatus.pending => (
          'Pendente',
          AppColors.warning,
          const Color(0xFFFFF5D8)
        ),
      SignupRequestStatus.approved => (
          'Aprovada',
          AppColors.success,
          const Color(0xFFEAF8F2)
        ),
      SignupRequestStatus.rejected => (
          'Recusada',
          AppColors.danger,
          AppColors.coralLight
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: style.$3,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        style.$1,
        style: TextStyle(
          color: style.$2,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
