// This directory hold the pages and widgets, essentially all the parts of the application concerning the presentation layer
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:src/config/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("This is the main page of the app"),
            CupertinoButton(
              child: Container(
                alignment: Alignment.center,
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Go to TODOs page",
                  style: TextStyle(color: CupertinoColors.black),
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
