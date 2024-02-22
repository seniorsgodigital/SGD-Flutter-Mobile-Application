import 'package:flutter/material.dart';
import 'package:seniors_go_digital/AppStrings/asset_images.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(150), // Set the width and height
      child: Container(
        height: 150, // Set the height to 187px
        child: Center(
          child: Image.asset(
            AssetImages.logoMain,
            height: 110, // Set the height of the centered image
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(150); // Set the preferred size
}
