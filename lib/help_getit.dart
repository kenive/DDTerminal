import 'package:dd_terminal/services/app_helper.dart';
//import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

Future<void> helperGetIt() async {
  var getIt = GetIt.instance;

  //getIt.registerLazySingleton<GlobalKey<NavigatorState>>(() => GlobalKey());
  getIt.registerLazySingleton<Helper>(() => Helper());

  return Future.value();
}
