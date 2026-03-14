// This directory hold the pages and widgets, essentially all the parts of the application concerning the presentation layer
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          style: Theme.of(context).textTheme.displayMedium, // Example of using the custom typography defined in the theme
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "This is the main page of the app",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            CupertinoButton(
              child: Container(
                alignment: Alignment.center,
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme.primaryColor, // Example of using the custom color defined in the theme
                ),
                child: Text(
                  "Go to TODOs page",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppTheme.surfaceColor),// Example of using the custom typography and color defined in the theme
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
}
