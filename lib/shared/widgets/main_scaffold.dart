import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router.dart';

/// Persistent shell containing the top and bottom navigation bars that wrap
/// the 5 core screens (Home, Chatbot, Scan, Treatments, Cabinet).
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.account_circle_outlined),
          onPressed: () => context.push(AppRoutes.profile),
          tooltip: 'Profile',
        ),
        title: const _AppBarTitle(),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showAddMedicationSheet(context),
            tooltip: 'Add Medication',
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => _onTabTapped(context, i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            activeIcon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication_outlined),
            activeIcon: Icon(Icons.medication),
            label: 'Treatments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Cabinet',
          ),
        ],
      ),
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

  void _showAddMedicationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _AddMedicationSheet(),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final title = switch (location) {
      AppRoutes.home => 'Home',
      AppRoutes.chatbot => 'AI Assistant',
      AppRoutes.scan => 'Scan Medication',
      AppRoutes.treatments => 'Treatments',
      AppRoutes.cabinet => 'My Cabinet',
      _ => 'Adwiyati',
    };
    return Text(title);
  }
}

class _AddMedicationSheet extends StatelessWidget {
  const _AddMedicationSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add Medication',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.medication),
              label: const Text('Add as Active Treatment'),
              onPressed: () {
                Navigator.pop(context);
                // TODO: navigate to add treatment flow
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.inventory_2_outlined),
              label: const Text('Add to Cabinet'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.secondary,
                side: const BorderSide(color: AppColors.secondary, width: 1.5),
              ),
              onPressed: () {
                Navigator.pop(context);
                // TODO: navigate to add cabinet flow
              },
            ),
          ],
        ),
      ),
    );
  }
}
