import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:src/core/presentation/routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/home",
    routes: <RouteBase>[
      mainRoutes
    ],
  );

  static void goTo(BuildContext context, String name) {
    context.go('${GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString()}/$name');
  }
}
