import 'package:dd_terminal/model/host/host.dart';
import 'package:dd_terminal/services/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

part 'first_ssh_logic.dart';

class FirstSSH extends StatefulWidget {
  const FirstSSH({Key? key}) : super(key: key);

  @override
  State<FirstSSH> createState() => _FirstSSHState();
}

class _FirstSSHState extends State<FirstSSH>
    with AutomaticKeepAliveClientMixin {
  late FirstSSHLogic logic;
  @override
  void initState() {
    super.initState();
    logic = FirstSSHLogic(context: context);
  }

  @override
  void dispose() {
    super.dispose();
    logic.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
        value: logic,
        child: GestureDetector(
          child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                bottomOpacity: 0,
                automaticallyImplyLeading: false,
                backgroundColor: const Color(0xFF415584),
                actions: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60),
                                    side: const BorderSide(
                                        color: Color(0xFF5A85F4))))),
                        onPressed: () {
                          Navigator.pushNamed(context, '/add_ssh');
                        },
                        child: const Icon(
                          Icons.add,
                          size: 35,
                          color: Color(0xFF5A85F4),
                        )),
                  )
                ],
              ),
              backgroundColor: const Color(0xFF415584),
              body: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: Selector<FirstSSHLogic, Tuple2<List<Host>, bool>>(
                      selector: (p0, p1) => Tuple2(p1.data, p1.checkData),
                      builder: (context, value, child) {
                        if (!value.item2) {
                          return const Center(
                            child: Text(
                              'Nhấp vào + để thêm host mới',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                        if (value.item1.isEmpty) {
                          return const Center(
                              child: CupertinoActivityIndicator(
                            radius: 25,
                            color: Colors.white,
                          ));
                        }

                        return ListView.builder(
                          itemCount: value.item1.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/DDterminal',
                                    arguments: value.item1[index]);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 0.5, color: Colors.black),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(
                                          value.item1[index].host,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                      context, '/update_ssh',
                                                      arguments:
                                                          value.item1[index]);
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 30,
                                                  color: Color(0xFFFFC857),
                                                )),
                                            IconButton(
                                                onPressed: () async {
                                                  logic.delete(
                                                      value.item1[index].id!);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              'Xóa thành công')));
                                                },
                                                icon: const Icon(
                                                  Icons.cancel,
                                                  size: 30,
                                                  color: Color(0xFFFE5F55),
                                                )),
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              )),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
