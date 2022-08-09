import 'dart:async';
import 'package:dd_terminal/model/host/host.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ssh2/ssh2.dart';
import 'package:xterm/frontend/terminal_view.dart';
import 'package:xterm/xterm.dart';

class DDTerminal extends StatefulWidget {
  const DDTerminal({Key? key}) : super(key: key);

  @override
  State<DDTerminal> createState() => _DDTerminalState();
}

class _DDTerminalState extends State<DDTerminal> {
  @override
  void initState() {
    super.initState();
  }

  Host get value => ModalRoute.of(context)!.settings.arguments as Host;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(value.host),
          elevation: 0,
          bottomOpacity: 0,
          backgroundColor: const Color(0xFF415584),
        ),
        body: SafeArea(
          child: Center(
            child: TerminalView(
              autofocus: true,
              padding: 10,
              style: const TerminalStyle(
                  fontSize: 15, fontFamily: ['Cascadia Mono']),
              terminal: Terminal(
                  backend: FakeTerminalBackend(
                      value.host, value.port, value.name, value.pass),
                  maxLines: 10000),
            ),
          ),
        ),
      ),
    );
  }
}

class FakeTerminalBackend extends TerminalBackend {
  late SSHClient client;
  String _host;
  String _port;
  String _username;
  String _password;
  String cmt = '';

  FakeTerminalBackend(this._host, this._port, this._username, this._password);

  final _exitCodeCompleter = Completer<int>();
  final _outStream = StreamController<String>();

  void onWrite(String data) {
    cmt = '';
    _outStream.sink.add(data);
  }

  @override
  Stream<String> get out => _outStream.stream;

  @override
  Future<int> get exitCode => _exitCodeCompleter.future;

  @override
  void init() {
    onWrite('connecting host: $_host');
    _outStream.sink.add('\r\n');
    client = SSHClient(
      host: _host,
      port: int.parse(_port),
      passwordOrKey: _password,
      username: _username,
    );
    khoiTaoConnect();
  }

  String result = '';
  void khoiTaoConnect() async {
    try {
      result = await client.connect() ?? 'Null result';
      if (result == "session_connected") {
        result = await client.startShell(
                ptyType: "xterm",
                callback: (dynamic res) {
                  onWrite(res);
                }) ??
            'Null result';
      }
    } on PlatformException catch (e) {
      String errorMessage = 'Error: ${e.code}\nError Message: ${e.message}';
      result = errorMessage;
      await client.disconnect();
    }
  }

  void connect(String cmt) async {
    if (result == 'shell_started') {
      await client.writeToShell(cmt + '\n');

      cmt = '';
    } else {
      await client.disconnect();
    }
  }

  @override
  void resize(int width, int height, int pixelWidth, int pixelHeight) {}

  @override
  void write(String input) {
    if (input.isEmpty) {
      cmt = '';
      client.disconnect();
      return;
    }
    if (input == '\r') {
      var clearCmt = cmt.replaceAll(RegExp(r'.'), '\b');

      _outStream.sink.add(clearCmt);
      connect(cmt);
    } else if (input.codeUnitAt(0) == 127) {
      _outStream.sink.add('\b');
    }  else {
      if (input != '\r') {
        _outStream.sink.add(input);
        cmt += input;
      } else {
        cmt = '';
      }
    }
  }

  @override
  void terminate() {
    //connect(a);
  }

  @override
  void ackProcessed() {}
}
