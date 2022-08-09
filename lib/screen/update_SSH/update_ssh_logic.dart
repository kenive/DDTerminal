part of 'update_ssh.dart';

class UpdateSshLogic extends ChangeNotifier {
  late BuildContext context;

  late FirstSSHLogic logic;
  int id = 0;
  UpdateSshLogic({required this.context}) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Host? value = ModalRoute.of(context)!.settings.arguments as Host?;
      if (value != null) {
        id = value.id!;
        host.text = value.host;
        port.text = value.port;
        pass.text = value.pass;
        name.text = value.name;
      }
    });
  }

  TextEditingController host = TextEditingController(text: 'test');
  TextEditingController port = TextEditingController(text: 'test');
  TextEditingController name = TextEditingController(text: 'test');
  TextEditingController pass = TextEditingController(text: 'test');

  Host ssh = Host(host: 'host', pass: 'pass', name: 'nguyen', port: 'port');

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
            id: id,
            host: host.text,
            pass: pass.text,
            name: name.text,
            port: port.text);
        await DBHelper.instance.updateHost(ssh);
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Cập nhật thành công')));
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
