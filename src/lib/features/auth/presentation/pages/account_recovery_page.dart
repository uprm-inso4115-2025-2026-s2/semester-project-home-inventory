import 'package:flutter/material.dart';
import 'package:src/config/theme.dart';
import 'package:src/features/auth/presentation/widgets/auth_form_field.dart';
import 'package:src/features/auth/presentation/widgets/auth_primary_button.dart';

class AccountRecoveryPage extends StatefulWidget {
  const AccountRecoveryPage({super.key});

  @override
  State<AccountRecoveryPage> createState() => _AccountRecoveryPageState();
}

class _AccountRecoveryPageState extends State<AccountRecoveryPage> {
  final TextEditingController _recoveryController = TextEditingController();

  void _submit() {
    if (_recoveryController.text.trim().isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recovery instructions sent.')),
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _recoveryController.dispose();
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
                  'Account\nRecovery',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Enter a phone number or\nemail address',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              AuthFormField(
                hintText: 'Enter phone number/email address',
                controller: _recoveryController,
              ),
              const SizedBox(height: 28),
              AuthPrimaryButton(label: 'Next', onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
