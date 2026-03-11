import 'package:flutter/material.dart';
import '../views/auth/login_screen.dart';
import '../views/home/home_screen.dart';
import '../views/gate_entry/gate_entry_screen.dart';
import '../views/job_card/job_card_screen.dart';
import '../views/estimation/estimation_screen.dart';
import '../views/service_update/service_update_screen.dart';
import '../views/quality_check/quality_check_screen.dart';
import '../views/billing/billing_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String gateEntry = '/gate-entry';
  static const String jobCard = '/job-card';
  static const String estimation = '/estimation';
  static const String serviceUpdate = '/service-update';
  static const String qualityCheck = '/quality-check';
  static const String billing = '/billing';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
    gateEntry: (context) => const GateEntryScreen(),
    jobCard: (context) => const JobCardScreen(),
    estimation: (context) => const EstimationScreen(),
    serviceUpdate: (context) => const ServiceUpdateScreen(),
    qualityCheck: (context) => const QualityCheckScreen(),
    billing: (context) => const BillingScreen(),
  };
}
