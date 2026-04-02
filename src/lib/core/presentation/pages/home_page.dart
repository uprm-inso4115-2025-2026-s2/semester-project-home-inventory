// This directory hold the pages and widgets, essentially all the parts of the application concerning the presentation layer
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/config/router.dart';
import 'package:src/config/theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home Page",
          style: Theme.of(context)
              .textTheme
              .displayMedium,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(context, "Grocery List", () {
              AppRouter.goTo(context, "grocery_home");
            }),

            buildButton(context, "Alerts", () {
              AppRouter.goTo(context, "alerts_home");
            }),
            
            Text("This is the main page of the app"),
            SizedBox(height: 20),
            CupertinoButton(
              child: Container(
                alignment: Alignment.center,
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF8B9D7F),
                ),
                child: Text(
                  "Inventory Stock Report",
                  style: TextStyle(color: CupertinoColors.white),
                ),
              ),
              onPressed: () {
                context.go('/home/inventory-stock-summary');
              },
            ),
            SizedBox(height: 10),
            CupertinoButton(
              child: Container(
                alignment: Alignment.center,
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme
                      .primaryColor, // Example of using the custom color defined in the theme
                ),
                child: Text(
                  "Go to TODOs page",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.surfaceColor,
                  ), // Example of using the custom typography and color defined in the theme
                ),
              ),
              onPressed: () {
                AppRouter.goTo(context, 'todos');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, VoidCallback action) {
    return CupertinoButton(
      child: Container(
        alignment: Alignment.center,
        width: 40.w,
        height: 5.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blueGrey,
        ),
        child: Text(text, style: TextStyle(color: CupertinoColors.white)),
      ),
      onPressed: () {
        action();
      },
    );
  }
}
