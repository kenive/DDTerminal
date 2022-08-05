part of 'first_ssh.dart';

class FirstSSHLogic extends ChangeNotifier {
  late BuildContext context;

  FirstSSHLogic({required this.context}) {}
  List<Host> data = [];

  void getData() async {
    //List<Host> temp = [];
    await LocalStorage.init();
    data = LocalStorage.instance.lstHost1;
    print(data.length);
    try {
      //temp.add(LocalStorage.instance.lstHost);

      notifyListeners();
    } catch (e) {
      debugPrint('$e');
    }
  }

  void delete() {
    try {
      LocalStorage.instance.pref!.remove('lst');
      data = [];
      notifyListeners();
    } catch (e) {
      debugPrint('$e');
    }
  }
}
