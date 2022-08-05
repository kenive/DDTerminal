import 'package:dd_terminal/model/host/host.dart';
import 'package:dd_terminal/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'first_ssh_logic.dart';

class FirstSSH extends StatefulWidget {
  const FirstSSH({Key? key}) : super(key: key);

  @override
  State<FirstSSH> createState() => _FirstSSHState();
}

class _FirstSSHState extends State<FirstSSH> {
  late FirstSSHLogic logic;
  @override
  void initState() {
    super.initState();
    logic = FirstSSHLogic(context: context);
    //GetIt.instance<App>().middleWare();
    logic.getData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: logic,
      child: Consumer<FirstSSHLogic>(
        builder: (context, value, child) {
          return Scaffold(
              appBar: AppBar(
                bottomOpacity: 0,
                backgroundColor: Colors.white,
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/add_ssh');
                        },
                        child: const Icon(
                          Icons.add,
                          size: 30,
                        )),
                  )
                ],
              ),
              backgroundColor: Colors.white,
              body: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: Selector<FirstSSHLogic, List<Host>>(
                      selector: (p0, p1) => p1.data,
                      builder: (context, value, child) {
                        if (value.isEmpty) {
                          return const Center(
                            child: Text('Không có host'),
                          );
                        }
                        return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/DDterminal');
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(
                                          value[index].name,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 30,
                                                )),
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    logic.delete();
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.cancel,
                                                  size: 30,
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
              ));
        },
      ),
    );
  }
}
