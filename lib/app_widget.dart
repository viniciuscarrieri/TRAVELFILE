import 'package:flutter/material.dart';
import 'package:travelfile/app_controller.dart';
import 'package:travelfile/aviao_page.dart';
import 'package:travelfile/cad_aviao_page.dart';
import 'package:travelfile/cad_carro_page.dart';
import 'package:travelfile/cad_hotel_page.dart';
import 'package:travelfile/cad_ingressos_page.dart';
import 'package:travelfile/cad_seguro_page.dart';
import 'package:travelfile/cad_transfer_page.dart';
import 'package:travelfile/cadastro_pag.dart';
import 'package:travelfile/carro_page.dart';
import 'package:travelfile/home_page.dart';
import 'package:travelfile/hotel_page.dart';
import 'package:travelfile/ingressos_page.dart';
import 'package:travelfile/login_page.dart';
import 'package:travelfile/seguro_page.dart';
import 'package:travelfile/translado_page.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppController.instance,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness:
                AppController.instance.isDarkTheme
                    ? Brightness.dark
                    : Brightness.light,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => LoginPage(),
            '/home': (context) => HomePage(),
            '/cadastro': (context) => CadastroPage(),
            '/aviao': (context) => AviaoPage(),
            '/hotel': (context) => HotelPage(),
            '/translado': (context) => TransladoPage(),
            '/carro': (context) => CarroPage(),
            '/ingressos': (context) => IngressosPage(),
            '/seguro': (context) => SeguroPage(),
            '/cad_aviao': (context) => CadAviaoPage(),
            '/cad_hotel': (context) => CadHotelPage(),
            '/cad_translado': (context) => CadTransferPage(),
            '/cad_carro': (context) => CadCarroPage(),
            '/cad_ingressos': (context) => CadIngressosPage(),
            '/cad_seguro': (context) => CadSeguroPage(),
          },
        );
      },
    );
  }
}
