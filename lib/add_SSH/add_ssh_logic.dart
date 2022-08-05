part of 'add_ssh.dart';

class AddSSHLogic extends ChangeNotifier {
  late BuildContext context;

  late FirstSSHLogic logic;

  AddSSHLogic({required this.context}) {
    logic = context.read<FirstSSHLogic>();
  }
  TextEditingController host = TextEditingController(text: 'test');
  TextEditingController port = TextEditingController(text: 'test');
  TextEditingController name = TextEditingController(text: 'test');
  TextEditingController pass = TextEditingController(text: 'test');

  Host ssh = Host(host: 'host', pass: 'pass', name: 'nguyen', port: 'port');

  void test() {
    LocalStorage.instance.pref!.remove('host');
    print(LocalStorage.instance.store.getString('host'));
  }

  void submit() {
    try {
      if (host.text.trim().isEmpty ||
          port.text.trim().isEmpty ||
          pass.text.trim().isEmpty ||
          name.text.trim().isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Không được bỏ trống')));
      } else {
        ssh = Host(
            host: host.text, pass: pass.text, name: name.text, port: port.text);
        LocalStorage.instance.setHost(ssh);
        clean();
        logic.getData();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('$e');
    }
  }

  void cancel() {
    LocalStorage.instance.pref!.remove('lst');
    //print(LocalStorage.instance.lstHost!.length);
    //print(LocalStorage.instance.lstHost.name);
    clean();
    notifyListeners();
  }

  void clean() {
    host.clear();
    name.clear();
    pass.clear();
    port.clear();
    notifyListeners();
  }
}
