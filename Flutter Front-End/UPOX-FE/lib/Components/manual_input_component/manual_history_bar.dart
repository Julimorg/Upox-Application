import 'package:flutter/material.dart';

class ManualHistoryBar extends StatelessWidget {
  final Gradient gradient;
  final String text;
  final VoidCallback? onTextPressed;
  final VoidCallback? onClosePressed;

  const ManualHistoryBar({
    super.key,
    required this.gradient,
    required this.text,
    this.onTextPressed,
    this.onClosePressed,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.01),
      width: width * 0.95,
      height: height * 0.05,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: gradient,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                const SizedBox(width: 10),
                // Dot Icon
                const Icon(
                  Icons.circle,
                  size: 8,
                  color: Color(0xff18A0FB),
                ),
                const SizedBox(width: 8),
                // Text Button
                TextButton(
                  onPressed: onTextPressed,
                  style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory, // Bỏ hoạt ảnh splash
                    overlayColor: Colors.transparent,
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontFamily: "inter",
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xff000000),
                    ),
                  ),
                )
              ],
            ),
          ),
          IconButton(
            onPressed: onClosePressed,
            style: IconButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              overlayColor: Colors.transparent,
            ),
            icon: const Icon(
              Icons.close,
              size: 20,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
