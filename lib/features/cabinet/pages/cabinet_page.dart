import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CabinetPage extends StatelessWidget {
  const CabinetPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: fetch from Supabase cabinet_med table
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: 16),
          Text(
            'Your cabinet is empty',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add medications using the + button above',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
