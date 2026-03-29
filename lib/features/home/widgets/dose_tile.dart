import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/dose_reminder_model.dart';
import '../models/dose_with_medication.dart';

class DoseTile extends StatelessWidget {
  final DoseWithMedication dose;
  final VoidCallback? onTaken;
  final VoidCallback? onSkipped;

  const DoseTile({super.key, required this.dose, this.onTaken, this.onSkipped});

  static const _pillColors = [
    Color(0xFF00C9A7),
    Color(0xFF0096FF),
    Color(0xFF8B5CF6),
    Color(0xFFF59E0B),
    Color(0xFFEC4899),
  ];

  Color get _pillColor =>
      _pillColors[dose.medicationName.hashCode.abs() % _pillColors.length];

  @override
  Widget build(BuildContext context) {
    final isTaken = dose.status == DoseReminderStatus.taken;
    final isSkipped = dose.status == DoseReminderStatus.skipped;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _pillColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(_dosageIcon, color: _pillColor, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dose.medicationName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              decoration: isSkipped
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isSkipped ? AppColors.textSecondary : null,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 12,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  dose.formattedTime,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '·  ${dose.dosageDisplay}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildActionButtons(isTaken, isSkipped),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isTaken, bool isSkipped) {
    if (isTaken) {
      return Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 20),
      );
    }
    if (isSkipped) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: AppColors.error, size: 20),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onSkipped,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.textDisabled.withValues(alpha: 0.5),
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTaken,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  IconData get _dosageIcon {
    switch (dose.dosageForm.toLowerCase()) {
      case 'tablet':
      case 'tablets':
        return Icons.medication;
      case 'capsule':
      case 'capsules':
        return Icons.medication_liquid;
      case 'liquid':
      case 'syrup':
      case 'solution':
        return Icons.water_drop;
      case 'injection':
        return Icons.vaccines;
      case 'cream':
      case 'ointment':
        return Icons.healing;
      case 'drops':
        return Icons.opacity;
      default:
        return Icons.medication;
    }
  }
}
