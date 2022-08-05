import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xterm/frontend/terminal_view.dart';
import 'package:xterm/theme/terminal_themes.dart';
import 'package:xterm/xterm.dart';

class DDTerminal extends StatefulWidget {
  const DDTerminal({Key? key}) : super(key: key);

  @override
  State<DDTerminal> createState() => _DDTerminalState();
}

class _DDTerminalState extends State<DDTerminal> {
  final terminal = Terminal(
    maxLines: 10,
    backend: FakeTerminalBackend(),
  );

  void onInput(String input) {
    print('input: $input');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Center(
            child: TerminalView(
              style: const TerminalStyle(
                fontSize: 20,
              ),
              terminal: terminal,
            ),
          ),
        ),
      ),
    );
  }
}

class FakeTerminalBackend extends TerminalBackend {
  final _exitCodeCompleter = Completer<int>();
  final _outStream = StreamController<String>();

  @override
  Future<int> get exitCode => _exitCodeCompleter.future;

  @override
  void init() {
    _outStream.sink.add('Nguyen Flutter');
    _outStream.sink.add('\r\n');
    _outStream.sink.add('\$ ');
  }

  @override
  Stream<String> get out => _outStream.stream;

  @override
  void resize(int width, int height, int pixelWidth, int pixelHeight) {
    // NOOP
  }

  @override
  void write(String input) {
    if (input.isEmpty) {
      return;
    }

    if (input == '\r') {
      terminate();

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
    //NOOP
    print('object');
  }

  @override
  void ackProcessed() {
    //NOOP
  }
}
