import 'package:flutter/material.dart';

class HeaderIconLogin extends StatelessWidget {
  const HeaderIconLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            const Text("UPOX",
                style: TextStyle(
                  fontSize: 55,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue,
                  letterSpacing: 5,
                  fontFamily: "Halvar Breischrift",
                )),
            const SizedBox(height: 20),
            // Icon img
            Image.asset(
              'assets/Icon_box_lookDown.png',
              width: 69,
              height: 75,
            ),
          ],
        ));
  }
}
