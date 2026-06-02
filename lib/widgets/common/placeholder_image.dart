/// Placeholder image widget - easy swap with Figma assets
/// Usage: PlaceholderImage(height: 120, width: 200)
library;

import 'package:flutter/material.dart';

class PlaceholderImage extends StatelessWidget {
  final double? width;
  final double height;

  const PlaceholderImage({
    super.key,
    this.width,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.image_outlined,
        size: 48,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
