import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';

class CalendarStrip extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static const _dayAbbr = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final start = selectedDate.subtract(const Duration(days: 2));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Text(
                _isToday(selectedDate)
                    ? 'Today, ${selectedDate.day} ${_months[selectedDate.month - 1]}'
                    : '${_dayAbbr[selectedDate.weekday - 1]}, ${selectedDate.day} ${_months[selectedDate.month - 1]}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 85,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              final date = start.add(Duration(days: i));
              final isSelected = _isSameDay(date, selectedDate);

              return GestureDetector(
                onTap: () => onDateSelected(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  width: 60,
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    color: isSelected ? null : AppColors.surface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : AppColors.border,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primaryLight.withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            )
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _dayAbbr[date.weekday - 1],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.9)
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, curve: Curves.easeOut);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isToday(DateTime d) => _isSameDay(d, DateTime.now());
}
