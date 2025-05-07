import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserConfigPage extends StatefulWidget {
  const UserConfigPage({super.key});

  @override
  State<UserConfigPage> createState() => _UserConfigPageState();
}

class _UserConfigPageState extends State<UserConfigPage> {
  final auth = FirebaseAuth.instance;

  String email = '';
  String uid = '';
  String name = '';
  String phone = '';

  Widget _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    TextField(
                      controller: TextEditingController(
                        text: uid = '${auth.currentUser!.uid}',
                      ),
                      enableInteractiveSelection: false,
                      decoration: InputDecoration(
                        labelText: 'ID do Usuário',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.content_copy,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: uid));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'ID copiado para a área de transferência',
                            ),
                          ),
                        );
                      },
                    ),
                    Container(height: 10),
                    TextField(
                      controller: TextEditingController(
                        text: '${auth.currentUser!.displayName}',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Nome do Usuário',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (text) {
                        name = text;
                      },
                    ),
                    Container(height: 10),
                    TextField(
                      controller: TextEditingController(
                        text: '${auth.currentUser!.email}',
                      ),
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (text) {
                        email = text;
                      },
                    ),
                    Container(height: 10),
                    TextField(
                      controller: TextEditingController(
                        text: '${auth.currentUser!.phoneNumber}',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Telefone',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (text) {
                        phone = text;
                      },
                    ), // Add more settings options here
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configurações do Usuário')),
      body: Stack(children: [_body()]),
    );
  }
}
