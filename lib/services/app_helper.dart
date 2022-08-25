import 'package:flutter/material.dart';

class Helper with ChangeNotifier {
  late BuildContext context;

  double heightKeyboard = 0;

  double heightActionKeyBoard = 200;

  void getHeightKeyboard(BuildContext context) {
    double heightBottom =
        MediaQuery.of(context).viewPadding.bottom > 0 ? 290 : 189;

    heightKeyboard = MediaQuery.of(context).size.height -
        (heightBottom + heightActionKeyBoard);
    notifyListeners();
  }
}
