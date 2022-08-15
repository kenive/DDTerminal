import 'package:flutter/material.dart';

class Helper with ChangeNotifier {
  late BuildContext context;

  double heightKeyboard = 0;

  double heightActionKeyBoard = 338;

  void getHeightKeyboard(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).viewInsets.bottom + heightActionKeyBoard);
    heightKeyboard = screenHeight;
    notifyListeners();
  }

  // static double heightKeyboard({
  //   BuildContext? context,
  // }) {
  //   double screenHeight;

  //   if (context != null) {
  //     screenHeight = MediaQuery.of(context).size.height -
  //         (MediaQuery.of(context).viewInsets.bottom);
  //   } else {
  //     screenHeight = 0;
  //   }
  //   return screenHeight;
  // }
}
