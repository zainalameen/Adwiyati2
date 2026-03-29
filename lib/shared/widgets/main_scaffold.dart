import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    return switch (location) {
      AppRoutes.home => 0,
      AppRoutes.chatbot => 1,
      AppRoutes.scan => 2,
      AppRoutes.treatments => 3,
      AppRoutes.cabinet => 4,
      _ => 0,
    };
  }

  String _titleForLocation(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    return switch (location) {
      AppRoutes.home => 'Home',
      AppRoutes.chatbot => 'Health Assistant',
      AppRoutes.scan => 'Scan Medication',
      AppRoutes.treatments => 'Treatments',
      AppRoutes.cabinet => 'My Cabinet',
      _ => 'Adwiyati',
    };
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _titleForLocation(context),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            shadows: [
              Shadow(
                color: AppColors.primaryLight.withValues(alpha: 0.5),
                blurRadius: 20,
              ),
            ],
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => context.push(AppRoutes.profile),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 2),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://api.dicebear.com/7.x/avataaars/png?seed=Felix',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => _showAddMedicationSheet(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: AppColors.border, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  currentIndex: index,
                  onTap: (i) => _onTabTapped(context, i),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: [
                    _buildNavItem(Icons.home_outlined, Icons.home, 0, index),
                    _buildNavItem(
                      Icons.chat_bubble_outline,
                      Icons.chat_bubble,
                      1,
                      index,
                    ),
                    _buildNavItem(
                      Icons.qr_code_scanner,
                      Icons.qr_code_scanner,
                      2,
                      index,
                    ),
                    _buildNavItem(
                      Icons.medication_outlined,
                      Icons.medication,
                      3,
                      index,
                    ),
                    _buildNavItem(
                      Icons.inventory_2_outlined,
                      Icons.inventory_2,
                      4,
                      index,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData unselectedIcon,
    IconData selectedIcon,
    int itemIndex,
    int currentIndex,
  ) {
    final isSelected = itemIndex == currentIndex;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isSelected ? 12 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ShaderMask(
          blendMode: isSelected ? BlendMode.srcIn : BlendMode.dst,
          shaderCallback: (bounds) => isSelected
              ? AppColors.primaryGradient.createShader(bounds)
              : const LinearGradient(
                  colors: [AppColors.textSecondary, AppColors.textSecondary],
                ).createShader(bounds),
          child: Icon(
            isSelected ? selectedIcon : unselectedIcon,
            size: 26,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
      label: '',
    );
  }

  void _onTabTapped(BuildContext context, int index) {
    final routes = [
      AppRoutes.home,
      AppRoutes.chatbot,
      AppRoutes.scan,
      AppRoutes.treatments,
      AppRoutes.cabinet,
    ];
    context.go(routes[index]);
  }

  Future<void> _showAddMedicationSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Add New',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(sheetContext).pop();
                        context.push(AppRoutes.addTreatment);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Add new treatment'),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      context.push(AppRoutes.addCabinet);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryLight,
                      side: const BorderSide(color: AppColors.primaryLight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Add new cabinet medication'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
