part of 'first_ssh.dart';

class FirstSSHLogic extends ChangeNotifier {
  late BuildContext context;

  FirstSSHLogic({required this.context}) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getData();
    });
  }
  bool checkData = true;
  List<Host> data = [];

  void getData() async {
    try {
      var response = await DBHelper.instance.getAllClients();
      data = response;
      data = data.reversed.toList();
      checkData = false;
      if (data.isNotEmpty) {
        checkData = true;
      } else {
        checkData = false;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('$e');
    }
  }

  void delete(int id) async {
    try {
      await DBHelper.instance.delete(id);
      getData();
      notifyListeners();
    } catch (e) {
      debugPrint('$e');
    }
  }
}
