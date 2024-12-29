import 'package:first_app/Components/khoa_component/Comp_logic/list_square_filled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer';

class MySquareVerifyNumber extends StatefulWidget {
  final FocusNode itsFocusNode;
  final FocusNode? nextFocusNode;
  final FocusNode? prevFocusNode;
  final bool? isLastNode;
  final bool? isFirstNode;
  final String nodeName;
  final FocusNode? firstNode;
  final TextEditingController myController;
  final EntitySquareFilled? entity;
  final Function callback;

  const MySquareVerifyNumber(
      {super.key,
      required this.itsFocusNode,
      required this.nextFocusNode,
      required this.prevFocusNode,
      required this.isFirstNode,
      required this.isLastNode,
      required this.nodeName,
      required this.firstNode,
      required this.myController,
      required this.entity,
      required this.callback});

  @override
  State<MySquareVerifyNumber> createState() => _MySquareVerifyNumberState();
}

class _MySquareVerifyNumberState extends State<MySquareVerifyNumber> {
  bool isFilled = false;

  void boxOnFill() {
    setState(() {
      isFilled = true;
    });
  }

  void boxOnDelete() {
    setState(() {
      isFilled = false;
    });
  }

  FocusNode? boxOnTap() {
    log("List status when on Tap: \n");
    widget.entity?.printOutList();
    FocusNode? node = widget.entity?.checkLatestFilledSquare();
    return node;
  }

  void isSquareFilled(String nodeName_, bool status) {
    int index = int.parse(nodeName_[nodeName_.length - 1]) - 1;
    widget.entity?.set(index, status);
    log("List status when being edited: \n");
    widget.entity?.printOutList();
  }

  @override
  void dispose() {
    widget.itsFocusNode.dispose();
    super.dispose();
  }

  void onUpdate() {
    log("Update !!!");
    //Update
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(microseconds: 0),
      width: 50,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(
              strokeAlign: BorderSide.strokeAlignOutside,
              width: 2,
              color: !isFilled ? Colors.white : const Color(0xFF18A0FB)),
          color: !isFilled ? const Color(0xFFF1F2F4) : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1)
        ],
        focusNode: widget.itsFocusNode,
        textAlign: TextAlign.center,
        showCursor: true,
        style: const TextStyle(
            color: Color(0xFF18A0FB),
            fontSize: 23,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.none,
            decorationThickness: 0),
        decoration: const InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none),
        // enabled: isSquareTextEnabled(),
        onChanged: (value) => {
          log("${widget.nodeName}"),
          log("$value ${value.length}"),
          onUpdate(),
          //erase
          if ((widget.isFirstNode == false || widget.isFirstNode == true) &&
              value.isEmpty)
            {
              if (widget.isFirstNode == false)
                {
                  FocusScope.of(context).previousFocus(),
                },
              //Cập nhật lại list
              isSquareFilled(widget.nodeName, false),
              // TextInputAction.previous,
              boxOnDelete()
            },
          //type in
          if ((widget.isLastNode == false || widget.isLastNode == true) &&
              value.length == 1)
            {
              if (widget.isLastNode == false)
                {FocusScope.of(context).nextFocus()},
              //Cập nhật lại list
              isSquareFilled(widget.nodeName, true),
              // TextInputAction.next,
              boxOnFill()
            }
        },
        // textInputAction: isFilled? TextInputAction.next : TextInputAction.previous,
        controller: widget.myController,
        // onTap: () => {
        //   FocusScope.of(context).requestFocus(boxOnTap())
        // },
        onTapOutside: (event) =>
            {FocusManager.instance.primaryFocus?.unfocus()},
      ),
    );
  }
}

// Cần chỉnh sửa: Đã detect được square được điền gần nhất
// --> Nếu bắt focus ngay ô được điền sẽ không điền được ô kế tiếp
// --> Nếu bắt focus ô ngay sau đó sẽ không xóa được ô được điền gần nhất
