import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TreatmentsPage extends StatefulWidget {
  const TreatmentsPage({super.key});

  @override
  State<TreatmentsPage> createState() => _TreatmentsPageState();
}

class _TreatmentsPageState extends State<TreatmentsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              _TreatmentList(isActive: true),
              _TreatmentList(isActive: false),
            ],
          ),
        ),
      ],
    );
  }
}

class _TreatmentList extends StatelessWidget {
  final bool isActive;

  const _TreatmentList({required this.isActive});

  @override
  Widget build(BuildContext context) {
    // TODO: fetch from Supabase active_treatment table
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.medication_outlined : Icons.check_circle_outline,
            size: 56,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: 12),
          Text(
            isActive
                ? 'No active treatments yet'
                : 'No completed treatments',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
