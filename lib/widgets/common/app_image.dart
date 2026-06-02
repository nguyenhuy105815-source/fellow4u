/// Widget hiển thị ảnh - hỗ trợ asset (lib/, assets/) và network URL
library;

import 'package:flutter/material.dart';

/// Hiển thị ảnh từ asset path hoặc URL. Asset path: lib/images/..., assets/...
class AppImage extends StatelessWidget {
  final String? imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
  });

  static bool _isAssetPath(String path) =>
      path.startsWith('lib/') || path.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _placeholder();
    }
    if (_isAssetPath(imageUrl!)) {
      return Image.asset(
        imageUrl!,
        fit: fit ?? BoxFit.cover,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return Image.network(
      imageUrl!,
      fit: fit ?? BoxFit.cover,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  /// Trả về ImageProvider phù hợp (Asset hoặc Network)
  static ImageProvider imageProvider(String url) {
    if (_isAssetPath(url)) return AssetImage(url);
    return NetworkImage(url);
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Icon(Icons.image_not_supported, color: Colors.grey[500], size: 32),
    );
  }
}
