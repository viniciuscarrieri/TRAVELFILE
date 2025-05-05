import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travelfile/app_controller.dart';
import 'package:travelfile/aviao_page.dart';
import 'package:travelfile/carro_page.dart';
import 'package:travelfile/hotel_page.dart';
import 'package:travelfile/ingressos_page.dart';
import 'package:travelfile/seguro_page.dart';
import 'package:travelfile/translado_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int indiceAtual = 0;

  final auth = FirebaseAuth.instance;

  static const List<Widget> _widgetOptions = <Widget>[
    AviaoPage(),
    HotelPage(),
    TransladoPage(),
    CarroPage(),
    IngressosPage(),
    SeguroPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Container(
          child:
              auth.currentUser!.displayName != null
                  ? Text('Bem-vindo ${auth.currentUser!.displayName}')
                  : Text('Bem-vindo'),
        ),
        actions: [
          PopupMenuButton(
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.asset('assets/images/logo.png'),
            ),
            itemBuilder:
                (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(Icons.settings, color: Colors.black),
                        const SizedBox(width: 7),
                        Text("Configurações Usuário"),
                      ],
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.privacy_tip, color: Colors.black),
                        const SizedBox(width: 7),
                        Text("Politica de Privacidade"),
                      ],
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.black),
                        const SizedBox(width: 7),
                        Text("Sair"),
                      ],
                    ),
                  ),
                ],
            onSelected: (item) => {SelectedItem(context, item)},
          ),
        ],
        //actions: [CustomSwitch()], color: const Color(0xFF0000FF),
      ),
      body: _widgetOptions.elementAt(indiceAtual),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.airplanemode_active, size: 40),
            label: 'Aéreo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel, size: 40),
            label: 'Hotel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus, size: 40),
            label: 'Transfer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car, size: 40),
            label: 'Carro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number, size: 40),
            label: 'Ingressos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism, size: 40),
            label: 'Seguro',
          ),
        ],
        currentIndex: indiceAtual,
        selectedItemColor: Colors.blue[900],
        onTap: onTabTapped,
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      indiceAtual = index;
    });
  }
}

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: AppController.instance.isDarkTheme,
      onChanged: (value) {
        AppController.instance.changeTheme();
      },
    );
  }
}

void SelectedItem(BuildContext context, item) {
  switch (item) {
    case 0:
      print("Configurações Usuário");
      Navigator.of(context).pushNamed('/user_config');
      break;
    case 1:
      print("Privacy Clicked");
      break;
    case 2:
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Sair"),
              content: Text("Deseja realmente sair?"),
              actions: [
                TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  child: Text("Sim"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Não"),
                ),
              ],
            ),
      );
      //Navigator.of(context).pushReplacementNamed('/');
      break;
  }
}
