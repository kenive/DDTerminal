part of 'add_ssh.dart';

class AddSSHLogic extends ChangeNotifier {
  late BuildContext context;

  late FirstSSHLogic logic;

  AddSSHLogic({required this.context}) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  TextEditingController host = TextEditingController();
  TextEditingController port = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();

  Host ssh = Host(host: '', pass: '', name: '', port: '');
  bool passwordVisible = true;

  void submit() async {
    try {
      if (host.text.trim().isEmpty ||
          port.text.trim().isEmpty ||
          pass.text.trim().isEmpty ||
          name.text.trim().isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Không được bỏ trống')));
      } else {
        ssh = Host(
            id: null,
            host: host.text,
            pass: pass.text,
            name: name.text,
            port: port.text);
        await DBHelper.instance.newHost(ssh);
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Thêm mới thành công')));
        clean();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('$e');
    }
  }

  void checkPasswordVisible() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void update() async {
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
        await DBHelper.instance.updateHost(ssh);

        await DBHelper.instance.getAllClients();

        clean();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('$e');
    }
  }

  void cancel() {
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
