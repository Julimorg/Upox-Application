import 'package:flutter/material.dart';

class IsThisSquareFilled {
  bool _isFill = false;
  FocusNode node;

  IsThisSquareFilled({required this.node});

  void set(bool isFilled) {
    _isFill = isFilled;
  }

  bool getFill() {
    return _isFill;
  }

  FocusNode getNode() {
    return node;
  }
}
