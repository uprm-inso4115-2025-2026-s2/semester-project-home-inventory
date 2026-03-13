import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:src/config/router.dart';
import 'package:src/features/grocery_list/data/constants.dart';
import 'package:src/features/grocery_list/presentation/pages/collections_page.dart';
import 'package:src/features/grocery_list/presentation/pages/my_grocery_list_page.dart';
import 'package:src/features/grocery_list/presentation/widgets/top.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            Top(
              color: Colors.black,
              leftButton: () {},
              title: "Grocery",
              iconColor: primary,
              leftButtonText: "History",
              addButton: true,
              addFunction: () => AppRouter.goTo(context, 'add_item'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 1.w),
                pageButton("Collections", 0),
                pageButton("My Grocery List", 1),
                SizedBox(width: 1.w),
              ],
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() => currentPage = index);
                },
                children: const [CollectionsPage(), MyGroceryListPage()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pageButton(String text, int pageIndex) {
    final isSelected = currentPage == pageIndex;
    return GestureDetector(
      onTap: () {
        pageController.animateToPage(
          pageIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: isSelected ? primary : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10000),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
