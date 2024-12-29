import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ** Fong
//** Đã Thêm các attributes width height, TitleMargin, margin
//*  để dễ tinh chỉnh các vị trị bị cố định sẵn */
class MyBoxTextField extends StatefulWidget {
  final String title;
  final String hiddenText;
  final bool isValid;
  final bool isPassWord;
  final double? width;
  final double? height;
  final TextEditingController editTextController;
  final EdgeInsets? titleMargin;
  final EdgeInsets? margin;

  const MyBoxTextField({
    super.key,
    required this.title,
    required this.hiddenText,
    required this.isValid,
    required this.isPassWord,
    required this.editTextController,
    this.width = 342,
    this.height = 57,
    this.titleMargin = const EdgeInsets.only(left: 24),
    this.margin = const EdgeInsets.only(left: 10, right: 10, top: 10),
  });

  @override
  State<MyBoxTextField> createState() => _MyBoxTextFieldState();
}

class _MyBoxTextFieldState extends State<MyBoxTextField> {
  bool isSelected = false;
  bool passwordVisible = false;
  final myFocusNode = FocusNode();
  late bool _isValid;
  bool _isTypingAgain = false;

  // void boxOnTap(){
  //   setState(() {
  //     isSelected = true;
  //   });
  // }

  // void boxOnTapOut(){
  //   setState(() {
  //     isSelected = false;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode.addListener(_onFocusChange);
    passwordVisible = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myFocusNode.removeListener(_onFocusChange);
    myFocusNode.dispose();
  }

  void _onFocusChange() {
    log("Focus: ${myFocusNode.hasFocus.toString()}");
    setState(() {
      isSelected = !isSelected;
    });
  }

  void checkValid() {
    if (_isTypingAgain) {
      _isValid = true;
    } else {
      _isValid = widget.isValid;
    }
  }

  @override
  Widget build(BuildContext context) {
    // checkValid();
    _isValid = widget.isValid;
    log("Textbox is valid: $_isValid");
    // Lấy kích thước màn hình
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double containerWidth = widget.width ?? screenWidth * 0.8;
    double containerHeight = widget.height ?? 57;

    return Container(
        child: Column(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        AnimatedContainer(
          width: screenWidth,
          margin: widget.titleMargin,
          duration: const Duration(microseconds: 0),
          child: Text(widget.title,
              style: TextStyle(
                color: _isValid
                    ? (!isSelected
                        ? const Color(0xFF363636)
                        : const Color(0xFF18A0FB))
                    : const Color(0xFFF36565),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              )),
        ),
        AnimatedContainer(
          duration: const Duration(microseconds: 0),
          width: containerWidth,
          height: containerHeight,
          margin: widget.margin,
          // padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
          child: TextFormField(
            //Pass related
            obscureText: widget.isPassWord ? passwordVisible : false,
            obscuringCharacter: "*",
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.isPassWord ? 15 : null)
            ],

            // onTap: () {
            //   log("Box changes");
            //   if(_isValid == false){
            //     setState(() {
            //        _isTypingAgain = true;
            //     });
            //   }
            // },

            focusNode: myFocusNode,
            controller: widget.editTextController,
            cursorColor: Color(0xFF18A0FB),
            cursorRadius: Radius.circular(10),
            cursorErrorColor: Color(0xFF18A0FB),
            // autofocus: true,
            // controller: Xử lý trả text về,
            // onTap: boxOnTap,
            //Error check

            onTapOutside: (event) => {
              // boxOnTapOut(),
              FocusManager.instance.primaryFocus?.unfocus()
            },
            // onTapOutside: boxOnTap,
            decoration: InputDecoration(
                hintText: widget.hiddenText,
                hintStyle: _isValid
                    ? const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFAFB4BD))
                    : const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFF36565)),
                //Border
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                        strokeAlign: BorderSide.strokeAlignOutside,
                        width: 3,
                        color: _isValid
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFFF36565))),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(
                        strokeAlign: BorderSide.strokeAlignOutside,
                        width: 3,
                        color: Color(0xFF18A0FB))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                        strokeAlign: BorderSide.strokeAlignOutside,
                        width: 3,
                        color: _isValid
                            ? const Color(0xFF18A0FB)
                            : const Color(0xFFF36565))),

                //Fill
                filled: true,
                fillColor:
                    WidgetStateColor.resolveWith((Set<WidgetState> states) {
                  if (states.contains(WidgetState.focused) || !_isValid) {
                    return const Color(0xFFFFFFFF);
                  }
                  return const Color(0xFFF7F8FA);
                }),

                //Suffix icon - pass related
                suffixIcon: widget.isPassWord
                    ? IconButton(
                        icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: !isSelected
                                ? const Color(0xFFAFB4BD)
                                : const Color(0xFF18A0FB)),
                        onPressed: () {
                          setState(
                            () {
                              passwordVisible = !passwordVisible;
                            },
                          );
                        },
                      )
                    : null,

                // Padding
                contentPadding:
                    const EdgeInsets.only(top: 18, bottom: 18, left: 18)),
            style: TextStyle(
              color:
                  _isValid ? const Color(0xFF18A0FB) : const Color(0xFFF36565),
              fontSize: 15,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
              decorationThickness: 0,
            ),
          ),
        )
      ],
    ));
  }
}
