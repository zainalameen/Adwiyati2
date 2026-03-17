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

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    return Scaffold(
      extendBody: true,
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
                    _buildNavItem(Icons.chat_bubble_outline, Icons.chat_bubble, 1, index),
                    _buildNavItem(Icons.qr_code_scanner, Icons.qr_code_scanner, 2, index),
                    _buildNavItem(Icons.medication_outlined, Icons.medication, 3, index),
                    _buildNavItem(Icons.inventory_2_outlined, Icons.inventory_2, 4, index),
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
      IconData unselectedIcon, IconData selectedIcon, int itemIndex, int currentIndex) {
    final isSelected = itemIndex == currentIndex;
    
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: isSelected ? 12 : 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ShaderMask(
          blendMode: isSelected ? BlendMode.srcIn : BlendMode.dst,
          shaderCallback: (bounds) => isSelected
              ? AppColors.primaryGradient.createShader(bounds)
              : const LinearGradient(colors: [AppColors.textSecondary, AppColors.textSecondary])
                  .createShader(bounds),
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
}
