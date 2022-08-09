import 'dart:async';
import 'dart:convert';
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
        FocusScope.of(context).unfocus();
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
              style: const TerminalStyle(
                fontSize: 20,
              ),
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

  FakeTerminalBackend(this._host, this._port, this._username, this._password);

  final _exitCodeCompleter = Completer<int>();
  final _outStream = StreamController<String>();

  void onWrite(String data) {
    _outStream.sink.add(data);
  }

  @override
  Future<int> get exitCode => _exitCodeCompleter.future;
  @override
  void init() {
    // _outStream.sink.add('Nguyen Flutter');

    final _sshOutput = StreamController<List<int>>();
    _sshOutput.stream.transform(utf8.decoder).listen(onWrite);

    onWrite('connecting host: $_host ...');
    _outStream.sink.add('\r\n');

    connect('');
  }

  void connect(String cmt) async {
    String result = '';

    client = SSHClient(
      host: _host,
      port: int.parse(_port),
      passwordOrKey: _password,
      username: _username,
    );
    try {
      result = await client.connect() ?? 'Null result';
      if (result == "session_connected") {
        result = await client.execute(cmt) ?? 'Null result';
        print(result);
        onWrite(result);
      }
      await client.disconnect();
    } on PlatformException catch (e) {
      String errorMessage = 'Error: ${e.code}\nError Message: ${e.message}';
      result = errorMessage;
      //onWrite('connecting host: $result...');
    }
  }

  @override
  Stream<String> get out => _outStream.stream;

  @override
  void resize(int width, int height, int pixelWidth, int pixelHeight) {}

  @override
  void write(String input) {
    if (input.isEmpty) {
      return;
    }

    if (input == '\r') {
      _outStream.sink.add('\r\n');
      _outStream.sink.add('\$ ');
    } else if (input.codeUnitAt(0) == 127) {
      _outStream.sink.add('\b \b');
    } else {
      _outStream.sink.add(input);
    }
  }

  @override
  void terminate() {
    print('object');
  }

  @override
  void ackProcessed() {}
}
