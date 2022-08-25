import 'package:dd_terminal/help_getit.dart';
import 'package:dd_terminal/screen/add_SSH/add_ssh.dart';
import 'package:dd_terminal/screen/first_SSH/first_ssh.dart';
import 'package:dd_terminal/screen/terminal/terminal.dart';
import 'package:dd_terminal/screen/update_SSH/update_ssh.dart';
import 'package:dd_terminal/services/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();

  await helperGetIt();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GetIt.instance.get<Helper>(),
        ),
        ChangeNotifierProvider(create: (_) => TerminalLogic(context: context)),
        ChangeNotifierProvider(create: (_) => FirstSSHLogic(context: context)),
        ChangeNotifierProvider(create: (_) => AddSSHLogic(context: context))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DDTerminal',
        initialRoute: '/',
        routes: {
          '/': (context) => const FirstSSH(),
          '/add_ssh': (context) => const AddSSH(),
          '/update_ssh': (context) => const UpdateSSH(),
          '/DDterminal': (context) => const DDTerminal(),
        },
      ),
    );
  }
}
