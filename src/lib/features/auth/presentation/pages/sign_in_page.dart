import 'package:flutter/material.dart';
import 'package:src/config/theme.dart';
import 'package:src/features/auth/presentation/pages/account_recovery_page.dart';
import 'package:src/features/auth/presentation/widgets/auth_form_field.dart';
import 'package:src/features/auth/presentation/widgets/auth_primary_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _invalidInfo = false;

  bool _validEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  void _submit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final valid = _validEmail(email) && password.isNotEmpty;

    if (!valid) {
      setState(() => _invalidInfo = true);
      return;
    }

    setState(() => _invalidInfo = false);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new),
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 6),
              Center(
                child: Image.asset(
                  'assets/images/homeinventorylogo.png',
                  width: 74,
                  height: 74,
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Text(
                  'Welcome\nBack!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 26),
              if (_invalidInfo) ...[
                Center(
                  child: Text(
                    'Invalid Information',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.redAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'make sure email address is valid\nand password is valid.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                'Email Address',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              AuthFormField(
                hintText: 'Enter email address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                isInvalid: _invalidInfo,
              ),
              const SizedBox(height: 14),
              Text('Password', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              AuthFormField(
                hintText: 'Enter password',
                controller: _passwordController,
                obscureText: true,
                isInvalid: _invalidInfo,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const AccountRecoveryPage(),
                      ),
                    );
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),
              const SizedBox(height: 22),
              AuthPrimaryButton(label: 'Next', onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
