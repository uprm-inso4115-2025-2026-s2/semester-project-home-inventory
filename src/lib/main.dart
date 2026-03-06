import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:src/config/injection_dependencies.dart';
import 'package:src/config/router.dart';
import 'package:src/config/theme.dart';

Future<void> main() async {
  await initializeDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screen) {
        return MaterialApp.router(
          theme: AppTheme.lightTheme,
          title: 'Home Inventory',
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
