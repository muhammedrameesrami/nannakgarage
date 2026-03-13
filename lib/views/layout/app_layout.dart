import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/color_palette.dart';
import '../../core/constants/app_constants.dart';
import '../../controllers/workflow_controller.dart';
import '../auth/login_screen.dart';
import '../main/main_screen.dart';

class AppLayout extends ConsumerWidget {
  final Widget child;
  final String currentRoute;
  final bool isWorkflowMode;
  final int? activeMainIndex;
  final ValueChanged<int>? onMainNavigationTap;
  final ValueChanged<String>? onSecondaryRouteTap;

  const AppLayout({
    super.key,
    required this.child,
    required this.currentRoute,
    this.isWorkflowMode = false,
    this.activeMainIndex,
    this.onMainNavigationTap,
    this.onSecondaryRouteTap,
  });

  void _handleLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Do you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'No',
              style: TextStyle(color: ColorPalette.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.statusError,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDesktop = MediaQuery.of(context).size.width > 850;

    return Scaffold(
      drawer: isDesktop
          ? null
          : Drawer(child: _buildSidebarContent(context, ref)),
      body: Row(
        children: [
          // Desktop Sidebar
          if (isDesktop)
            Container(
              width: 260,
              decoration: BoxDecoration(
                color: ColorPalette.sidebarColor,
                border: Border(
                  right: BorderSide(
                    color: ColorPalette.borderColor.withValues(alpha: 0.5),
                  ),
                ),
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
                    border: Border(
                      bottom: BorderSide(color: ColorPalette.borderColor),
                    ),
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
                        icon: Icon(
                          Icons.notifications_none,
                          color: ColorPalette.textSecondary,
                        ),
                        onPressed: () => _showNotificationsDialog(context),
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
                            vertical: 12,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
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

  void _showNotificationsDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Notifications',
      barrierColor: Colors.black26,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurveTween(curve: Curves.easeOutCubic).animate(animation);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0), // Slide from the right
            end: Offset.zero,
          ).animate(curve),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return const _NotificationsDialogContent();
      },
    );
  }

  void _showProfileDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Profile',
      barrierColor: Colors.black26,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurveTween(curve: Curves.easeOutBack).animate(animation);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -0.3),
            end: Offset.zero,
          ).animate(curve),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return const _ProfileDialogContent();
      },
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorPalette.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.directions_car,
                  color: ColorPalette.primaryColor,
                  size: 32,
                ),
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
        // Bottom Sidebar Item - Profile
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            onTap: () => _showProfileDialog(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorPalette.hoverColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: ColorPalette.primaryColor,
                    radius: 16,
                    child: const Icon(
                      Icons.person,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Admin User',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Workshop Admin',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildMainNavigation(BuildContext context, WidgetRef ref) {
    return AppConstants.mainNavigationItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isActive = activeMainIndex != null
          ? activeMainIndex == index
          : currentRoute.startsWith(item['route']);
      IconData iconData;
      switch (item['icon']) {
        case 'dashboard':
          iconData = Icons.dashboard_rounded;
          break;
        case 'bookings':
          iconData = Icons.receipt_long_rounded;
          break;
        case 'reports':
          iconData = Icons.analytics_rounded;
          break;
        case 'settings':
          iconData = Icons.settings_suggest_rounded;
          break;
        default:
          iconData = Icons.circle_outlined;
      }

      if (item.containsKey('children')) {
        return _buildNavGroup(
          context: context,
          title: item['title'],
          icon: iconData,
          isActive: isActive,
          children: item['children'] as List<dynamic>,
        );
      }

      return _buildNavItem(
        title: item['title'],
        icon: iconData,
        isActive: isActive,
        onTap: () {
          if (onMainNavigationTap != null) {
            onMainNavigationTap!(index);
            return;
          }
          if (!isActive) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(initialIndex: index),
              ),
              (route) => false,
            );
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

  Widget _buildNavItem({
    required String title,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isActive
                ? ColorPalette.primaryColor.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive
                    ? ColorPalette.primaryColor
                    : ColorPalette.textSecondary,
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: isActive
                      ? ColorPalette.primaryColor
                      : ColorPalette.textSecondary,
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

  Widget _buildNavGroup({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isActive,
    required List<dynamic> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isActive,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          iconColor: ColorPalette.primaryColor,
          collapsedIconColor: ColorPalette.textSecondary,
          title: Row(
            children: [
              Icon(
                icon,
                color: isActive
                    ? ColorPalette.primaryColor
                    : ColorPalette.textSecondary,
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: isActive
                      ? ColorPalette.primaryColor
                      : ColorPalette.textSecondary,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          children: children.map((child) {
            final childIsActive = currentRoute == child['route'];
            return InkWell(
              onTap: () {
                if (!childIsActive) {
                  if (onSecondaryRouteTap != null) {
                    onSecondaryRouteTap!(child['route'] as String);
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                width: double.infinity,
                color: childIsActive
                    ? ColorPalette.primaryColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: childIsActive
                            ? ColorPalette.primaryColor
                            : Colors.grey.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      child['title'],
                      style: TextStyle(
                        color: childIsActive
                            ? ColorPalette.primaryColor
                            : ColorPalette.textSecondary,
                        fontWeight: childIsActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ProfileDialogContent extends StatefulWidget {
  const _ProfileDialogContent();

  @override
  State<_ProfileDialogContent> createState() => _ProfileDialogContentState();
}

class _ProfileDialogContentState extends State<_ProfileDialogContent> {
  final _nameController = TextEditingController(text: 'Admin User');
  final _roleController = TextEditingController(text: 'Workshop Admin');
  final _emailController = TextEditingController(
    text: 'admin@nannakgarage.com',
  );
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  bool _isEditing = false;
  Uint8List? _avatarBytes;

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        if (!mounted) return;
        setState(() {
          _avatarBytes = bytes;
        });
      }
    } catch (e) {
      debugPrint('Error picking avatar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 80, right: 24),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 340,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8),
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                      color: ColorPalette.textSecondary,
                    ),
                  ),
                ),
                // Avatar
                InkWell(
                  onTap: _pickAvatar,
                  borderRadius: BorderRadius.circular(40),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: ColorPalette.primaryColor,
                        backgroundImage: _avatarBytes != null
                            ? MemoryImage(_avatarBytes!)
                            : null,
                        child: _avatarBytes == null
                            ? const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: ColorPalette.secondaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildField(
                        'Name',
                        _nameController,
                        Icons.person_outline,
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        'Role',
                        _roleController,
                        Icons.badge_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        'Email',
                        _emailController,
                        Icons.email_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        'Phone',
                        _phoneController,
                        Icons.phone_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Edit / Save button
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 20,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        _isEditing ? Icons.save : Icons.edit,
                        size: 18,
                      ),
                      label: Text(_isEditing ? 'Save' : 'Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isEditing = !_isEditing;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      readOnly: !_isEditing,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: ColorPalette.textSecondary),
        labelStyle: const TextStyle(
          fontSize: 13,
          color: ColorPalette.textSecondary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: ColorPalette.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: ColorPalette.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: ColorPalette.primaryColor,
            width: 1.5,
          ),
        ),
        filled: !_isEditing,
        fillColor: ColorPalette.backgroundColor,
      ),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: ColorPalette.textPrimary,
      ),
    );
  }
}

class _NotificationsDialogContent extends StatelessWidget {
  const _NotificationsDialogContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 320,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(-5, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: ColorPalette.borderColor),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                      color: ColorPalette.textSecondary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              // List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: 5,
                  separatorBuilder: (context, index) =>
                      Divider(color: ColorPalette.borderColor, height: 1),
                  itemBuilder: (context, index) {
                    final isNew = index < 2;
                    return Material(
                      color: isNew
                          ? ColorPalette.primaryColor.withOpacity(0.05)
                          : Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ColorPalette.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.build_circle_outlined,
                                  color: ColorPalette.primaryColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Service Completed',
                                      style: TextStyle(
                                        fontWeight: isNew
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        fontSize: 14,
                                        color: ColorPalette.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'KL-01-AB-1234 service has been completed and is ready for billing.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: ColorPalette.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      '10 mins ago',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isNew)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: ColorPalette.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Footer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: ColorPalette.borderColor),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Mark all as read'),
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
