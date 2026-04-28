import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock/mock_beaches.dart';
import '../../shared/widgets/primary_button.dart';

class BeachConfirmationScreen extends StatelessWidget {
  const BeachConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Container(
                height: 230,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.oceanLight, AppColors.violetLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Stack(
                  children: [
                    Positioned(
                      right: 24,
                      top: 28,
                      child: Icon(
                        Icons.waves_rounded,
                        color: AppColors.ocean,
                        size: 72,
                      ),
                    ),
                    Positioned(
                      left: 24,
                      bottom: 24,
                      right: 24,
                      child: Text(
                        'Boa Viagem, Recife/PE',
                        style: AppTextStyles.title,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text('Confirmar praia piloto', style: AppTextStyles.title),
              const SizedBox(height: 10),
              Text(boaViagemBeach.description, style: AppTextStyles.bodyMuted),
              const Spacer(),
              PrimaryButton(
                label: 'Ver bares em Boa Viagem',
                icon: Icons.explore_rounded,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
