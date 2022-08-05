part of '../main.dart';

class App with ChangeNotifier {
  late BuildContext context;
  App(this.context);

  void middleWare() async {
    await LocalStorage.init();
    notifyListeners();
  }
}
