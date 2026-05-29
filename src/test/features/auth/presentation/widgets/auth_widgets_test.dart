import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:src/config/theme.dart';
import 'package:src/features/auth/presentation/widgets/auth_form_field.dart';
import 'package:src/features/auth/presentation/widgets/auth_primary_button.dart';

void main() {
  group('AuthPrimaryButton', () {
    testWidgets('displays its label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthPrimaryButton(label: 'Sign In', onPressed: () {}),
          ),
        ),
      );

      expect(find.text('Sign In'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthPrimaryButton(
              label: 'Create Account',
              onPressed: () => tapCount++,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(tapCount, 1);
    });
  });

  group('AuthFormField', () {
    testWidgets('uses invalid hint color when marked invalid', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthFormField(
              hintText: 'Email',
              controller: controller,
              isInvalid: true,
            ),
          ),
        ),
      );

      final field = tester.widget<TextField>(find.byType(TextField));

      expect(field.decoration?.hintText, 'Email');
      expect(field.decoration?.hintStyle?.color, AppTheme.redAccent);
    });

    testWidgets('passes text input settings to the TextField', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthFormField(
              hintText: 'Password',
              controller: controller,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
            ),
          ),
        ),
      );

      final field = tester.widget<TextField>(find.byType(TextField));

      expect(field.obscureText, isTrue);
      expect(field.keyboardType, TextInputType.visiblePassword);
      expect(field.controller, controller);
    });
  });
}
