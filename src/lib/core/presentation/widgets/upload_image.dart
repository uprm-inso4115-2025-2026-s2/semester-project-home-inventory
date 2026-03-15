import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

class UploadImage extends StatelessWidget {
  final String title;
  final Color color;
  final File? image;
  final Color changeButtonColor;
  final bool isPdf;
  final bool required;
  final Function() chooseImg;

  const UploadImage({
    super.key,
    required this.color,
    required this.title,
    required this.image,
    required this.chooseImg,
    required this.changeButtonColor,
    this.isPdf = false,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                textScaler: TextScaler.noScaling,
                style: TextStyle(color: color, fontSize: 18.sp),
              ),
              if (required)
                Text(
                  '*',
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(color: Colors.red, fontSize: 20.sp),
                ),
            ],
          ),
          SizedBox(height: 1.h),
          if (image != null) imageUploaded(context, image!),
          if (image == null) imageNull(context),
        ],
      ),
    );
  }

  Widget imageUploaded(BuildContext context, File image) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            if (!isPdf) {
              List<Widget> imgs = fileView([image]);
              SwipeImageGallery(context: context, children: imgs).show();
            }
          },
          child: Text(
            isPdf ? 'document.pdf' : "image.jpg",
            textScaler: TextScaler.noScaling,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        SizedBox(width: 4.w),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => chooseImg.call(),
          child: Text(
            "Cambiar",
            textScaler: TextScaler.noScaling,
            style: TextStyle(color: changeButtonColor),
          ),
        ),
      ],
    );
  }

  Widget imageNull(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => chooseImg.call(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: changeButtonColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          isPdf ? 'Documentos' : 'Galeria',
          textScaler: TextScaler.noScaling,
          style: TextStyle(color: color),
        ),
      ),
    );
  }

  List<Widget> fileView(List<File> imgs) {
    List<Widget> widgets = [];
    for (File file in imgs) {
      Widget value = SizedBox(child: Center(child: Image.file(file)));
      widgets.add(value);
    }
    return widgets;
  }

  ///Choose img example
  //void chooseImg(BuildContext context) async {
  //     sl<ProfileCubit>().setLoading(true);
  //     File? img = await Storage.chooseFromGallery(context);
  //     if (img != null) {
  //       setState(() => image = img);
  //     }
  //     sl<ProfileCubit>().setLoading(false);
  //   }
}
