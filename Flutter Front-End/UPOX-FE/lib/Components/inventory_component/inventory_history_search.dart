import 'package:flutter/material.dart';

class InventoryHistorySearch extends StatelessWidget {
  final String iconSearch;
  final String historyText;
  final VoidCallback onPressed;
  final VoidCallback onDelete;
  const InventoryHistorySearch(
      {super.key,
      required this.iconSearch,
      required this.historyText,
      required this.onPressed,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Container(
      margin: const EdgeInsets.only(left: 5),
      color: Colors.white,
      width: width * 0.95,
      height: height * 0.05,
      child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(children: [
                  Image.asset(
                    iconSearch,
                    width: width * 0.04,
                    height: height * 0.02,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    historyText,
                    style: const TextStyle(
                      fontFamily: "inter",
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ]),
                Container(
                  // color: Colors.amber,
                  // margin: const EdgeInsets.only(bottom: 50),
                  width: 40,
                  height: 60,
                  child: IconButton(
                      onPressed: onDelete,
                      style: IconButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: Colors.transparent,
                      ),
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.black54,
                      )),
                ),
                // const SizedBox(height: 10),
              ])),
    );
  }
}
