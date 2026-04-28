import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/establishment.dart';

class MockMapPreview extends StatelessWidget {
  const MockMapPreview({
    required this.establishments,
    this.onTap,
    this.expanded = false,
    super.key,
  });

  final List<Establishment> establishments;
  final VoidCallback? onTap;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: expanded ? 420 : 190,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.oceanLight,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MapLinesPainter(),
                  ),
                ),
                const Positioned(
                  left: 4,
                  top: 0,
                  child: Text('Mapa visual de Boa Viagem',
                      style: AppTextStyles.sectionTitle),
                ),
                const Positioned(
                  left: 4,
                  top: 30,
                  child: Text('Placeholder sem Google Maps',
                      style: AppTextStyles.caption),
                ),
                for (var index = 0; index < establishments.length; index++)
                  _MapPin(
                    label: establishments[index].name,
                    top: constraints.maxHeight *
                        _pinPositions[index % _pinPositions.length].dy,
                    left: constraints.maxWidth *
                        _pinPositions[index % _pinPositions.length].dx,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

const _pinPositions = [
  Offset(0.06, 0.46),
  Offset(0.43, 0.58),
  Offset(0.66, 0.36),
  Offset(0.19, 0.72),
];

class _MapPin extends StatelessWidget {
  const _MapPin({
    required this.label,
    required this.top,
    required this.left,
  });

  final String label;
  final double top;
  final double left;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              label.split(' ').take(2).join(' '),
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Icon(Icons.location_on_rounded, color: AppColors.coral),
        ],
      ),
    );
  }
}

class _MapLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final oceanPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.72)
      ..style = PaintingStyle.fill;
    final sandPaint = Paint()
      ..color = AppColors.sand
      ..style = PaintingStyle.fill;
    final roadPaint = Paint()
      ..color = AppColors.ocean.withValues(alpha: 0.22)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.58, 0, size.width * 0.42, size.height),
        const Radius.circular(22),
      ),
      oceanPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.height * 0.64, size.width, size.height * 0.36),
        const Radius.circular(22),
      ),
      sandPaint,
    );
    final path = Path()
      ..moveTo(16, size.height * 0.38)
      ..quadraticBezierTo(
        size.width * 0.34,
        size.height * 0.22,
        size.width * 0.62,
        size.height * 0.48,
      )
      ..quadraticBezierTo(
        size.width * 0.82,
        size.height * 0.66,
        size.width - 22,
        size.height * 0.42,
      );
    canvas.drawPath(path, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
