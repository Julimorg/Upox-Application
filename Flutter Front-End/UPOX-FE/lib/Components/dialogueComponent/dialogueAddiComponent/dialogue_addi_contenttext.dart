import 'package:flutter/material.dart';

class DialogueAddiContenttext extends StatelessWidget {
  const DialogueAddiContenttext({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color(0xfff5f5f5),
        ),
        child: const Column(children: [
          const Text("Hôm nay, chúng ta có gì mới bạn nhỉ?",
              style: TextStyle(
                fontSize: 15,
                letterSpacing: 0.5,
                fontFamily: "Cuprum",
                fontWeight: FontWeight.w400,
                color: Color(0xff1d2f82),
              )),
        ]));
  }
}
