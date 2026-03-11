import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../views/gate_entry/gate_entry_screen.dart';
import '../../views/job_card/job_card_screen.dart';
import '../../views/estimation/estimation_screen.dart';
import '../../views/service_update/service_update_screen.dart';
import '../../views/quality_check/quality_check_screen.dart';
import '../../views/billing/billing_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _entryController;

  final List<Map<String, dynamic>> _workflowItems = [
    {
      'title': 'Gate Entry',
      'image': 'assets/images/gate_entry.png',
      'screen': const GateEntryScreen(),
    },
    {
      'title': 'Job Card',
      'image': 'assets/images/job_card.png',
      'screen': const JobCardScreen(),
    },
    {
      'title': 'Estimation',
      'image': 'assets/images/estimation.png',
      'screen': const EstimationScreen(),
    },
    {
      'title': 'Service Update',
      'image': 'assets/images/service_update.png',
      'screen': const ServiceUpdateScreen(),
    },
    {
      'title': 'Quality Check',
      'image': 'assets/images/quality_check.png',
      'screen': const QualityCheckScreen(),
    },
    {
      'title': 'Billing',
      'image': 'assets/images/billing.png',
      'screen': const BillingScreen(),
    },
    {
      'title': 'Inventory',
      'image': 'assets/images/inventory.png',
      'screen': const Scaffold(body: Center(child: Text('Inventory Screen'))),
    },
    {
      'title': 'Customers',
      'image': 'assets/images/customer_crm.png',
      'screen': const Scaffold(body: Center(child: Text('Customer Database'))),
    },
    {
      'title': 'Reports',
      'image': 'assets/images/reports.png',
      'screen': const Scaffold(body: Center(child: Text('Reports Screen'))),
    },
    {
      'title': 'Settings',
      'image': 'assets/images/settings.png',
      'screen': const Scaffold(body: Center(child: Text('Settings Screen'))),
    },
  ];

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Stack(
        children: [
          // Background design elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withAlpha(15),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: _build3DGrid(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nannak Garage',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1D1F),
                ),
              ),
              Text(
                'Premium Workshop Management',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF6F767E),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF1A1D1F)),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
    );
  }

  Widget _build3DGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 800
            ? 4
            : (constraints.maxWidth > 600 ? 3 : 2);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 0.9,
          ),
          itemCount: _workflowItems.length,
          itemBuilder: (context, index) {
            return ServiceCard3D(
              item: _workflowItems[index],
              index: index,
              animation: _entryController,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _workflowItems[index]['screen'] as Widget,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class ServiceCard3D extends StatefulWidget {
  final Map<String, dynamic> item;
  final int index;
  final AnimationController animation;
  final VoidCallback onTap;

  const ServiceCard3D({
    super.key,
    required this.item,
    required this.index,
    required this.animation,
    required this.onTap,
  });

  @override
  State<ServiceCard3D> createState() => _ServiceCard3DState();
}

class _ServiceCard3DState extends State<ServiceCard3D> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final scaleAnimation = CurvedAnimation(
      parent: widget.animation,
      curve: Interval(
        (widget.index * 0.05).clamp(0.0, 1.0),
        (widget.index * 0.05 + 0.5).clamp(0.0, 1.0),
        curve: Curves.easeOutBack,
      ),
    );

    return ScaleTransition(
      scale: scaleAnimation,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            transform:
                Matrix4.translationValues(0.0, _isHovered ? -8.0 : 0.0, 0.0)
                  ..rotateX(_isHovered ? -0.05 : 0.0)
                  ..rotateY(_isHovered ? 0.05 : 0.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                // Deep 3D Shadow
                BoxShadow(
                  color: Colors.black.withAlpha(_isHovered ? 25 : 15),
                  blurRadius: _isHovered ? 30 : 20,
                  offset: Offset(0, _isHovered ? 20 : 10),
                  spreadRadius: _isHovered ? 2 : 0,
                ),
                // Subtle side shadow for 3D depth
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 1,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        widget.item['image'],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.item['title'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1D1F),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
