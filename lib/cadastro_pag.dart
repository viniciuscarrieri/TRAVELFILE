import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelfile/app_theme.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage>
    with SingleTickerProviderStateMixin {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  String? _nomeError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

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
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nomeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool valid = true;
    setState(() {
      _nomeError = _nomeController.text.trim().isEmpty ? 'Digite seu nome' : null;
      _emailError = _emailController.text.trim().isEmpty ? 'Digite seu e-mail' : null;
      _passwordError = _passwordController.text.length < 6
          ? 'Mínimo de 6 caracteres'
          : null;
      _confirmError = _passwordController.text != _confirmPasswordController.text
          ? 'As senhas não coincidem'
          : null;
    });
    if (_nomeError != null || _emailError != null ||
        _passwordError != null || _confirmError != null) {
      valid = false;
    }
    return valid;
  }

  Future<void> _handleCadastro() async {
    if (!_validate()) return;
    setState(() => _isLoading = true);
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      await credential.user!.updateProfile(
        displayName: _nomeController.text.trim(),
      );
      // Salva dados no Firestore — sem senha plain text
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(credential.user!.uid)
          .set({
        'uid': credential.user!.uid,
        'LoginMetodo': 'Email-Senha',
        'nome': _nomeController.text.trim(),
        'email': _emailController.text.trim(),
        'dataCadastro': DateTime.now(),
        'status': 'ativo',
        'isPremium': false,
      });
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conta criada com sucesso! 🎉')),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      if (e.code == 'email-already-in-use') {
        setState(() => _emailError = 'Este e-mail já está em uso');
      } else if (e.code == 'invalid-email') {
        setState(() => _emailError = 'E-mail inválido');
      } else if (e.code == 'weak-password') {
        setState(() => _passwordError = 'Senha muito fraca');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${e.message}'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
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
                    children: [
                      // Logo pequeno
                      Hero(
                        tag: 'logo',
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                            boxShadow: AppTheme.elevatedShadow,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Criar Conta',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Preencha seus dados abaixo',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Card formulário
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusXL),
                          boxShadow: AppTheme.elevatedShadow,
                        ),
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildField(
                              controller: _nomeController,
                              label: 'Nome completo',
                              icon: Icons.person_outline,
                              error: _nomeError,
                              onChanged: (_) => setState(() => _nomeError = null),
                            ),
                            const SizedBox(height: 16),
                            _buildField(
                              controller: _emailController,
                              label: 'E-mail',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              error: _emailError,
                              onChanged: (_) => setState(() => _emailError = null),
                            ),
                            const SizedBox(height: 16),
                            _buildField(
                              controller: _passwordController,
                              label: 'Senha',
                              icon: Icons.lock_outline,
                              obscure: _obscurePassword,
                              error: _passwordError,
                              onChanged: (_) =>
                                  setState(() => _passwordError = null),
                              toggleObscure: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildField(
                              controller: _confirmPasswordController,
                              label: 'Confirmar Senha',
                              icon: Icons.lock_outline,
                              obscure: _obscureConfirm,
                              error: _confirmError,
                              onChanged: (_) =>
                                  setState(() => _confirmError = null),
                              toggleObscure: () => setState(
                                () => _obscureConfirm = !_obscureConfirm,
                              ),
                            ),
                            const SizedBox(height: 24),
                            GradientButton(
                              label: 'Criar conta',
                              icon: Icons.person_add_rounded,
                              onPressed: _handleCadastro,
                              isLoading: _isLoading,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context)
                                    .pushReplacementNamed('/'),
                                child: const Text('Já tenho conta'),
                              ),
                            ),
                          ],
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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? error,
    bool obscure = false,
    TextInputType? keyboardType,
    VoidCallback? toggleObscure,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.accent),
        errorText: error,
        suffixIcon: toggleObscure != null
            ? IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppTheme.textSecondary,
                ),
                onPressed: toggleObscure,
              )
            : null,
      ),
    );
  }
}
