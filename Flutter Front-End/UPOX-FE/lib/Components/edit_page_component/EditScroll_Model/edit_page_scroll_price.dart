import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditPageScrollPrice extends StatefulWidget {
  const EditPageScrollPrice({super.key});

  @override
  State<EditPageScrollPrice> createState() => _EditPageScrollPriceState();
}

class _EditPageScrollPriceState extends State<EditPageScrollPrice> {
  //? Default Attributes
  String tempSelectedImage = "assets/crash_banner.png"; // Giá trị mặc định
  int selectedIndex = 0; // Lưu trữ chỉ số đã chọn

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 250,
        child: Column(
          children: [
            const Text(
              "Chọn phương thức bạn đã thanh toán!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 140,
                onSelectedItemChanged: (int value) {
                  setState(() {
                    selectedIndex = value; // Cập nhật chỉ số đã chọn
                    tempSelectedImage = value == 0
                        ? "assets/crash_banner.png"
                        : "assets/banking_banner.png";
                  });
                },
                // Hiển thị giá trị đã chọn
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset("assets/crash_banner.png",
                            width: 60, height: 40),
                        const SizedBox(height: 10),
                        const Text("Trả bằng tiền mặt"),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset("assets/banking_banner.png",
                            width: 60, height: 40),
                        const SizedBox(height: 10),
                        const Text("Trả bằng Banking"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context, tempSelectedImage); // Trả về giá trị đã chọn
              },
              child: const Text(
                "Xác nhận",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
