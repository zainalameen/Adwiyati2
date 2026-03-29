import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/router.dart';
import '../models/cabinet_entry.dart';
import '../providers/cabinet_providers.dart';

class CabinetPage extends ConsumerStatefulWidget {
  const CabinetPage({super.key});

  @override
  ConsumerState<CabinetPage> createState() => _CabinetPageState();
}

class _CabinetPageState extends ConsumerState<CabinetPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  CabinetFormFilter _filter = CabinetFormFilter.all;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<CabinetEntry> _applyFilters(List<CabinetEntry> all) {
    var list = all;
    if (_query.trim().isNotEmpty) {
      final q = _query.trim().toLowerCase();
      list = list.where((e) {
        final m = e.medication;
        return m.tradeNameEn.toLowerCase().contains(q) ||
            m.tradeNameAr.toLowerCase().contains(q) ||
            m.scientificNameEn.toLowerCase().contains(q);
      }).toList();
    }
    if (_filter != CabinetFormFilter.all) {
      list = list
          .where((e) => _filter.matches(e.medication.dosageForm))
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(cabinetListProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: AppColors.background),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  children: [
                    _CircleIconButton(
                      icon: Icons.person_outline_rounded,
                      onTap: () => context.push(AppRoutes.profile),
                    ),
                    const Spacer(),
                    _FabAdd(onTap: () => context.push(AppRoutes.scan)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _query = v),
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Search medications...',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.textSecondary,
                    ),
                    filled: true,
                    fillColor: AppColors.surface.withValues(alpha: 0.45),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    for (final f in CabinetFormFilter.values)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _FilterChip(
                          label: f.label,
                          selected: _filter == f,
                          onTap: () => setState(() => _filter = f),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: async.when(
                  data: (all) {
                    final items = _applyFilters(all);
                    if (all.isEmpty) {
                      return RefreshIndicator(
                        color: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        onRefresh: () async {
                          ref.invalidate(cabinetListProvider);
                        },
                        child: const _EmptyCabinet(),
                      );
                    }
                    if (items.isEmpty) {
                      return RefreshIndicator(
                        color: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        onRefresh: () async {
                          ref.invalidate(cabinetListProvider);
                        },
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                            ),
                            Center(
                              child: Text(
                                'No medications match your search.',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return RefreshIndicator(
                      color: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      onRefresh: () async {
                        ref.invalidate(cabinetListProvider);
                      },
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.74,
                            ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final entry = items[index];
                          return _CabinetMedCard(
                            entry: entry,
                            onTap: () => context.push(
                              AppRoutes.cabinetMedicationDetails(
                                entry.cabinet.cabinetMedId,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                  error: (e, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Could not load cabinet.\n$e',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum CabinetFormFilter {
  all,
  pills,
  syrups,
  other;

  String get label => switch (this) {
    CabinetFormFilter.all => 'All',
    CabinetFormFilter.pills => 'Pills',
    CabinetFormFilter.syrups => 'Syrups',
    CabinetFormFilter.other => 'Other',
  };

  bool matches(String dosageForm) {
    final f = dosageForm.toLowerCase();
    switch (this) {
      case CabinetFormFilter.all:
        return true;
      case CabinetFormFilter.pills:
        return _isPillLike(f);
      case CabinetFormFilter.syrups:
        return _isSyrupLike(f);
      case CabinetFormFilter.other:
        return !_isPillLike(f) && !_isSyrupLike(f);
    }
  }

  static bool _isPillLike(String f) {
    return f.contains('pill') ||
        f.contains('tablet') ||
        f.contains('capsule') ||
        f.contains('caplet');
  }

  static bool _isSyrupLike(String f) {
    return f.contains('syrup') ||
        f.contains('liquid') ||
        f.contains('suspension') ||
        f.contains('drops') ||
        f.contains('solution');
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border, width: 2),
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 22),
        ),
      ),
    );
  }
}

class _FabAdd extends StatelessWidget {
  final VoidCallback onTap;

  const _FabAdd({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.45),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: selected ? AppColors.primaryGradient : null,
            color: selected ? null : AppColors.surface.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? Colors.transparent : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _CabinetMedCard extends StatelessWidget {
  final CabinetEntry entry;
  final VoidCallback onTap;

  const _CabinetMedCard({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final urgent = entry.expiryUrgency != ExpiryUrgency.normal;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.12),
                            AppColors.secondary.withValues(alpha: 0.08),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.medication_rounded,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    if (entry.showAlertBadge)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: entry.cabinet.isExpired
                                ? AppColors.error
                                : AppColors.warning,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.background,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.priority_high_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  entry.displayName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.doseLine,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  entry.quantityLine,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textDisabled,
                  ),
                ),
                const Spacer(),
                _ExpiryBadge(
                  date: entry.cabinet.expirationDate,
                  urgent: urgent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpiryBadge extends StatelessWidget {
  final DateTime date;
  final bool urgent;

  const _ExpiryBadge({required this.date, required this.urgent});

  String get _label {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return 'Expires: $y-$m-$d';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: urgent
            ? AppColors.warning.withValues(alpha: 0.22)
            : AppColors.surfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.35)),
      ),
      child: Text(
        _label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: urgent ? AppColors.warning : AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyCabinet extends StatelessWidget {
  const _EmptyCabinet();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
