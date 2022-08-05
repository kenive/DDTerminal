import 'package:dd_terminal/first_SSH/first_ssh.dart';
import 'package:dd_terminal/model/host/host.dart';
import 'package:dd_terminal/services/local_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'add_ssh_logic.dart';

class AddSSH extends StatefulWidget {
  const AddSSH({Key? key}) : super(key: key);

  @override
  State<AddSSH> createState() => _AddSSHState();
}

class _AddSSHState extends State<AddSSH> {
  late AddSSHLogic add;
  @override
  void initState() {
    super.initState();
    add = AddSSHLogic(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: add,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Thêm host mới'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TP/Host',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: TextFormField(
                          controller: add.host,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Port',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: TextFormField(
                          controller: add.port,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'UserName',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: TextFormField(
                            controller: add.name,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ]),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Password',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: TextFormField(
                          controller: add.pass,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            add.submit();
                          });
                        },
                        child: const Text('Lưu'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            add.cancel();
                          });
                        },
                        child: const Text('Hủy'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
