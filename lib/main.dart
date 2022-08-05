import 'package:dd_terminal/add_SSH/add_ssh.dart';
import 'package:dd_terminal/first_SSH/first_ssh.dart';
import 'package:dd_terminal/services/local_storage.dart';
import 'package:dd_terminal/terminal/terminal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

part 'services/app.dart';

void main() {
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
        // ChangeNotifierProvider(
        //   create: (context) => GetIt.instance.get<App>(),
        // ),
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
          '/DDterminal': (context) => const DDTerminal(),
        },
      ),
    );
  }
}
