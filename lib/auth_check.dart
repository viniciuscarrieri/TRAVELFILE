import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:travelfile/app_theme.dart';
import 'package:travelfile/services/local_auth.service.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<bool> _authFailed = ValueNotifier(false);
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLocalAuth();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> checkLocalAuth() async {
    try {
      final auth = context.read<LocalAuthService>();
      final isAvailable = await auth.isBiometricAvailable();
      _authFailed.value = false;
      if (isAvailable) {
        final authenticated = await auth.autenticate();
        if (!authenticated) {
          _authFailed.value = true;
        } else {
          if (!mounted) return;
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      debugPrint('Erro geral na biometria: $e');
      _authFailed.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.softGradient),
        child: SafeArea(
          child: ValueListenableBuilder<bool>(
            valueListenable: _authFailed,
            builder: (context, failed, _) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo com animação pulse
                      ScaleTransition(
                        scale: failed
                            ? const AlwaysStoppedAnimation(1.0)
                            : _pulseAnim,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withAlpha(77),
                                blurRadius: 24,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Image.asset('assets/images/logo.png'),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        failed
                            ? 'Autenticação necessária'
                            : 'Autenticando...',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        failed
                            ? 'Use sua biometria para acessar o app'
                            : 'Aguarde um momento',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      if (!failed)
                        const CircularProgressIndicator(color: Colors.white)
                      else
                        GradientButton(
                          label: 'Tentar Novamente',
                          icon: Icons.fingerprint,
                          onPressed: checkLocalAuth,
                          width: 220,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
