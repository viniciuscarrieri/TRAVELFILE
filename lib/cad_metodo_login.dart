import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travelfile/google_login.dart';
import 'dart:io' show Platform;

class CadMetodoLogin extends StatefulWidget {
  const CadMetodoLogin({super.key});

  @override
  State<CadMetodoLogin> createState() => _CadMetodoLoginState();
}

class _CadMetodoLoginState extends State<CadMetodoLogin> {
  FirebaseAuth auth = FirebaseAuth.instance;

  Widget _body() {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      if (Platform.isAndroid)
                        ElevatedButton(
                          onPressed: () async {
                            await GoogleAuthController().signInWithGoogle();
                            if (auth.currentUser != null) {
                              Navigator.of(
                                // ignore: use_build_context_synchronously
                                context,
                              ).pushReplacementNamed('/home');
                            } else {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Erro ao autenticar com o Google. Tente novamente.',
                                  ),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/google_pb.png',
                                width: 25,
                                height: 25,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Cadastro Google',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      if (Platform.isIOS)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.apple, size: 30),
                              SizedBox(width: 13),
                              Text(
                                'Cadastro Apple',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/cadastro');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.email, size: 30),
                            SizedBox(width: 13),
                            Text(
                              'Cadastro Email',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.undo, size: 30),
                            SizedBox(width: 13),
                            Text('Voltar', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [_body()]));
  }
}
