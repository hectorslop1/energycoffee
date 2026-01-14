import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class AssignTablePage extends StatelessWidget {
  const AssignTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text(AppStrings.assignTable),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Assign Table Page - Coming Soon'),
      ),
    );
  }
}
