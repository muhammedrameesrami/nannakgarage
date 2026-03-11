import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/auth_controller.dart';
import '../../common/widgets/common_button.dart';
import '../../common/widgets/common_textfield.dart';
import '../../core/theme/color_palette.dart';
import '../home/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref
          .read(authControllerProvider.notifier)
          .login(_emailController.text, _passwordController.text);
      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.car_repair,
                        size: 64,
                        color: ColorPalette.primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nannak Garage',
                        style: Theme.of(
                          context,
                        ).textTheme.displayLarge?.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Service Management System',
                        style: TextStyle(color: ColorPalette.textSecondary),
                      ),
                      const SizedBox(height: 32),
                      if (authState.error != null) ...[
                        Text(
                          authState.error!,
                          style: const TextStyle(
                            color: ColorPalette.errorColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      CommonTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required' : null,
                      ),
                      CommonTextField(
                        controller: _passwordController,
                        label: 'Password',
                        isPassword: true,
                        validator: (value) => value == null || value.length < 6
                            ? 'Min 6 chars'
                            : null,
                      ),
                      const SizedBox(height: 24),
                      CommonButton(
                        text: 'Login',
                        isLoading: authState.isLoading,
                        onPressed: _login,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
