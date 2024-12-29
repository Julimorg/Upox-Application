import 'package:flutter/material.dart';

class MyInformationLabel extends StatelessWidget {
  const MyInformationLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 342,
      child: Row(
        children: [
          SizedBox(
            height: 62,
            width: 74,
            child: Image.asset("assets/image_product_test_small.png"),
          ),
          const SizedBox(
            width: 16,
          ),
          Container(
            decoration: const BoxDecoration(color: Color(0xFF000000)),
            margin: const EdgeInsets.only(top: 5),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Kem rửa mặt",
                  style: TextStyle(
                    color: Color(0xFF18A0FB),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  width: 200,
                  height: 3,
                  child: DecoratedBox(
                      decoration: BoxDecoration(color: Color(0xFF18A0FB))),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
