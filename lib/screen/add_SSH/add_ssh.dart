import 'package:dd_terminal/model/host/host.dart';
import 'package:dd_terminal/screen/first_SSH/first_ssh.dart';
import 'package:dd_terminal/services/database_helper.dart';
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
            elevation: 0,
            bottomOpacity: 0,
            backgroundColor: const Color(0xFF415584),
            title: const Text('Thêm host mới'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero),
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
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                          keyboardType: TextInputType.number,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Username',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero),
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Password',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Selector<AddSSHLogic, bool>(
                        selector: (p0, p1) => p1.passwordVisible,
                        builder: (context, value, child) {
                          return SizedBox(
                            width: 200,
                            height: 50,
                            child: TextFormField(
                              obscureText: value,
                              textAlignVertical: TextAlignVertical.bottom,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  suffixIcon: InkWell(
                                    splashColor: Colors.white,
                                    onTap: () {
                                      add.checkPasswordVisible();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Icon(value
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                  )),
                              controller: add.pass,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF5A85F4), // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () {
                          add.submit();
                        },
                        child: const Text('Lưu'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () {
                          add.cancel();
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
