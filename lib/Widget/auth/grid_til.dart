import 'package:flutter/material.dart';

class CurvedGridTile extends StatelessWidget {
  final String title;
  final String imagePath;
  final Function() onPressed; // Custom onPressed function

  CurvedGridTile({required this.title, required this.imagePath, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Use the custom onPressed function when the tile is tapped
      child: Card(
        color: Colors.transparent,
        elevation: 4, // Adjust the elevation as needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // Adjust the curve radius
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black26, // Adjust the background color
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.0)),
              ),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white, // Adjust the text color
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
