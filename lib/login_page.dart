import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';

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
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/cadastro');
                    },
                    child: Text('Cadastrar'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (email != '' && password != '') {
                        try {
                          // Attempt to sign in the user in with Google
                          await auth
                              .signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              )
                              .then(
                                (UserCredential) => {
                                  if (UserCredential.user != null)
                                    {
                                      Navigator.of(
                                        context,
                                      ).pushReplacementNamed('/home'),
                                    }
                                  else
                                    {debugPrint('Login Inválido')},
                                  AlertDialog(
                                    title: Text('Login Inválido'),
                                    content: Text(
                                      'Verifique seu email e senha e tente novamente.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop('/');
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
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
                    child: Text('Login'),
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
