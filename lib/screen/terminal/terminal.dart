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

enum ActionKeyboard { left, right, up, down, send, quit }

List<String> history = [];

String send = '';
String tamp = '';

int index = 0;
bool isGetHistory = false;

class DDTerminal extends StatefulWidget {
  const DDTerminal({Key? key}) : super(key: key);

  @override
  State<DDTerminal> createState() => _DDTerminalState();
}

class _DDTerminalState extends State<DDTerminal>
    with AutomaticKeepAliveClientMixin {
  late TerminalLogic logic;

  final FocusNode node = FocusNode();
  final FocusNode node1 = FocusNode();

  final ValueNotifier<ActionKeyboard> actionKeyboard =
      ValueNotifier(ActionKeyboard.down);

  Host get value => ModalRoute.of(context)!.settings.arguments as Host;

  TextEditingController text = TextEditingController();

  @override
  void initState() {
    super.initState();
    logic = context.read<TerminalLogic>();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      FakeTerminalBackend('', '', '', '', actionKeyboard);
    });
  }

  @override
  void dispose() {
    node.dispose();
    node1.dispose();
    actionKeyboard.dispose();
    text.dispose();
    super.dispose();
  }

  void reset() {
    tamp = '';
    send = '';
    index = 0;
    count = 1;
  }

  void xuLyAction(ActionKeyboard action) {
    if (action == actionKeyboard.value) {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      actionKeyboard.notifyListeners();
    } else {
      actionKeyboard.value = action;
    }
  }

  static int count = 0;
  void xuLyActionMove(ActionKeyboard action) {
    switch (action) {
      case ActionKeyboard.left:
        if (count != text.text.length) {
          count++;
          text.selection =
              TextSelection.collapsed(offset: text.text.length - count);
        }
        break;
      default:
        if (count != 0) {
          count--;
          text.selection =
              TextSelection.collapsed(offset: text.text.length - count);
        }
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
            bottomAvoiderScrollPhysics: const ScrollPhysics(),
            tapOutsideBehavior: TapOutsideBehavior.none,
            keepFocusOnTappingNode: true,
            // autoScroll: false,
            // disableScroll: true,
            //bottomAvoiderScrollPhysics: const ScrollPhysics(),
            config: KeyboardActionsConfig(
              keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
              keyboardBarColor: Colors.grey,
              nextFocus: false,
              actions: [
                KeyboardActionsItem(
                  displayArrows: false,
                  focusNode: node,
                  displayDoneButton: false,
                  enabled: false,
                  toolbarButtons: [
                    (node) {
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (text.text.isNotEmpty) {
                                xuLyActionMove(ActionKeyboard.left);
                              }
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
                              if (text.text.isNotEmpty) {
                                xuLyActionMove(ActionKeyboard.right);
                              }
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
                              if (index != 0) {
                                text.text = '';
                                count = 0;
                                text.text = history[index];
                              } else {
                                text.text = tamp;
                              }
                              text.selection = TextSelection.collapsed(
                                  offset: text.text.length);
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
                              if (index != 0) {
                                text.text = '';
                                count = 0;
                                text.text = history[index];
                              } else {
                                text.text = tamp;
                              }
                              text.selection = TextSelection.collapsed(
                                  offset: text.text.length);
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: GetIt.instance.get<Helper>().heightKeyboard,
                    child: TerminalView(
                      autofocus: false,
                      padding: 5,
                      focusNode: node,
                      // enableSuggestions: true,
                      scrollController: ScrollController(),
                      scrollBehavior: const ScrollBehavior(),
                      style: const TerminalStyle(
                        fontFamily: ['Cascadia Mono'],
                        fontSize: 15,
                        ignoreBoldFlag: true,
                      ),
                      terminal: Terminal(
                          theme: TerminalThemes.whiteOnBlack,
                          backend: FakeTerminalBackend(value.host, value.port,
                              value.name, value.pass, actionKeyboard),
                          maxLines: 10000),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: double.infinity,
                      child: TextFormField(
                        autofocus: true,
                        focusNode: node,
                        showCursor: true,
                        autocorrect: false,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        //scrollPadding: const EdgeInsets.all(10),
                        textAlignVertical: TextAlignVertical.center,
                        controller: text,
                        cursorHeight: 18,
                        cursorColor: Colors.green,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              width: 2,
                            ),
                          ),
                        ),
                        onTap: () {
                          if (history.isEmpty) {
                            xuLyAction(ActionKeyboard.up);
                          }
                        },
                        onChanged: (value) {
                          if (history.isEmpty) {
                            xuLyAction(ActionKeyboard.up);
                          }
                          tamp = value;
                        },
                        onFieldSubmitted: (value) {
                          send = value;
                          text.clear();
                          xuLyAction(ActionKeyboard.send);
                        },
                        onEditingComplete: () {
                          reset();

                          //xuLyAction(ActionKeyboard.left);
                        },
                      )),
                ],
              ),
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

  void onGetHistory(String data) async {
    data = data.replaceAll('\n', '');
    history = data.split('\r').reversed.toList();
    //history = history.reversed.toList();
  }

  void onWriteAction(String data) {
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

  void getHistory() {
    //history = [];
    client.writeToShell('cat ~/.bash_history\n');
  }

  void khoiTaoConnect() async {
    try {
      result = await client.connect() ?? 'Null result';
      if (result == "session_connected") {
        result = await client.startShell(
                ptyType: "xterm",
                callback: (dynamic res) {
                  if (!isGetHistory) {
                    onWrite(res);
                  } else {
                    onGetHistory(res);
                  }
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
      cmd = '';
      return;
    }

    // if (countLeft > 0 || countRight > 0) {
    //   if (input.codeUnitAt(0) == 13) {
    //     for (var i = 0; i < cmd.length - countLeft; i++) {
    //       onWrite('\b');
    //     }

    //     connect(cmd);
    //   } else if (input.codeUnitAt(0) == 27) {
    //     if (cmd.isNotEmpty) {
    //       if (countLeft > 0) {
    //         String kiTuXoa = cmd[cmd.length - countLeft - 1];

    //         for (var i = 0; i < cmd.length; i++) {
    //           if (i == (cmd.length - countLeft - 1) && cmd[i] == kiTuXoa) {
    //             cmd = cmd.replaceFirst(cmd[i], '');
    //             break;
    //           }
    //         }
    //         String ex = cmd.substring(cmd.length - countLeft);
    //         _outStream.sink.add('\b \b' + ex + ' \b');

    //         for (var i = 0; i < ex.length; i++) {
    //           _outStream.sink.add('\b');
    //         }
    //       } else {
    //         _outStream.sink.add('\b \b');
    //         cmd = cmd.substring(0, cmd.length - 1);
    //       }
    //     }
    //   } else {
    //     if (input != '\r' &&
    //         input.codeUnitAt(0) != 127 &&
    //         input.codeUnitAt(0) != 27) {
    //       if (cmd[0] != cmd[1] || cmd.length > 2) {
    //         String ex = cmd.substring(cmd.length - countLeft);

    //         String b = input + ex;

    //         cmd = cmd.replaceAll(ex, b);

    //         _outStream.sink.add(input + ex);
    //         for (var i = 0; i < ex.length; i++) {
    //           _outStream.sink.add('\b');
    //         }
    //       } else if (cmd[0] == cmd[1] || cmd.length == 2) {
    //         String ex = cmd.substring(cmd.length - countLeft);
    //         String tamp = cmd[0];

    //         String b = input + ex;

    //         cmd = tamp + b;

    //         _outStream.sink.add(input + ex);
    //         for (var i = 0; i < ex.length; i++) {
    //           _outStream.sink.add('\b');
    //         }
    //       }
    //     }
    //   }
    // } else {
    //   if (input.codeUnitAt(0) == 13) {
    //     String clearCmt = cmd.replaceAll(RegExp(r'.'), '\b');
    //     _outStream.sink.add(clearCmt);
    //     connect(cmd);
    //   } else if (input.codeUnitAt(0) == 27) {
    //     if (cmd.isNotEmpty) {
    //       _outStream.sink.add('\b \b');
    //       cmd = cmd.substring(0, cmd.length - 1);
    //     }
    //   } else {
    //     if (input != '\r' &&
    //         input.codeUnitAt(0) != 127 &&
    //         input.codeUnitAt(0) != 27) {
    //       _outStream.sink.add(input);
    //       cmd += input;
    //     }
    //   }
    // }
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
        if (history.isEmpty) {
          getHistory();
        } else if (history.isNotEmpty) {
          if (index == history.length) {
            break;
          }
          index++;
        }
        if (history.isNotEmpty) {
          isGetHistory = false;
        } else {
          isGetHistory = true;
        }
        break;
      case ActionKeyboard.down:
        if (history.isEmpty) {
          getHistory();
        } else if (history.isNotEmpty) {
          if (index == 0) {
            break;
          }
          if (index < 0) {
            break;
          } else if (index > 0) {
            index--;
            if (index == 0) {
              break;
            }
          }
        }
        if (history.isNotEmpty) {
          isGetHistory = false;
        } else {
          isGetHistory = true;
        }
        break;

      case ActionKeyboard.send:
        connect(send);
        break;
      default:
      // getHistory();
    }
  }
}
