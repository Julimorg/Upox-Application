import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  final String? categoryBanner;
  final String? categoryStatus;
  final VoidCallback onPressed;

  const Category({
    super.key,
    this.categoryBanner,
    this.categoryStatus,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (categoryBanner != null)
            Image.asset(
              categoryBanner!,
              height: screenHeight * 0.1,
              width: screenWidth * 0.15,
            ),
          if (categoryStatus != null)
            Positioned(
              bottom: 50,
              child: Image.asset(
                categoryStatus!,
                width: screenWidth * 0.05,
                height: screenHeight * 0.05,
              ),
            ),
        ],
      ),
    );
  }
}
