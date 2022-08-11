import 'dart:async';
import 'dart:convert';
import 'package:dd_terminal/model/host/host.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ssh2/ssh2.dart';
import 'package:xterm/frontend/terminal_view.dart';
import 'package:xterm/theme/terminal_themes.dart';
import 'package:xterm/xterm.dart';
part 'terminal_logic.dart';

class DDTerminal extends StatefulWidget {
  const DDTerminal({Key? key}) : super(key: key);

  @override
  State<DDTerminal> createState() => _DDTerminalState();
}

class _DDTerminalState extends State<DDTerminal>
    with AutomaticKeepAliveClientMixin {
  Host get value => ModalRoute.of(context)!.settings.arguments as Host;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text(value.host),
          elevation: 0,
          bottomOpacity: 0,
          backgroundColor: const Color(0xFF415584),
        ),
        body: SafeArea(
            child: SizedBox(
          child: TerminalView(
            autofocus: true,
            padding: 5,
            enableSuggestions: true,
            scrollController: ScrollController(
              initialScrollOffset: 2,
            ),
            scrollBehavior: const ScrollBehavior(),
            style: const TerminalStyle(
              fontFamily: ['Cascadia Mono'],
              fontSize: 15,
              //textStyleProvider:
              ignoreBoldFlag: true,
            ),
            terminal: Terminal(
                theme: TerminalThemes.whiteOnBlack,
                backend: FakeTerminalBackend(
                    value.host, value.port, value.name, value.pass),
                maxLines: 10000),
          ),
        )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FakeTerminalBackend extends TerminalBackend {
  late SSHClient client;

  final String _host;
  final String _port;
  final String _username;
  final String _password;

  String cmt = '';
  String result = '';

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
    client = SSHClient(
      host: _host,
      port: int.parse(_port),
      passwordOrKey: _password,
      username: _username,
    );
    onWrite('connecting host: $_host');
    _outStream.sink.add('\r\n\r\n');
    khoiTaoConnect();
  }

  void khoiTaoConnect() async {
    try {
      result = await client.connect() ?? 'Null result';
      if (result == "session_connected") {
        result = await client.startShell(
                ptyType: "vanilla",
                callback: (dynamic res) {
                  onWrite(res);
                }) ??
            '';
      } else {
        result = '';
        await client.disconnect();
      }
    } on PlatformException catch (e) {
      onWrite('Connection to host abc failed');
      await client.disconnect();
      debugPrint('$e');
    }
  }

  void connect(String cmt) async {
    try {
      if (result == 'shell_started') {
        await client.writeToShell(cmt + '\n');
      } else {
        await client.disconnect();
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  void resize(int width, int height, int pixelWidth, int pixelHeight) {}

  @override
  void write(String input) {
    if (input.isEmpty) {
      cmt = '';
      return;
    }
    if (input.codeUnitAt(0) == 13) {
      String clearCmt = cmt.replaceAll(RegExp(r'.'), '\b \b');
      _outStream.sink.add(clearCmt);
      connect(cmt);
    } else if (input.codeUnitAt(0) == 27) {
      if (cmt.isNotEmpty) {
        _outStream.sink.add('\b \b');
        for (int i = 1; i <= cmt.length; i++) {
          cmt = cmt.substring(0, cmt.length - 1);
          break;
        }
      }
    } else {
      if (input != '\r' &&
          input.codeUnitAt(0) != 127 &&
          input.codeUnitAt(0) != 27) {
        _outStream.sink.add(input);
        cmt += input;
      }
    }
  }

  void xuLyDelete(String xau) {}

  @override
  void terminate() {}

  @override
  void ackProcessed() {}
}
