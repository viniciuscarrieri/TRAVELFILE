import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelfile/app_theme.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage>
    with SingleTickerProviderStateMixin {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(_newPasswordController.text);
        if (mounted) {
          _showSuccessSnackBar('Senha alterada com sucesso!');
          Navigator.of(context).pop();
        }
      } else {
        _showErrorSnackBar('Usuário não autenticado.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _showErrorSnackBar('Esta operação requer um login recente. Por favor, saia e entre novamente.');
      } else if (e.code == 'weak-password') {
        _showErrorSnackBar('A senha digitada é muito fraca.');
      } else {
        _showErrorSnackBar('Erro ao alterar senha: ${e.message}');
      }
    } catch (e) {
      _showErrorSnackBar('Ocorreu um erro inesperado.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar Senha'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.primaryDark,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, AppTheme.surfaceLight],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Crie uma nova senha segura 🔒',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sua nova senha deve ter pelo menos 6 caracteres.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 32),

                      // Campo Nova Senha
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: _obscureNewPassword,
                        decoration: InputDecoration(
                          labelText: 'Nova Senha',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppTheme.accent,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureNewPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppTheme.textSecondary,
                            ),
                            onPressed: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Digite a nova senha';
                          if (value.length < 6) return 'A senha deve ter pelo menos 6 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo Confirmar Senha
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirmar Nova Senha',
                          prefixIcon: const Icon(
                            Icons.lock_reset_outlined,
                            color: AppTheme.accent,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppTheme.textSecondary,
                            ),
                            onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Confirme a nova senha';
                          if (value != _newPasswordController.text) return 'As senhas não coincidem';
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),

                      // Botão Alterar
                      GradientButton(
                        label: 'Alterar Senha',
                        icon: Icons.update_rounded,
                        onPressed: _handleChangePassword,
                        isLoading: _isLoading,
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
