import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';

class ComingSoonDialog extends StatelessWidget {
  const ComingSoonDialog({
    required this.featureName,
    super.key,
  });

  final String featureName;

  static Future<void> show(
    BuildContext context, {
    required String featureName,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => ComingSoonDialog(featureName: featureName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.schedule_rounded, color: AppColors.violet),
      title: Text('$featureName em breve'),
      content: const Text(AppStrings.comingSoonMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Entendi'),
        ),
      ],
    );
  }
}
