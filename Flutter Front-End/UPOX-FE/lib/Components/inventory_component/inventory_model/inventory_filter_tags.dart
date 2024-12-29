import 'package:flutter/material.dart';

class InventoryFilterTags extends StatefulWidget {
  final String tagName;
  final String? tagImage;
  final double? initialHeight;
  final double? initialWidth;
  final VoidCallback onPressed;
  final Color? initialBackgroundColor;
  final Color? initialTextColor;

  const InventoryFilterTags({
    super.key,
    required this.tagName,
    this.tagImage,
    this.initialHeight,
    this.initialWidth,
    required this.onPressed,
    this.initialBackgroundColor = Colors.white,
    this.initialTextColor = Colors.black,
  });

  @override
  _InventoryFilterTagsState createState() => _InventoryFilterTagsState();
}

class _InventoryFilterTagsState extends State<InventoryFilterTags> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: widget.initialHeight ?? screenHeight * 0.05,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          backgroundColor: widget.initialBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.tagName,
              style: TextStyle(
                fontFamily: "inter",
                fontWeight: FontWeight.w500,
                color: widget.initialTextColor,
                fontSize: 10,
              ),
            ),
            if (widget.tagImage != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Image.asset(
                  widget.tagImage!,
                  width: 20,
                  height: 20,
                  color: widget.initialTextColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
