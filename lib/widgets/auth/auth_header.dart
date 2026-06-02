/// Auth Header - Teal header with wave and logo (Figma design)
/// Used on Sign In and Sign Up screens.
library;

import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class AuthHeader extends StatelessWidget {
  final VoidCallback? onBack;

  const AuthHeader({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Teal background with wave
        Container(
          height: 140,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.primary,
          ),
          child: CustomPaint(
            painter: _WavePainter(),
            size: Size.infinite,
          ),
        ),
        // Content overlay
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (onBack != null)
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  )
                else
                  const SizedBox(width: 48),
                // Logo - white circle with 'b'
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'b',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                // Airplane icon (outline)
                Icon(
                  Icons.flight_takeoff,
                  color: Colors.white.withOpacity(0.5),
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Painter for wave separator between header and content
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height - 60,
      size.width * 0.5,
      size.height - 30,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
