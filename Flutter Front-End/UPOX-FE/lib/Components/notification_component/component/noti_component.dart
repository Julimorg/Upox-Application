import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String logoPath;
  final String title;
  final String time;
  final String header;
  final String content;
  final VoidCallback onPressed;

  const NotificationCard({
    super.key,
    required this.logoPath,
    required this.title,
    required this.time,
    required this.header,
    required this.content,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
        child: Column(children: [
      Container(
        child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              minimumSize: Size(width * 0.09, height * 0.09),
              padding: const EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo - Banner - Time
                Row(
                  children: [
                    Image.asset(
                      logoPath,
                      height: 20,
                      width: 20,
                    ),
                    // const SizedBox(width: 10),
                    // Text( //Bỏ 
                    //   title,
                    //   style: const TextStyle(
                    //     fontFamily: "Istok Web",
                    //     fontWeight: FontWeight.w700,
                    //     fontSize: 20,
                    //     color: Color(0xff363636),
                    //   ),
                    // ),
                    const SizedBox(width: 10),
                    Text(
                      time,
                      style: const TextStyle(
                        fontFamily: "Istok Web",
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        color: Color(0xff595959),
                      ),
                    )
                  ],
                ),
                // Noti Header Content
                const SizedBox(height: 5),
                Container(
                  child: Text(header,
                      style: const TextStyle(
                        fontFamily: "Istok Web",
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xff363636),
                      )),
                ),
                const SizedBox(height: 5),
                // Noti Content Text
                Container(
                  child: Text(content,
                      style: const TextStyle(
                        fontFamily: "Istok Web",
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Color(0xff000000),
                      )),
                ),
                const SizedBox(height: 14),
                Container(
                  color: Color(0xffE3E3E3),
                  height: height * 0.002,
                  width: width * 1,
                ),
              ],
            )),
      )
    ]));
  }
}
