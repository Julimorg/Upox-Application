import 'package:flutter/material.dart';

class InventoryFilterButton extends StatefulWidget {
  final String filterName;
  final VoidCallback onPressed;
  final double? widthFactor;
  final double? heightFactor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final bool isSelected; // Thêm biến trạng thái

  const InventoryFilterButton({
    super.key,
    required this.filterName,
    required this.onPressed,
    this.widthFactor,
    this.heightFactor,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.isSelected = false,
  });

  @override
  State<InventoryFilterButton> createState() => _InventoryFilterButtonState();
}

class _InventoryFilterButtonState extends State<InventoryFilterButton> {
  late Color textColor;
  late Color borderColor;

  @override
  void initState() {
    super.initState();
    // Khởi tạo màu sắc dựa trên isSelected
    _updateColors();
  }

  void _updateColors() {
    textColor = widget.isSelected ? Colors.blue : Colors.black;
    borderColor = widget.isSelected ? Colors.blue : const Color(0xffF3F3F3);
  }

  @override
  void didUpdateWidget(covariant InventoryFilterButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cập nhật lại màu sắc khi isSelected thay đổi
    if (oldWidget.isSelected != widget.isSelected) {
      _updateColors();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        widget.onPressed();
        setState(() {
          _updateColors(); // Cập nhật màu sắc
        });
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: borderColor),
        ),
      ),
      child: Text(
        widget.filterName,
        style: TextStyle(
          fontFamily: "Istok Web",
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: textColor,
        ),
      ),
    );
  }
}
