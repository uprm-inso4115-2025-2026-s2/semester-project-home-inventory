import 'package:go_router/go_router.dart';
import 'package:src/features/auth/presentation/pages/account_recovery_page.dart';
import 'package:src/features/auth/presentation/pages/auth_landing_page.dart';
import 'package:src/features/auth/presentation/pages/sign_in_page.dart';
import 'package:src/features/auth/presentation/pages/sign_up_page.dart';

abstract final class AuthRoutes {
  static const String landingName = 'auth_landing';
  static const String signInName = 'auth_sign_in';
  static const String signUpName = 'auth_sign_up';
  static const String recoveryName = 'auth_recovery';

  static const String landingPath = '/auth';
  static const String signInSegment = 'sign-in';
  static const String signUpSegment = 'sign-up';
  static const String recoverySegment = 'recovery';

  static const String signInPath = '$landingPath/$signInSegment';
  static const String signUpPath = '$landingPath/$signUpSegment';
  static const String recoveryPath = '$landingPath/$recoverySegment';
}

final GoRoute authRoutes = GoRoute(
  path: AuthRoutes.landingPath,
  name: AuthRoutes.landingName,
  builder: (context, state) => const AuthLandingPage(),
  routes: [
    GoRoute(path: AuthRoutes.signInSegment, name: AuthRoutes.signInName, builder: (context, state) => const SignInPage(),),
    GoRoute(path: AuthRoutes.signUpSegment, name: AuthRoutes.signUpName, builder: (context, state) => const SignUpPage(),),
    GoRoute(
      path: AuthRoutes.recoverySegment,
      name: AuthRoutes.recoveryName,
      builder: (context, state) => const AccountRecoveryPage(),
    ),
  ],
);
