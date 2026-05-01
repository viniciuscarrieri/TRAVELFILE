import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelfile/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      setState(() {
        _emailError = 'Digite seu e-mail';
        _isLoading = false;
      });
      return;
    }
    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Digite sua senha';
        _isLoading = false;
      });
      return;
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null && mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      if (e.code == 'invalid-email') {
        setState(() => _emailError = 'E-mail inválido');
      } else if (e.code == 'invalid-credential' ||
          e.code == 'wrong-password') {
        setState(() => _passwordError = 'Senha incorreta');
      } else if (e.code == 'user-not-found') {
        setState(() => _emailError = 'Usuário não encontrado');
      } else {
        _showErrorSnackBar('Erro ao entrar. Tente novamente.');
      }
    } catch (_) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Ocorreu um erro inesperado.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.danger,
      ),
    );
  }

  void _showForgotPassword() {
    final emailCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Recuperar Senha'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Digite seu e-mail para receber o link de redefinição.',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailCtrl.text.trim().isNotEmpty) {
                await _auth.sendPasswordResetEmail(
                  email: emailCtrl.text.trim(),
                );
                if (ctx.mounted) {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('E-mail de recuperação enviado!')),
                  );
                }
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.softGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Hero(
                        tag: 'logo',
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                            boxShadow: AppTheme.elevatedShadow,
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'TravelFile',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Seus documentos de viagem, sempre à mão',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 36),

                      // Card do formulário
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                          boxShadow: AppTheme.elevatedShadow,
                        ),
                        padding: const EdgeInsets.all(28),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bem-vindo de volta 👋',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Faça login para continuar',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 24),

                              // Campo e-mail
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'E-mail',
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: AppTheme.accent,
                                  ),
                                  errorText: _emailError,
                                ),
                                onChanged: (_) =>
                                    setState(() => _emailError = null),
                              ),
                              const SizedBox(height: 16),

                              // Campo senha
                              TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Senha',
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: AppTheme.accent,
                                  ),
                                  errorText: _passwordError,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: AppTheme.textSecondary,
                                    ),
                                    onPressed: () => setState(
                                      () => _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                ),
                                onChanged: (_) =>
                                    setState(() => _passwordError = null),
                                onSubmitted: (_) => _handleLogin(),
                              ),
                              const SizedBox(height: 8),

                              // Esqueci a senha
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _showForgotPassword,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text('Esqueci minha senha'),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Botão Login
                              GradientButton(
                                label: 'Entrar',
                                icon: Icons.login_rounded,
                                onPressed: _handleLogin,
                                isLoading: _isLoading,
                              ),
                              const SizedBox(height: 16),

                              // Botão Cadastrar
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: OutlinedButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushReplacementNamed('/cad_metodo_login'),
                                  child: const Text('Criar conta'),
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
            ),
          ),
        ),
      ),
    );
  }
}
