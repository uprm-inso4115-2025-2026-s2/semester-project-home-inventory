import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/config/injection_dependencies.dart';
import 'package:src/config/theme.dart';
import 'package:src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:src/features/auth/presentation/cubit/auth_state.dart';
import 'package:src/features/auth/presentation/routes.dart';
import 'package:src/features/auth/presentation/widgets/auth_form_field.dart';
import 'package:src/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:src/features/profile_screens/presentation/routes.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _invalidInfo = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  bool _validEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  void _submit() {
    if (_isSubmitting) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final valid = _validEmail(email) && password.isNotEmpty;

    if (!valid) {
      setState(() {
        _invalidInfo = true;
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _invalidInfo = false;
      _errorMessage = null;
      _isSubmitting = true;
    });

    sl<AuthCubit>().signIn(email: email, password: password);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      bloc: sl<AuthCubit>(),
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() => _isSubmitting = true);
          return;
        }

        if (state is AuthAuthenticated) {
          setState(() => _isSubmitting = false);
          context.go(ProfileRoutes.menuPath);
          return;
        }

        if (state is AuthFailure) {
          setState(() {
            _isSubmitting = false;
            _invalidInfo = true;
            _errorMessage = state.errorMessage;
          });
          return;
        }

        if (state is AuthUnauthenticated) {
          setState(() => _isSubmitting = false);
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
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
                      _errorMessage ?? 'Invalid Information',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.redAccent,
                          ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      _errorMessage == null
                          ? 'make sure email address is valid\nand password is valid.'
                          : 'Please try again.',
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
                    onPressed: () => context.push(AuthRoutes.recoveryPath),
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 22),
                AuthPrimaryButton(
                  label: _isSubmitting ? 'Signing in...' : 'Next',
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
