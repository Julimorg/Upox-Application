import 'package:flutter/material.dart';

class ManualInputTextfield extends StatefulWidget {
  TextEditingController searchController = TextEditingController();

  ManualInputTextfield({super.key, required this.searchController});

  @override
  State<ManualInputTextfield> createState() => _ManualInputTextfield();
}

class _ManualInputTextfield extends State<ManualInputTextfield> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Container(
      child: Column(children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.only(right: 20, left: 5),
          child: TextField(
            controller: widget.searchController,
            decoration: const InputDecoration(
              hintText: 'Nhập tên sản phẩm',
              hintStyle: const TextStyle(
                  color: Color(0xffDEDEDE), // Màu văn bản placeholder
                  fontSize: 25,
                  fontFamily: "inter",
                  fontWeight: FontWeight.w700),
              suffixIcon: Icon(
                Icons.search,
                color: Color(0xffDEDEDE),
                size: 30,
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffDEDEDE)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                    color:
                        Color(0xffDEDEDE)), // Màu của đường gạch chân khi focus
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
            margin:
                EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.5),
            child: const Text("*Ví dụ: kem đánh răng P/S",
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff18A0FB),
                    fontFamily: "intern",
                    fontStyle: FontStyle.italic)))
      ]),
    );
  }
}
