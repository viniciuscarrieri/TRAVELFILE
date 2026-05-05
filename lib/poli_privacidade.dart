import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelfile/app_theme.dart';

class PoliPrivacidadePage extends StatefulWidget {
  const PoliPrivacidadePage({super.key});

  @override
  State<PoliPrivacidadePage> createState() => _PoliPrivacidadePageState();
}

class _PoliPrivacidadePageState extends State<PoliPrivacidadePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Política de Privacidade'),
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
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    'Sua privacidade é nossa prioridade 🛡️',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'O TravelFile foi criado para ajudar você a organizar suas viagens com segurança e praticidade. Abaixo detalhamos como tratamos seus dados.',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  _buildSection(
                    '1. Dados que Coletamos',
                    'Coletamos informações básicas como seu nome e e-mail para identificação da sua conta. Além disso, os documentos que você envia (PDFs, imagens de vouchers, passagens, etc.) são armazenados para que você possa acessá-los em qualquer dispositivo.',
                  ),
                  
                  _buildSection(
                    '2. Como Usamos Seus Dados',
                    'Seus dados são utilizados exclusivamente para o funcionamento das ferramentas do TravelFile, como sincronização em tempo real, geração de planos de viagem e controle de despesas. Não compartilhamos seus documentos pessoais com terceiros.',
                  ),
                  
                  _buildSection(
                    '3. Segurança e Armazenamento',
                    'Utilizamos a infraestrutura do Google Firebase, que oferece criptografia de ponta e os mais altos padrões de segurança do mercado. Seus arquivos são protegidos por regras de segurança que garantem que apenas você tenha acesso a eles.',
                  ),
                  
                  _buildSection(
                    '4. Seus Direitos',
                    'Você tem total controle sobre seus dados. A qualquer momento você pode visualizar, editar ou excluir seus documentos e sua conta diretamente pelas configurações do aplicativo.',
                  ),
                  
                  _buildSection(
                    '5. Alterações na Política',
                    'Esta política pode ser atualizada periodicamente para refletir melhorias no app. Notificaremos você sobre mudanças significativas através do aplicativo.',
                  ),
                  
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.mail_outline, color: AppTheme.accent, size: 32),
                        const SizedBox(height: 12),
                        Text(
                          'Dúvidas sobre sua privacidade?',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Entre em contato pelo suporte oficial.',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
