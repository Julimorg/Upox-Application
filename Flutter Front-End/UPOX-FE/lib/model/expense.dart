import 'dart:ffi';

class Expense {
  Map<String, dynamic> categories = {};
  dynamic limit;
  dynamic totSpent;

  Expense.initialize();

  Expense.fromJson(Map<String, dynamic> json){
    categories = json["categorizedExpense"];
    limit = json["limit"];
    totSpent = json["totSpent"];
  }

}
