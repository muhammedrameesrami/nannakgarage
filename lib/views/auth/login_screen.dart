import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/theme/color_palette.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/responsive.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_textfield.dart';
import '../../controllers/auth_controller.dart';
import '../dashboard/dashboard_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: 'admin@nannak.com');
  final _passCtrl = TextEditingController(text: 'password');
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: ColorPalette.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            /// Desktop/Wide Layout: Split Screen
            return Row(
              children: [
                // Left Side: Image
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AssetConstants.loginBg),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                      padding: EdgeInsets.all(context.w(60)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.directions_car,
                                color: Colors.white,
                                size: context.sp(64),
                              ),
                              SizedBox(width: context.w(16)),
                              Text(
                                AppConstants.appName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: context.sp(48),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Right Side: Login Form
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(context.w(60)),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: _buildLoginForm(authState),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Mobile/Tablet Layout: Stack with image at top
            return Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Top Image for Mobile
                    Container(
                      height: context.h(300),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AssetConstants.loginBg),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.4),
                            ],
                          ),
                        ),
                        padding: EdgeInsets.all(context.w(24)),
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          children: [
                            Icon(
                              Icons.directions_car,
                              color: Colors.white,
                              size: context.sp(32),
                            ),
                            SizedBox(width: context.w(8)),
                            Text(
                              AppConstants.appName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: context.sp(24),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(context.w(24)),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: _buildLoginForm(authState),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLoginForm(AuthState authState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: context.sp(32),
              fontWeight: FontWeight.bold,
              color: ColorPalette.textPrimary,
            ),
          ),
          SizedBox(height: context.h(8)),
          Text(
            'Please enter your credentials to access your dashboard.',
            style: TextStyle(
              color: ColorPalette.textSecondary,
              fontSize: context.sp(15),
            ),
          ),
          SizedBox(height: context.h(40)),
          if (authState.error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorPalette.statusError.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: ColorPalette.statusError,
                    size: context.sp(20),
                  ),
                  SizedBox(width: context.w(12)),
                  Expanded(
                    child: Text(
                      authState.error!,
                      style: TextStyle(
                        color: ColorPalette.statusError,
                        fontSize: context.sp(13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.h(16)),
          ],
          AppTextField(
            label: 'Email Address',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
            prefixIcon: const Icon(Icons.email_outlined),
          ),
          SizedBox(height: context.h(20)),
          AppTextField(
            label: 'Password',
            controller: _passCtrl,
            obscureText: _obscure,
            validator: Validators.password,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: ColorPalette.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: context.sp(14),
                ),
              ),
            ),
          ),
          SizedBox(height: context.h(24)),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: 'Login',
              isLoading: authState.isLoading,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
      final success = await ref
          .read(authControllerProvider.notifier)
          .login(_emailCtrl.text, _passCtrl.text);
      if (success && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (route) => false,
        );
      }
    }
              },
            ),
          ),
          SizedBox(height: context.h(24)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account?',
                style: TextStyle(
                  color: ColorPalette.textSecondary,
                  fontSize: context.sp(14),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Contact Admin',
                  style: TextStyle(
                    color: ColorPalette.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: context.sp(14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
