import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  String nome = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

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
              Container(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (text) {
                          nome = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        onChanged: (text) {
                          email = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        onChanged: (text) {
                          password = text;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        onChanged: (text) {
                          confirmPassword = text;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirma Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    child: Text('Voltar'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (password == confirmPassword) {
                        try {
                          auth
                              .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              )
                              .then(
                                (UserCredential) => {
                                  UserCredential.user!.updateProfile(
                                    displayName: nome,
                                  ),
                                  FirebaseFirestore.instance
                                      .collection('usuarios')
                                      .doc(
                                        FirebaseAuth.instance.currentUser!.uid,
                                      )
                                      .set({
                                        'uid': auth.currentUser!.uid,
                                        'nome': nome,
                                        'email': email,
                                        'senha': password,
                                        'dataCadastro': DateTime.now(),
                                        'status': 'ativo',
                                      }),
                                  Navigator.of(
                                    context,
                                  ).pushReplacementNamed('/'),
                                },
                              );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == "invalid-email") {
                            debugPrint("Digite um email válido");
                          } else if (e.code == "invalid-credential") {
                            debugPrint("Digite a senha Correta!");
                          } else if (e.code == "channel-error") {
                            debugPrint("Campo vazio!");
                          }
                          debugPrint("Mensagem pega ${e.message}");
                          debugPrint("Código pego ${e.code}");
                        }
                      }
                    },
                    child: Text('Cadastrar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /* SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
          ),*/
          _body(),
        ],
      ),
    );
  }
}
