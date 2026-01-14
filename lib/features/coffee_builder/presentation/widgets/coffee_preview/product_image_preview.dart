import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../../state/coffee_builder_state.dart';
import '../../../domain/enums/coffee_size.dart';

class ProductImagePreview extends StatelessWidget {
  final String heroTag;

  const ProductImagePreview({
    super.key,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeBuilderState>(
      builder: (context, state, child) {
        final imagePath = state.productImagePath;
        final size = state.currentCoffee.size;

        return Hero(
          tag: heroTag,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            height: 220,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Center(
              child: _buildAnimatedImage(imagePath, size),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedImage(String? imagePath, CoffeeSize size) {
    if (imagePath == null || imagePath.isEmpty) {
      return _buildFallbackIcon();
    }

    final imageSize = _getImageSizeForCoffeeSize(size);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      width: imageSize,
      height: imageSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _getImageWidget(imagePath),
      ),
    );
  }

  double _getImageSizeForCoffeeSize(CoffeeSize size) {
    switch (size) {
      case CoffeeSize.small:
        return 160.0;
      case CoffeeSize.medium:
        return 180.0;
      case CoffeeSize.large:
        return 200.0;
      case CoffeeSize.extraLarge:
        return 220.0;
    }
  }

  Widget _getImageWidget(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
      );
    } else if (File(imagePath).existsSync()) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
      );
    } else {
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
      );
    }
  }

  Widget _buildFallbackIcon() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.brown.withOpacity(0.1),
      ),
      child: Icon(
        Icons.coffee_rounded,
        size: 80,
        color: Colors.brown.withOpacity(0.3),
      ),
    );
  }
}
