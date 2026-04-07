import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/config/theme.dart';
import 'package:src/features/auth/presentation/routes.dart';
import 'package:src/features/auth/presentation/widgets/auth_primary_button.dart';

class AuthLandingPage extends StatelessWidget {
  const AuthLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/images/homeinventorylogo.png',
                  width: 74,
                  height: 74,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Take Control of\nYour Space',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Home Inventory',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 40),
              AuthPrimaryButton(
                label: 'Sign In',
                onPressed: () {
                  context.push(AuthRoutes.signInPath);
                },
              ),
              const SizedBox(height: 30),
              Text(
                'Don\'t have an account?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              AuthPrimaryButton(
                label: 'Sign Up',
                onPressed: () {
                  context.push(AuthRoutes.signUpPath);
                },
              ),
              const SizedBox(height: 10),
              AuthPrimaryButton(
                label: 'Continue as Guest',
                onPressed: () {
                  context.go('/home');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
