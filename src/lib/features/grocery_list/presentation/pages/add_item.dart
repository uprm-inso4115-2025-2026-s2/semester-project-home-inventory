import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/config/injection_dependencies.dart';
import 'package:src/core/presentation/widgets/button.dart';
import 'package:src/core/presentation/widgets/snack_bar.dart';
import 'package:src/features/grocery_list/data/constants.dart';
import 'package:src/core/presentation/widgets/text_field.dart';
import 'package:src/core/presentation/widgets/top.dart';
import 'package:src/core/presentation/widgets/upload_image.dart';
import 'package:src/features/grocery_list/presentation/cubits/grocery_list_cubit.dart';
import 'package:src/features/grocery_list/presentation/widgets/category_grid_tile.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key, this.isCustom = false});
  final bool isCustom;

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController name = TextEditingController();
  File? itemImage;

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (widget.isCustom) {
      context.pop();
      return;
    }

    final added = sl<GroceryListCubit>().addCustomCollectionItem(
      name.text,
      imagePath: itemImage?.path,
    );

    if (!added) {
      MySnackBar().showFailure(
        context: context,
        message: 'Enter a unique item name to add to Custom.',
      );
      return;
    }

    MySnackBar().showSuccess(
      context: context,
      message: 'Saved to $customCollectionName collection.',
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final previewName = name.text.trim().isEmpty ? 'Item' : name.text.trim();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        children: [
          Top(
            color: Colors.black,
            leftButton: () => context.pop(),
            title: widget.isCustom ? "Edit Item" : "Add Item",
            iconColor: primary,
          ),
          SizedBox(height: 2.h),
          itemPreview(previewName),
          SizedBox(height: 2.h),
          BuildTextField(
            label: 'Name',
            controller: name,
            isSmall: false,
            hintText: 'Item Name',
            required: true,
            padding: false,
            isDarkMode: true,
            onChange: (_) => setState(() {}),
          ),
          SizedBox(height: 2.h),
          UploadImage(
            image: itemImage,
            chooseImg: () {},
            isPdf: false,
            color: Colors.black,
            title: 'Item Image',
            changeButtonColor: secondary,
          ),
        ],
      ),
      bottomNavigationBar: Button(
        buttonText: widget.isCustom ? "Edit Item" : "Add Item",
        onPressed: () => _onSubmit(context),
      ),
    );
  }

  Widget itemPreview(String title) {
    if (itemImage != null) {
      return Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                itemImage!,
                width: 45.w,
                height: 20.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }

    return Align(
      alignment: Alignment.center,
      child: IgnorePointer(
        child: SizedBox(
          width: 45.w,
          child: CategoryGridTile(name: title, onTap: () {}),
        ),
      ),
    );
  }
}
