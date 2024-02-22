import 'package:flutter/material.dart';


class MyText extends StatelessWidget {
  String text;
  Color? textcolor;
  double? fontSize;
  FontWeight? fontWeight;
  TextAlign? textAlign;

  MyText(
      {Key? key,
      required this.text,
      this.textcolor,
      this.fontSize,
      this.fontWeight,
      this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      style: TextStyle(
          color: textcolor ?? Colors.white,
          fontSize: fontSize,
          fontWeight: fontWeight,
          overflow: TextOverflow.ellipsis,
          decoration: TextDecoration.none),
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}
