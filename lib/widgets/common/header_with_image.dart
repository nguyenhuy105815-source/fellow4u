/// Header with image background - Guides-More, Tours-More
/// Hỗ trợ imagePath (asset) hoặc imageUrl (link mạng).
library;

import 'package:flutter/material.dart';

class HeaderWithImage extends StatelessWidget {
  final String title;
  final String? imagePath;
  final String? imageUrl;
  final double height;
  final VoidCallback? onBack;
  final Widget? trailing;

  const HeaderWithImage({
    super.key,
    required this.title,
    this.imagePath,
    this.imageUrl,
    this.height = 160,
    this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background - image (asset/url) or gradient
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF3D9E98),
                const Color(0xFF2A7A76),
                const Color(0xFF1A5C59),
              ],
            ),
          ),
          child: _buildImage(),
        ),
        // Dark overlay for text readability
        Container(
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
        ),
        // Back button
        if (onBack != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
        // Trailing (e.g. profile icon)
        if (trailing != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: trailing!,
          ),
        // Title
        Positioned(
          left: 20,
          right: 20,
          bottom: 24,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  static bool _isAsset(String? p) =>
      p != null && (p.startsWith('lib/') || p.startsWith('assets/'));

  Widget? _buildImage() {
    final path = imagePath ?? imageUrl;
    if (path == null || path.isEmpty) return null;
    if (_isAsset(path)) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      );
    }
    return Image.network(
      path,
      fit: BoxFit.cover,
      width: double.infinity,
      height: height,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  }
}
