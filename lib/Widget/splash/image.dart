import 'package:flutter/material.dart';
class SplashImage extends StatelessWidget {
  final String image;
  final double width;
  final double height;
  const SplashImage({super.key,
    required this.image, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return                     Image.asset(
      image,
      width: width,
      height: height,
    );
  }
}
