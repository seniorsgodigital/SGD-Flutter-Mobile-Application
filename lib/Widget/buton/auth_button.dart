import 'package:flutter/material.dart';
class AuthButton extends StatelessWidget {
 final String title;
 final VoidCallback onPressed;
  const AuthButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return        GestureDetector(
    onTap: onPressed,
      child: Container(
        width: 250,
        height: 47,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFF2456D8), // Use the specified background color
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white, // Text color
              fontSize: 16.0, // Text font size
            ),
          ),
        ),
      ),
    );
  }
}
