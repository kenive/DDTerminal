import 'package:dd_terminal/model/host/host.dart';
import 'package:dd_terminal/screen/first_SSH/first_ssh.dart';
import 'package:dd_terminal/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'update_ssh_logic.dart';

class UpdateSSH extends StatefulWidget {
  const UpdateSSH({Key? key}) : super(key: key);

  @override
  State<UpdateSSH> createState() => _UpdateSSHState();
}

class _UpdateSSHState extends State<UpdateSSH> {
  late UpdateSshLogic update;
  @override
  void initState() {
    super.initState();
    update = UpdateSshLogic(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: update,
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
            title: const Text('Cập nhật host'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          controller: update.host,
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
                          controller: update.port,
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
                            controller: update.name,
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
                      Selector<UpdateSshLogic, bool>(
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
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: InkWell(
                                        splashColor: Colors.white,
                                        onTap: () {
                                          update.checkPasswordVisible();
                                        },
                                        child: Icon(value
                                            ? Icons.visibility_off
                                            : Icons.visibility)),
                                  )),
                              controller: update.pass,
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
                        ),
                        onPressed: () {
                          update.submit();
                        },
                        child: const Text('Cập nhật'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        onPressed: () {
                          update.cancel();
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
