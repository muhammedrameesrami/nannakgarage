class AppConstants {
  static const String appName = 'Nannak Garage';

  // Routes
  static const String routeLogin = '/login';
  static const String routeDashboard = '/dashboard';
  static const String routeBookings = '/bookings';
  static const String routeReports = '/reports';
  static const String routeSettings = '/settings';
  static const String routeWorkflow = '/workflow';

  // Booking Status Values
  static const String statusGateEntry = 'Gate Entry';
  static const String statusJobCard = 'Job Card';
  static const String statusEstimation = 'Estimation';
  static const String statusService = 'Service';
  static const String statusQualityCheck = 'Quality Check';
  static const String statusBilling = 'Billing';

  // Navigation Items
  static const List<Map<String, dynamic>> mainNavigationItems = [
    {'title': 'Dashboard', 'route': routeDashboard, 'icon': 'dashboard'},
    {'title': 'Bookings', 'route': routeBookings, 'icon': 'bookings'},
    {'title': 'Reports', 'route': routeReports, 'icon': 'reports'},
    {'title': 'Settings', 'route': routeSettings, 'icon': 'settings'},
  ];

  static const List<String> workflowSteps = [
    'Gate Entry',
    'Job Card',
    'Estimation',
    'Service',
    'Quality',
    'Billing',
  ];
}
