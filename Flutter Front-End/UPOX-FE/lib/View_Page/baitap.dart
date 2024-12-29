import 'package:flutter/material.dart';

class ContainerClass extends StatelessWidget {
  const ContainerClass({super.key});

  @override
  Widget build(BuildContext context) {
    String url =
        "data:image/jpeg;base64,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";
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    // Container là khung chứa các elements
    return Container(
      // color: Colors.green,
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.all(10),
      width: screenWidth * 0.8,
      height: screenHeight * 0.8,
      child: Row(
        children: [
          Container(
            color: Colors.green,
            width: screenWidth * 0.2,
            height: screenHeight * 0.3,
            child: const Column(
              children: [
                Text("this is an icon"),
                const SizedBox(height: 20),
                Icon(
                  Icons.star,
                  color: Colors.blue,
                  size: 30,
                )
              ],
            ),
          ),
          Container(
            color: Colors.green,
            width: screenWidth * 0.2,
            height: screenHeight * 0.3,
            child: Column(
              children: [
                const Text(
                  "This is an image.network",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Image.network(
                  "$url",
                  width: screenWidth * 0.2,
                  height: screenHeight * 0.2,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Container(
            color: Colors.green,
            width: screenWidth * 0.2,
            height: screenHeight * 0.3,
            child: const Column(
              children: [
                Text(
                  "This is an image.assets",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Icon(
                  Icons.star,
                  color: Colors.blue,
                  size: 30,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
