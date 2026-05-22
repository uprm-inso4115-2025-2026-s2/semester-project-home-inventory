import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/config/injection_dependencies.dart';
import 'package:src/config/router.dart';
import 'package:src/core/presentation/widgets/search_bar.dart';
import 'package:src/core/presentation/widgets/snack_bar.dart';
import 'package:src/features/grocery_list/data/constants.dart';
import 'package:src/core/presentation/widgets/top.dart';
import 'package:src/features/grocery_list/domain/entities/custom_collection_item.dart';
import 'package:src/features/grocery_list/presentation/cubits/grocery_list_cubit.dart';
import 'package:src/features/grocery_list/presentation/cubits/grocery_list_state.dart';
import 'package:src/features/grocery_list/presentation/widgets/category_grid_tile.dart';

class Categories extends StatelessWidget {
  const Categories({
    super.key,
    required this.collectionName,
  });

  final String collectionName;

  bool get _isCustom => isCustomCollection(collectionName);

  List<String> _builtInItems() => itemsForCollection(collectionName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: _isCustom
          ? BlocBuilder<GroceryListCubit, GroceryListState>(
              builder: (context, state) => _buildBody(
                context,
                customItems: state.customCollectionItems,
              ),
            )
          : _buildBody(context, builtInItems: _builtInItems()),
    );
  }

  Widget _buildBody(
    BuildContext context, {
    List<String> builtInItems = const [],
    List<CustomCollectionItem> customItems = const [],
  }) {
    final hasItems = _isCustom ? customItems.isNotEmpty : builtInItems.isNotEmpty;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      children: [
        Top(
          color: Colors.black,
          leftButton: () => context.pop(),
          title: collectionName,
          iconColor: primary,
          widget: _isCustom ? customButton(context) : null,
        ),
        MySearchBar(),
        SizedBox(height: 2.h),
        if (!hasItems)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Center(
              child: Text(
                _isCustom
                    ? 'No custom items yet.\nTap + on the Grocery screen to add one.'
                    : 'No items in this collection yet.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp, color: Colors.grey[700]),
              ),
            ),
          )
        else if (_isCustom)
          _customItemGrid(context, customItems)
        else
          _builtInItemGrid(context, builtInItems),
      ],
    );
  }

  Widget customButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRouter.goTo(context, "custom_items");
      },
      child: Text(
        "Edit",
        style: TextStyle(
          fontSize: 18.sp,
          color: primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _builtInItemGrid(BuildContext context, List<String> items) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 1.5.h,
        crossAxisSpacing: 3.w,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) {
        final name = items[index];
        return CategoryGridTile(
          name: name,
          onTap: () => onItemTap(context, name),
        );
      },
    );
  }

  Widget _customItemGrid(
    BuildContext context,
    List<CustomCollectionItem> items,
  ) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 1.5.h,
        crossAxisSpacing: 3.w,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return CategoryGridTile(
          name: item.name,
          onTap: () => onItemTap(context, item.name),
        );
      },
    );
  }

  void onItemTap(BuildContext context, String name) {
    sl<GroceryListCubit>().addItem(name);
    MySnackBar().showSuccess(
      context: context,
      message: "Added $name to your grocery list",
    );
  }
}
