// import 'dart:convert';

// import 'package:dd_terminal/model/host/host.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LocalStorage {
//   static final LocalStorage _instance = LocalStorage._();

//   //key storage

//   SharedPreferences? pref;

//   SharedPreferences get store => pref!;

//   LocalStorage._();

//   factory LocalStorage() => _instance;

//   static LocalStorage get instance => _instance;

//   //String get token => store.getString(LocalStorage.acToken) ?? '';

//   static Future<void> init() async {
//     instance.pref ??= await SharedPreferences.getInstance();

//     return Future.value();
//   }

//   List<String> lst = [];

//   setHost(Host ip) {
//     setLst();
//     return store.setStringList('lst', [jsonEncode(ip.toJson())]);
//     //return store.setString('host', jsonEncode(ip.toJson()));
//   }

//   setLst() {
//     return store.setStringList('nguyen', lst);
//   }

//   setListHost(Host ip) {}

//   Host get lstHost {
//     String lstHost = store.getString('host') ?? '';

//     return lstHost.isNotEmpty
//         ? Host.fromJson(jsonDecode(lstHost))
//         : Host.fromJson(jsonDecode(''));
//   }

//   List<Host> get lstHost1 {
//     List<String> lstHost1 = store.getStringList('lst') ?? [];

//     List<Host> a = [];
//     for (var item in lstHost1) {
//       a.add(Host.fromJson(jsonDecode(item)));
//     }

//     return a;
//   }
// }
