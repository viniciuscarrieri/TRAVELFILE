import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_network_ios/flutter_local_network_ios.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ignore: unused_field
  String _platformVersion = 'Unknown';
  final _flutterLocalNetworkIosPlugin = FlutterLocalNetworkIos();

  @override
  void initState() {
    super.initState();
    //_checkAndRequestPermissions();
    _checkAndRequestNetworkPermission();
    _initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initPlatformState() async {
    // ignore: unused_element
    bool? result = await _flutterLocalNetworkIosPlugin.requestAuthorization();
    print("result  $result");
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _flutterLocalNetworkIosPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
    print("$platformVersion");
  }

  // ignore: unused_element
  Future<void> _checkAndRequestPermissions() async {
    final status = await Permission.manageExternalStorage.status;
    if (status.isGranted) {
      await Permission.manageExternalStorage.request();
      // Permissão já concedida, você pode acessar o armazenamento externo
      print('Permissão de armazenamento externo já concedida');
    } else {
      await _requestStoragePermission();
    }
  }

  Future<void> _requestStoragePermission() async {
    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      await Permission.manageExternalStorage.request();
      // Permissão concedida, você pode acessar o armazenamento externo
      print('Permissão de armazenamento externo concedida');
    } else if (status.isDenied) {
      // ignore: unused_element
      showAboutDialog(context) async => {
        await Permission.manageExternalStorage.request(),
        await Permission.storage.request(),
      };
      // Permissão negada, informe o usuário
      print('Permissão de armazenamento externo negada');
    } else if (status.isPermanentlyDenied) {
      // ignore: unused_element
      showAboutDialog(context) async => {
        await Permission.manageExternalStorage.request(),
        await Permission.storage.request(),
      };
      // Permissão permanentemente negada, abra as configurações
      print('Permissão de armazenamento externo permanentemente negada');
    }
  }

  // ignore: unused_element
  Future<void> _checkAndRequestNetworkPermission() async {
    final status = await Permission.phone.status; // Ou Permission.location
    if (status.isGranted) {
      await Permission.phone.request(); // Ou Permission.location
      await Permission.locationWhenInUse.request();
      // Permissão já concedida, você pode acessar a rede
      print('Permissão de rede já concedida');
    } else {
      // Permissão não concedida, solicite-a
      await _requestNetworkPermission();
    }
  }

  Future<void> _requestNetworkPermission() async {
    // ignore: unused_element
    showAboutDialog(context) async => {
      await Permission.phone.request(), // Ou Permission.location
      await Permission.locationWhenInUse.request(),
    }; // Ou Permission.location
    final status = await Permission.phone.request();
    if (status.isGranted) {
      await Permission.phone.request(); // Ou Permission.location
      await Permission.locationWhenInUse.request();
      // Permissão concedida, você pode acessar a rede
      print('Permissão de rede concedida');
    } else if (status.isDenied) {
      // ignore: unused_element
      showAboutDialog(context) async => {
        await Permission.phone.request(), // Ou Permission.location
        await Permission.locationWhenInUse.request(),
      };
      // Permissão negada, informe o usuário
      print('Permissão de rede negada');
    } else if (status.isPermanentlyDenied) {
      // ignore: unused_element
      showAboutDialog(context) async => {
        await Permission.phone.request(), // Ou Permission.location
        await Permission.locationWhenInUse.request(),
      };
      // Permissão permanentemente negada, abra as configurações
      print('Permissão de rede permanentemente negada');
    }
  }

  void requestPermission() async {
    final statusManage = await Permission.manageExternalStorage.request();
    if (!statusManage.isGranted) {
      // ignore: unused_element
      showAboutDialog(context) async => {
        await Permission.manageExternalStorage.request(),
      };
    } else if (statusManage.isDenied) {
      debugPrint("Permissão negada");
    } else if (statusManage.isPermanentlyDenied) {
      debugPrint("Permissão permanentemente negada");
    }

    final statusStorage = await Permission.storage.request();
    if (!statusStorage.isGranted) {
      // ignore: unused_element
      showAboutDialog(context) async => {
        await Permission.storage.request(),
        debugPrint("Permissão de armazenamento concedida"),
      };
      await Permission.storage.request();
    } else if (statusStorage.isDenied) {
      // ignore: unused_element
      showAboutDialog(context) async => {
        await Permission.manageExternalStorage.request(),
      };
      debugPrint("Permissão negada");
    } else if (statusStorage.isPermanentlyDenied) {
      debugPrint("Permissão permanentemente negada");
    }

    final statusCamera = await Permission.camera.request();
    if (statusCamera.isGranted) {
      // ignore: unused_element
      showAboutDialog(context) async => {
        await Permission.camera.request(),
        debugPrint("Permissão de armazenamento concedida"),
      };
    } else if (statusCamera.isDenied) {
      debugPrint("Permissão negada");
    } else if (statusCamera.isPermanentlyDenied) {
      debugPrint("Permissão permanentemente negada");
    }

    final statusLocation = await Permission.location.request();
    if (statusLocation.isGranted) {
      // ignore: unused_element
      showAboutDialog(context) async => {
        await Permission.location.request(),
        debugPrint("Permissão de armazenamento concedida"),
      };
      await Permission.location.request();
    } else if (statusLocation.isDenied) {
      debugPrint("Permissão negada");
    } else if (statusLocation.isPermanentlyDenied) {
      debugPrint("Permissão permanentemente negada");
    }

    final statusNotification = await Permission.notification.request();
    if (statusNotification.isGranted) {
      // ignore: unused_element
      showAboutDialog(context) async => {
        await Permission.notification.request(),
        debugPrint("Permissão de armazenamento concedida"),
      };
      await Permission.notification.request();
    } else if (statusNotification.isDenied) {
      debugPrint("Permissão negada");
    } else if (statusNotification.isPermanentlyDenied) {
      debugPrint("Permissão permanentemente negada");
    }

    final statusRede = await Permission.locationWhenInUse.status;
    if (statusRede.isGranted) {
      // ignore: unused_element
      showAboutDialog(context) async => {
        await Permission.locationWhenInUse.request(),
        debugPrint("Permissão de armazenamento concedida"),
      };
      await Permission.locationWhenInUse.request();
    } else if (statusRede.isDenied) {
      // ignore: unused_element
      showAboutDialog(context) async => {
        await Permission.locationWhenInUse.request(),
        debugPrint("Permissão de armazenamento concedida"),
      };
      debugPrint("Permissão de rede negada");
    } else if (statusRede.isPermanentlyDenied) {
      // ignore: avoid_print
      // Permissão permanentemente negada
      // Leve o usuário para as configurações do dispositivo
    }
  }

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
                      Navigator.of(
                        context,
                      ).pushReplacementNamed('/cad_metodo_login');
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
                                // ignore: non_constant_identifier_names
                                (UserCredential) => {
                                  if (UserCredential.user != null)
                                    {
                                      Navigator.of(
                                        // ignore: use_build_context_synchronously
                                        context,
                                      ).pushReplacementNamed('/home'),
                                    }
                                  else
                                    {debugPrint('Login Inválido')},
                                },
                              );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == "invalid-email") {
                            showDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text("email Inválido"),
                                    content: Text(
                                      "Verifique seu email e tente novamente!!!",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop('/');
                                        },
                                        child: Text("OK"),
                                      ),
                                    ],
                                  ),
                            );
                          } else if (e.code == "invalid-credential") {
                            showDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text("Senha Inválida"),
                                    content: Text(
                                      "Verifique sua senha e tente novamente!!!",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop('/');
                                        },
                                        child: Text("OK"),
                                      ),
                                    ],
                                  ),
                            );
                          } else if (e.code == "channel-error") {
                            showDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text("Campos vazios"),
                                    content: Text(
                                      "Digite seu email e senha e tente novamente!!!",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop('/');
                                        },
                                        child: Text("OK"),
                                      ),
                                    ],
                                  ),
                            );
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
