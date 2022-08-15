import 'dart:async';
import 'package:dd_terminal/model/host/host.dart';
import 'package:dd_terminal/services/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:ssh2/ssh2.dart';
import 'package:xterm/frontend/terminal_view.dart';
import 'package:xterm/theme/terminal_themes.dart';
import 'package:xterm/xterm.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
part 'terminal_logic.dart';

enum ActionKeyboard { left, right, up, down, quit }

class DDTerminal extends StatefulWidget {
  const DDTerminal({Key? key}) : super(key: key);

  @override
  State<DDTerminal> createState() => _DDTerminalState();
}

class _DDTerminalState extends State<DDTerminal>
    with AutomaticKeepAliveClientMixin {
  late TerminalLogic logic;

  late Helper abc;

  final FocusNode node = FocusNode();

  final ValueNotifier<ActionKeyboard> actionKeyboard =
      ValueNotifier(ActionKeyboard.quit);

  late ScrollController scrollController;

  Host get value => ModalRoute.of(context)!.settings.arguments as Host;

  //double get he => Helper.heightKeyboard(context: context);
  double va = 0;

  @override
  void initState() {
    super.initState();
    logic = context.read<TerminalLogic>();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      FakeTerminalBackend('', '', '', '', actionKeyboard);
    });

    // myTerminal ??= FakeTerminalBackend(
    //     value.host, value.port, value.name, value.pass, actionKeyboard);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   //myTerminal ??= FakeTerminalBackend('', '', '', '', actionKeyboard);
  //   print(value.host);
  //   myTerminal ??= FakeTerminalBackend(
  //       value.host, value.port, value.name, value.pass, actionKeyboard);
  // }

  @override
  void dispose() {
    super.dispose();
  }

  void xuLyAction(ActionKeyboard action) {
    if (action == actionKeyboard.value) {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      actionKeyboard.notifyListeners();
    } else {
      actionKeyboard.value = action;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: logic,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(value.host),
          elevation: 0,
          bottomOpacity: 0,
          backgroundColor: const Color(0xFF415584),
        ),
        body: SafeArea(
          child: KeyboardActions(
            tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
            keepFocusOnTappingNode: true,
            bottomAvoiderScrollPhysics: const ScrollPhysics(),
            config: KeyboardActionsConfig(
              keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
              keyboardBarColor: Colors.grey,
              actions: [
                KeyboardActionsItem(
                  displayArrows: false,
                  focusNode: node,
                  displayDoneButton: false,
                  toolbarButtons: [
                    (node) {
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
                              xuLyAction(ActionKeyboard.left);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 0.5, color: Colors.black)),
                              child: const Icon(
                                Icons.keyboard_arrow_left,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              xuLyAction(ActionKeyboard.right);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 0.5, color: Colors.black)),
                              child: const Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              xuLyAction(ActionKeyboard.down);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 0.5, color: Colors.black)),
                              child: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              xuLyAction(ActionKeyboard.up);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 0.5, color: Colors.black)),
                              child: const Icon(
                                Icons.keyboard_arrow_up,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ],
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                  height: GetIt.instance.get<Helper>().heightKeyboard,
                  child: TerminalView(
                    autofocus: true,
                    padding: 5,
                    focusNode: node,
                    // autocorrect: true,
                    scrollController: ScrollController(),
                    scrollBehavior: const ScrollBehavior(),
                    style: const TerminalStyle(
                      fontFamily: ['Cascadia Mono'],
                      fontSize: 15,
                      ignoreBoldFlag: true,
                    ),
                    terminal: Terminal(
                        theme: TerminalThemes.whiteOnBlack,
                        //backend: myTerminal,
                        backend: FakeTerminalBackend(value.host, value.port,
                            value.name, value.pass, actionKeyboard),
                        maxLines: 10000),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FakeTerminalBackend extends TerminalBackend {
  late SSHClient client;
  final ValueNotifier<ActionKeyboard> actionKeyboard;

  final String _host;
  final String _port;
  final String _username;
  final String _password;

  String cmd = '';
  String result = '';
  int countRight = 0;
  int countLeft = 0;

  FakeTerminalBackend(this._host, this._port, this._username, this._password,
      this.actionKeyboard);

  final _exitCodeCompleter = Completer<int>();
  final _outStream = StreamController<String>();
  void onWrite(String data) {
    _outStream.sink.add(data);
  }

  void onWriteAction(String data) {
    // if (countLeft > 0) {
    //   cmd += data;
    // } else if (countRight > 0) {
    //   cmd += data;
    // }

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
    actionKeyboard.addListener(listenerActionKeyboard);
  }

  void khoiTaoConnect() async {
    try {
      result = await client.connect() ?? 'Null result';
      if (result == "session_connected") {
        result = await client.startShell(
                ptyType: "xterm",
                callback: (dynamic res) {
                  onWrite(res);
                  cmd = '';
                }) ??
            '';
      } else {
        result = '';
        onWrite('Connection to host abc failed');
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
      // if (countLeft > 0) {
      //   String clearCmt = cmd.replaceAll(RegExp(r'.'), '\b');
      //   _outStream.sink.add(clearCmt);
      // }
      if (result == 'shell_started') {
        await client.writeToShell(cmt + '\n');
      } else {
        await client.disconnect();
      }
      resetCount();
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  void resize(int width, int height, int pixelWidth, int pixelHeight) {}

  @override
  void write(String input) {
    if (input.isEmpty) {
      cmd = '';
      return;
    }
    if (input.codeUnitAt(0) == 13) {
      String clearCmt = cmd.replaceAll(RegExp(r'.'), '\b');
      _outStream.sink.add(clearCmt);
      connect(cmd);
    } else if (input.codeUnitAt(0) == 27) {
      if (cmd.isNotEmpty) {
        _outStream.sink.add('\b \b');
        cmd = cmd.substring(0, cmd.length - 1);
      }
    } else if (input.codeUnitAt(0) == 97) {
      cmd = cmd.substring(0, cmd.length - 1);
    } else {
      if (input != '\r' &&
          input.codeUnitAt(0) != 127 &&
          input.codeUnitAt(0) != 27) {
        _outStream.sink.add(input);
        cmd += input;
      }
    }
  }

  @override
  void terminate() {
    actionKeyboard.removeListener(listenerActionKeyboard);
  }

  @override
  void ackProcessed() {}

  void resetCount() {
    countLeft = 0;
    countRight = 0;
  }

  void listenerActionKeyboard() {
    switch (actionKeyboard.value) {
      case ActionKeyboard.up:
        break;
      case ActionKeyboard.down:
        break;
      case ActionKeyboard.right:
        if (countLeft > 0) {
          countRight++;
          onWriteAction(cmd[cmd.length - countLeft]);
          countLeft--;
        } else {}
        break;
      default:
        if (cmd.length > countLeft) {
          countLeft++;
          if (cmd.isNotEmpty) {
            if (cmd.length >= countLeft) {
              onWriteAction('\b');
            }
          }
        }
    }
  }
}
