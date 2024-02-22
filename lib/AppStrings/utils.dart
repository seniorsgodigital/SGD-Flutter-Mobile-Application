import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
class Utils{
  Color calculateTextColor(Color backgroundColor) {
    final double relativeLuminance =
        (0.299 * backgroundColor.red + 0.587 * backgroundColor.green + 0.114 * backgroundColor.blue) / 255;

    return relativeLuminance > 0.5 ? Colors.black : Colors.white;
  }
  static void showErrorMessage(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          message: message,
          duration: const Duration(seconds: 5),
          backgroundColor: Color(0xFFCC0000), // Error color: #CC0000
          leftBarIndicatorColor: Color(0xFFCC0000).withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          icon: const Icon(
            Icons.error_outline,
            color: Color(0xFF282EC7),
            size: 28.0,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          boxShadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
          animationDuration: const Duration(milliseconds: 350),
          margin: const EdgeInsets.all(10),
          dismissDirection: FlushbarDismissDirection.HORIZONTAL,
          forwardAnimationCurve: Curves.easeOut,
          reverseAnimationCurve: Curves.easeOut,
        )..show(context)

    );
  }

  static void showSuccessMessage(
      String message,BuildContext? context

      ) {
    showFlushbar(
      context: context!,
      flushbar: Flushbar(
        message: message,
        duration: const Duration(seconds: 5),
        backgroundColor:  Color(0xFF282EC7), // Success color
        leftBarIndicatorColor: Colors.green.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
        boxShadows:  [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
        animationDuration: const Duration(milliseconds: 800),
        margin: const EdgeInsets.all(10),
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        forwardAnimationCurve: Curves.easeOut,
        reverseAnimationCurve: Curves.easeOut,
        // Adding a custom button
      )..show(context),
    );
  }
}