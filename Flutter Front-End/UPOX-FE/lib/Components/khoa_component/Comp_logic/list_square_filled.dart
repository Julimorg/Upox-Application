import 'dart:developer';

import 'package:first_app/Components/khoa_component/Comp_logic/is_this_square_filled.dart';
import 'package:flutter/material.dart';

class EntitySquareFilled {
  List<IsThisSquareFilled> _lst = [];

  EntitySquareFilled();

  void createList(List<FocusNode> focus_lst) {
    int size = 4;
    for (int i = 0; i < size; i++) {
      IsThisSquareFilled square = IsThisSquareFilled(node: focus_lst[i]);
      _lst.add(square);
    }
  }

  FocusNode checkLatestFilledSquare() {
    for (int i = 0; i < _lst.length; i++) {
      if (_lst[i].getFill() == false) {
        if (i == 0) {
          //Ô đầu tiên chưa điền
          return _lst[i].getNode();
        }
        //Tìm thấy ô gần nhất chưa được điền --> ô trước nó sẽ là ô đã điền mới nhất
        return _lst[i - 1].getNode();
      }
    }
    // Tất cả ô để đã được điền
    return _lst[_lst.length - 1].getNode();
  }

  void set(int position, bool isFilled) {
    _lst[position].set(isFilled);
  }

  List<IsThisSquareFilled> get() {
    return _lst;
  }

  void printOutList() {
    int size = 4;
    for (int i = 0; i < size; i++) {
      log("${_lst[i].getFill()}[$i]");
    }
  }
}
