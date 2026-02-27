import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:src/config/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://qieckuegdgcefdkqnsav.supabase.co',
    anonKey: 'sb_publishable_1w1-TrfGRbG2nvDv-UUMVQ_EE2lj-HB',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screen) {
        return MaterialApp.router(
          title: 'Home Inventory',
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
