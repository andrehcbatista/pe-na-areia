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
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          children: [
            const Text('Solicitacoes de bares', style: AppTextStyles.title),
            const SizedBox(height: 8),
            const Text(
              'Aprovacao e recusa acontecem apenas visualmente na memoria do app.',
              style: AppTextStyles.bodyMuted,
            ),
            const SizedBox(height: 18),
            for (final request in _requests) ...[
              _RequestCard(
                request: request,
                onApprove: () => _updateStatus(
                  request.id,
                  SignupRequestStatus.approved,
                ),
                onReject: () => _updateStatus(
                  request.id,
                  SignupRequestStatus.rejected,
                ),
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
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  final SignupRequest request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  request.establishmentName,
                  style: AppTextStyles.sectionTitle,
                ),
              ),
              _StatusPill(status: request.status),
            ],
          ),
          const SizedBox(height: 10),
          Text('Responsavel: ${request.ownerName}',
              style: AppTextStyles.bodyMuted),
          const SizedBox(height: 4),
          Text('Telefone: ${request.phone}', style: AppTextStyles.bodyMuted),
          const SizedBox(height: 4),
          Text('Endereco: ${request.address}', style: AppTextStyles.bodyMuted),
          const SizedBox(height: 4),
          Text(request.notes, style: AppTextStyles.bodyMuted),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onReject,
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('Recusar'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onApprove,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Aprovar'),
                ),
              ),
            ],
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
          'Aprovado',
          AppColors.success,
          const Color(0xFFEAF8F2)
        ),
      SignupRequestStatus.rejected => (
          'Recusado',
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
