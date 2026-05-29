import 'package:flutter/material.dart';
import 'package:src/config/theme.dart';

const _kCardBg = Color(0xFFEDE8DC);
const _kRed = Color(0xFFC1440E);

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios,
                          color: AppTheme.primaryText, size: 20),
                    ),
                  ),
                  const Text(
                    'Help',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _kCardBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact information',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '• homeinven@gmail.com',
                      style: TextStyle(fontSize: 13, color: AppTheme.mutedText),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '• 787-333-8980',
                      style: TextStyle(fontSize: 13, color: AppTheme.mutedText),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _PrimaryButton(
                label: 'Log Out',
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 4),
              _PrimaryButton(
                label: 'Delete Account',
                color: _kRed,
                onTap: () {},
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.color = AppTheme.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: Text(label,
            style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
