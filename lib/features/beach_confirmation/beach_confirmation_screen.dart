import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/constants/app_strings.dart';
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 640;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 42,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: compact ? 176 : 218,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.oceanLight, AppColors.violetLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 22,
                            top: compact ? 20 : 28,
                            child: Icon(
                              Icons.waves_rounded,
                              color: AppColors.ocean,
                              size: compact ? 58 : 72,
                            ),
                          ),
                          const Positioned(
                            left: 22,
                            bottom: 22,
                            right: 22,
                            child: Text(
                              AppStrings.pilotLocation,
                              style: AppTextStyles.title,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Confirmar praia-piloto',
                      style: AppTextStyles.title,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      boaViagemBeach.description,
                      style: AppTextStyles.bodyMuted,
                    ),
                    SizedBox(height: compact ? 28 : 48),
                    PrimaryButton(
                      label: 'Ver bares em Boa Viagem',
                      icon: Icons.explore_rounded,
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                          AppRoutes.home,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
