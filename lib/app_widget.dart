import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travelfile/app_controller.dart';
import 'package:travelfile/app_theme.dart';
import 'package:travelfile/auth_check.dart';
import 'package:travelfile/aviao_page.dart';
import 'package:travelfile/cad_aviao_page.dart';
import 'package:travelfile/cad_carro_page.dart';
import 'package:travelfile/cad_hotel_page.dart';
import 'package:travelfile/cad_ingressos_page.dart';
import 'package:travelfile/cad_metodo_login.dart';
import 'package:travelfile/cad_seguro_page.dart';
import 'package:travelfile/cad_transfer_page.dart';
import 'package:travelfile/cadastro_pag.dart';
import 'package:travelfile/carro_page.dart';
import 'package:travelfile/change_password.dart';
import 'package:travelfile/home_page.dart';
import 'package:travelfile/hotel_page.dart';
import 'package:travelfile/ingressos_page.dart';
import 'package:travelfile/login_page.dart';
import 'package:travelfile/permission.dart';
import 'package:travelfile/seguro_page.dart';
import 'package:travelfile/translado_page.dart';
import 'package:travelfile/user_config.dart';
import 'package:travelfile/google_plataform.dart';
import 'package:travelfile/premium_page.dart';

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
          title: 'TravelFile',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: AppController.instance.isDarkTheme
              ? ThemeMode.dark
              : ThemeMode.light,
          initialRoute: FirebaseAuth.instance.currentUser != null ? '/home' : '/',
          routes: {
            '/': (context) => const LoginPage(),
            '/authCheck': (context) => const AuthCheck(),
            '/home': (context) => const HomePage(),
            '/cad_metodo_login': (context) => CadMetodoLogin(),
            '/cadastro': (context) => const CadastroPage(),
            '/aviao': (context) => const AviaoPage(),
            '/hotel': (context) => const HotelPage(),
            '/translado': (context) => const TransladoPage(),
            '/carro': (context) => const CarroPage(),
            '/ingressos': (context) => const IngressosPage(),
            '/seguro': (context) => const SeguroPage(),
            '/cad_aviao': (context) => const CadAviaoPage(),
            '/cad_hotel': (context) => const CadHotelPage(),
            '/cad_translado': (context) => const CadTransferPage(),
            '/cad_carro': (context) => const CadCarroPage(),
            '/cad_ingressos': (context) => const CadIngressosPage(),
            '/cad_seguro': (context) => const CadSeguroPage(),
            '/user_config': (context) => const UserConfigPage(),
            '/change_password': (context) => const ChangePasswordPage(),
            '/permission': (context) => PermissionPag(),
            '/google_plataform': (context) => SignInDemo(),
            '/premium': (context) => const PremiumPage(),
          },
        );
      },
    );
  }
}
