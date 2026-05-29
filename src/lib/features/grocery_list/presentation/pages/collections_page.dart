import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:src/config/router.dart';
import 'package:src/core/presentation/widgets/search_bar.dart';
import 'package:src/features/grocery_list/data/constants.dart';
import 'package:src/features/grocery_list/presentation/cubits/grocery_list_cubit.dart';
import 'package:src/features/grocery_list/presentation/cubits/grocery_list_state.dart';

/// Content shown when "Collections" tab is selected on the home screen.
class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  List<String> _visibleCollections(GroceryListState state) {
    if (!state.hasCustomCollection) {
      return List<String>.from(collectionNames);
    }
    return [customCollectionName, ...collectionNames];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroceryListCubit, GroceryListState>(
      builder: (context, state) {
        final collections = _visibleCollections(state);

        return Column(
          children: [
            MySearchBar(),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: collections.length,
                itemBuilder: (context, index) => collectionCard(
                  context,
                  collections[index],
                  isCustomCollection(collections[index])
                      ? CupertinoIcons.star_fill
                      : CupertinoIcons.bag_fill,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget collectionCard(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        AppRouter.goTo(
          context,
          'categories/${Uri.encodeComponent(title)}',
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        child: Container(
          width: double.infinity,
          height: 15.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: primary,
          ),
          child: Row(
            children: [
              SizedBox(width: 6.w),
              Icon(icon, size: 36.sp, color: secondary),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: backgroundColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 4.w),
            ],
          ),
        ),
      ),
    );
  }
}
