import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar strip placeholder
              _SectionCard(
                title: "Today's Schedule",
                icon: Icons.calendar_month_outlined,
                child: SizedBox(
                  height: 80,
                  child: Center(
                    child: Text(
                      'Calendar — coming soon',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // To Take section
              _SectionCard(
                title: 'To Take',
                icon: Icons.medication_outlined,
                child: const _EmptyState(
                  message: 'No doses scheduled for today',
                ),
              ),
              const SizedBox(height: 16),

              // Progress Log section
              _SectionCard(
                title: 'Progress Log',
                icon: Icons.bar_chart_outlined,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatTile(label: 'Adherence', value: '–%'),
                    _StatTile(label: 'Taken', value: '0'),
                    _StatTile(label: 'Scheduled', value: '0'),
                    _StatTile(label: 'Streak', value: '0 days'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          message,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;

  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppColors.primary,
                fontSize: 20,
              ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
