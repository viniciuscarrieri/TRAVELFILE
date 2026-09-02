import 'package:flutter/material.dart';
import 'package:travelfile/app_controller.dart';
import 'package:travelfile/app_theme.dart';
import 'package:travelfile/auth_check.dart';
import 'package:travelfile/aviao_page.dart';
import 'package:travelfile/cad_aviao_page.dart';
import 'package:travelfile/cad_hotel_page.dart';
import 'package:travelfile/cad_metodo_login.dart';
import 'package:travelfile/cadastro_pag.dart';
import 'package:travelfile/carro_page.dart';
import 'package:travelfile/change_password.dart';
import 'package:travelfile/core/constants/app_routes.dart';
import 'package:travelfile/google_plataform.dart';
import 'package:travelfile/home_page.dart';
import 'package:travelfile/hotel_page.dart';
import 'package:travelfile/ingressos_page.dart';
import 'package:travelfile/login_page.dart';
import 'package:travelfile/permission.dart';
import 'package:travelfile/poli_privacidade.dart';
import 'package:travelfile/premium_page.dart';
import 'package:travelfile/seguro_page.dart';
import 'package:travelfile/splash_page.dart';
import 'package:travelfile/translado_page.dart';
import 'package:travelfile/user_config.dart';

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
          themeMode:
              AppController.instance.isDarkTheme
                  ? ThemeMode.dark
                  : ThemeMode.light,
          initialRoute: AppRoutes.splash,
          routes: {
            AppRoutes.splash: (context) => const SplashPage(),
            AppRoutes.login: (context) => const LoginPage(),
            AppRoutes.authCheck: (context) => const AuthCheck(),
            AppRoutes.home: (context) => const HomePage(),
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
            AppRoutes.userConfig: (context) => const UserConfigPage(),
            AppRoutes.changePassword: (context) => const ChangePasswordPage(),
            AppRoutes.permission: (context) => PermissionPag(),
            AppRoutes.googlePlatform: (context) => SignInDemo(),
            AppRoutes.premium: (context) => const PremiumPage(),
            AppRoutes.privacyPolicy: (context) => const PoliPrivacidadePage(),
          },
        );
      },
    );
  }
}
