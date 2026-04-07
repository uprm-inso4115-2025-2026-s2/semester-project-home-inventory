import 'package:go_router/go_router.dart';
import 'package:src/features/auth/presentation/pages/account_recovery_page.dart';
import 'package:src/features/auth/presentation/pages/auth_landing_page.dart';
import 'package:src/features/auth/presentation/pages/sign_in_page.dart';
import 'package:src/features/auth/presentation/pages/sign_up_page.dart';

final GoRoute authRoutes = GoRoute(
  path: '/auth',
  builder: (context, state) => const AuthLandingPage(),
  routes: [
    GoRoute(path: 'sign-in', builder: (context, state) => const SignInPage()),
    GoRoute(path: 'sign-up', builder: (context, state) => const SignUpPage()),
    GoRoute(
      path: 'recovery',
      builder: (context, state) => const AccountRecoveryPage(),
    ),
  ],
);
