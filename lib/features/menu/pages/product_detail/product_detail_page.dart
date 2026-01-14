import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Center(
        child: Text('Product Detail Page - Coming Soon'),
      ),
    );
  }
}
