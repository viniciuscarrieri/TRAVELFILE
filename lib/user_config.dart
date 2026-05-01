import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelfile/app_theme.dart';

class UserConfigPage extends StatefulWidget {
  const UserConfigPage({super.key});

  @override
  State<UserConfigPage> createState() => _UserConfigPageState();
}

class _UserConfigPageState extends State<UserConfigPage> {
  final _auth = FirebaseAuth.instance;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser!;
    _nameController =
        TextEditingController(text: user.displayName ?? '');
    _emailController =
        TextEditingController(text: user.email ?? '');
    _phoneController =
        TextEditingController(text: user.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final user = _auth.currentUser!;
      if (_nameController.text.trim() != user.displayName) {
        await user.updateProfile(displayName: _nameController.text.trim());
      }
      if (_emailController.text.trim() != user.email &&
          _emailController.text.trim().isNotEmpty) {
        await user.verifyBeforeUpdateEmail(_emailController.text.trim());
      }
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'nome': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'dataUpdate': DateTime.now(),
        'telefone': _phoneController.text.trim(),
      }, SetOptions(merge: true));
      await user.reload();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                'Dados atualizados com sucesso!',
                style: GoogleFonts.poppins(),
              ),
            ]),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _copyUID() {
    final uid = _auth.currentUser!.uid;
    Clipboard.setData(ClipboardData(text: uid));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.copy, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          const Text('ID copiado!'),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser!;
    final name = user.displayName ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final hasPhoto = user.photoURL != null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar com gradiente e avatar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration:
                    const BoxDecoration(gradient: AppTheme.softGradient),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: AppTheme.elevatedShadow,
                        color: Colors.white.withAlpha(51),
                      ),
                      child: hasPhoto
                          ? ClipOval(
                              child: Image.network(
                                user.photoURL!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: Text(
                                initial,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 32,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name.isNotEmpty ? name : 'Usuário',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      user.email ?? '',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              title: Text(
                'Configurações',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // Formulário
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // UID
                  _SectionLabel(label: 'Identificação'),
                  const SizedBox(height: 8),
                  _buildReadonlyField(
                    label: 'ID do Usuário',
                    value: user.uid,
                    icon: Icons.badge_outlined,
                    onTap: _copyUID,
                    hint: 'Toque para copiar',
                  ),
                  const SizedBox(height: 24),

                  // Dados pessoais
                  _SectionLabel(label: 'Dados Pessoais'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome completo',
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: AppTheme.accent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: AppTheme.accent,
                      ),
                      helperText:
                          'Um e-mail de confirmação será enviado ao alterar',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        color: AppTheme.accent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Botão salvar
                  GradientButton(
                    label: 'Salvar Alterações',
                    icon: Icons.save_rounded,
                    onPressed: _save,
                    isLoading: _isSaving,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Voltar'),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadonlyField({
    required String label,
    required String value,
    required IconData icon,
    VoidCallback? onTap,
    String? hint,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.accent, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: AppTheme.textSecondary),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (hint != null)
                    Text(
                      hint,
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: AppTheme.accent),
                    ),
                ],
              ),
            ),
            const Icon(Icons.copy_outlined, size: 18, color: AppTheme.accent),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }
}
