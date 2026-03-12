import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/color_palette.dart';
import '../../core/constants/app_constants.dart';
import '../../controllers/workflow_controller.dart';

class AppLayout extends ConsumerWidget {
  final Widget child;
  final String currentRoute;
  final bool isWorkflowMode;

  const AppLayout({
    Key? key,
    required this.child,
    required this.currentRoute,
    this.isWorkflowMode = false,
  }) : super(key: key);

  void _handleLogout(BuildContext context, WidgetRef ref) {
    context.go(AppConstants.routeLogin);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDesktop = MediaQuery.of(context).size.width > 1100;

    return Scaffold(
      drawer: isDesktop ? null : Drawer(child: _buildSidebarContent(context, ref)),
      body: Row(
        children: [
          // Desktop Sidebar
          if (isDesktop)
            Container(
              width: 260,
              decoration: BoxDecoration(
                color: ColorPalette.sidebarColor,
                border: Border(right: BorderSide(color: ColorPalette.borderColor.withOpacity(0.5))),
              ),
              child: _buildSidebarContent(context, ref),
            ),
          
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Header
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: ColorPalette.borderColor)),
                  ),
                  child: Row(
                    children: [
                      if (!isDesktop)
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                      if (!isDesktop) const SizedBox(width: 8),
                      // Breadcrumbs or Title could go here
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.notifications_none, color: ColorPalette.textSecondary),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 16),
                      // Profile/Settings
                      _buildHeaderAction(
                        icon: Icons.settings_outlined,
                        label: isDesktop ? 'Settings' : null,
                        onPressed: () => context.go(AppConstants.routeSettings),
                      ),
                      const SizedBox(width: 16),
                      // Logout
                      ElevatedButton.icon(
                        icon: const Icon(Icons.logout, size: 18),
                        label: Text(isDesktop ? 'Logout' : ''),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.statusError,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 16 : 12, 
                            vertical: 12
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => _handleLogout(context, ref),
                      ),
                    ],
                  ),
                ),
                // Page Content
                Expanded(
                  child: Container(
                    color: ColorPalette.backgroundColor,
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderAction({required IconData icon, String? label, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: ColorPalette.textSecondary, size: 22),
            if (label != null) ...[
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: ColorPalette.textSecondary)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarContent(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo area
        Container(
          height: 150,
          padding: const EdgeInsets.all(24.0),
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorPalette.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.directions_car, color: ColorPalette.primaryColor, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.textPrimary,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        const Divider(indent: 20, endIndent: 20),
        const SizedBox(height: 8),
        // Navigation Items
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: isWorkflowMode 
                ? _buildWorkflowNavigation(context, ref) 
                : _buildMainNavigation(context, ref),
          ),
        ),
        // Bottom Sidebar Item
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorPalette.hoverColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: ColorPalette.primaryColor,
                  radius: 16,
                  child: const Icon(Icons.person, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Admin User', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('Workshop Admin', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildMainNavigation(BuildContext context, WidgetRef ref) {
    return AppConstants.mainNavigationItems.map((item) {
      final isActive = currentRoute.startsWith(item['route']);
      IconData iconData;
      switch (item['icon']) {
        case 'dashboard': iconData = Icons.dashboard_rounded; break;
        case 'bookings': iconData = Icons.receipt_long_rounded; break;
        case 'reports': iconData = Icons.analytics_rounded; break;
        case 'settings': iconData = Icons.settings_suggest_rounded; break;
        default: iconData = Icons.circle_outlined;
      }

      return _buildNavItem(
        title: item['title'],
        icon: iconData,
        isActive: isActive,
        onTap: () {
          if (!isActive) {
            context.go(item['route']);
          }
        },
      );
    }).toList();
  }

  List<Widget> _buildWorkflowNavigation(BuildContext context, WidgetRef ref) {
    final workflowState = ref.watch(workflowControllerProvider);
    
    return AppConstants.workflowSteps.map((step) {
      final isActive = workflowState.currentStep == step;
      
      return _buildNavItem(
        title: step,
        icon: Icons.check_circle_rounded,
        isActive: isActive,
        onTap: () {
          ref.read(workflowControllerProvider.notifier).setStep(step);
        },
      );
    }).toList();
  }

  Widget _buildNavItem({required String title, required IconData icon, required bool isActive, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? ColorPalette.primaryColor.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? ColorPalette.primaryColor : ColorPalette.textSecondary,
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: isActive ? ColorPalette.primaryColor : ColorPalette.textSecondary,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              if (isActive) ...[
                const Spacer(),
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: ColorPalette.primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
