import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelfile/app_theme.dart';
import 'package:travelfile/aviao_page.dart';
import 'package:travelfile/carro_page.dart';
import 'package:travelfile/hotel_page.dart';
import 'package:travelfile/ingressos_page.dart';
import 'package:travelfile/seguro_page.dart';
import 'package:travelfile/translado_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final _auth = FirebaseAuth.instance;

  static const List<Widget> _pages = [
    AviaoPage(),
    HotelPage(),
    TransladoPage(),
    CarroPage(),
    IngressosPage(),
    SeguroPage(),
  ];

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.airplanemode_active, label: 'Aéreo'),
    _NavItem(icon: Icons.hotel, label: 'Hotel'),
    _NavItem(icon: Icons.directions_bus, label: 'Transfer'),
    _NavItem(icon: Icons.directions_car, label: 'Carro'),
    _NavItem(icon: Icons.confirmation_number, label: 'Ingressos'),
    _NavItem(icon: Icons.health_and_safety_outlined, label: 'Seguro'),
  ];

  String get _pageTitle {
    const titles = [
      'Aéreo',
      'Hotel',
      'Transfer',
      'Carro',
      'Ingressos',
      'Seguro',
    ];
    return titles[_selectedIndex];
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: const BoxDecoration(gradient: AppTheme.softGradient),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Avatar + Texto
                  Expanded(
                    child: Row(
                      children: [
                        _buildAvatar(user),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _pageTitle,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              user?.displayName ?? user?.email ?? 'Usuário',
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Menu
                  PopupMenuButton<int>(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(31),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      child: const Icon(
                        Icons.menu_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    itemBuilder: (context) => [
                      _buildPopupItem(
                          0, Icons.settings_outlined, 'Configurações'),
                      _buildPopupItem(1, Icons.key_outlined, 'Trocar Senha'),
                      _buildPopupItem(
                          2, Icons.privacy_tip_outlined, 'Política de Privacidade'),
                      _buildPopupItem(3, Icons.logout_rounded, 'Sair',
                          color: AppTheme.danger),
                    ],
                    onSelected: (item) => _onMenuSelected(context, item),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: KeyedSubtree(
          key: ValueKey(_selectedIndex),
          child: _pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final selected = index == _selectedIndex;
                return _buildNavItem(item, index, selected, isDark);
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      _NavItem item, int index, bool selected, bool isDark) {
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.accent.withAlpha(26)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 24,
              color: selected
                  ? (isDark ? AppTheme.accentLight : AppTheme.primaryDark)
                  : Colors.grey,
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w400,
                color: selected
                    ? (isDark ? AppTheme.accentLight : AppTheme.primaryDark)
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(User? user) {
    final hasPhoto = user?.photoURL != null;
    final name = user?.displayName ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(51),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withAlpha(77), width: 2),
      ),
      child: hasPhoto
          ? ClipOval(child: Image.network(user!.photoURL!, fit: BoxFit.cover))
          : Center(
              child: Text(
                initial,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
    );
  }

  PopupMenuItem<int> _buildPopupItem(int value, IconData icon, String label,
      {Color? color}) {
    final itemColor = color ?? AppTheme.textPrimary;
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: itemColor, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.poppins(color: itemColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _onMenuSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context).pushNamed('/user_config');
        break;
      case 1:
        Navigator.of(context).pushNamed('/change_password');
        break;
      case 2:
        break;
      case 3:
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Sair'),
            content: const Text('Deseja realmente sair?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.danger,
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (ctx.mounted) {
                    Navigator.of(ctx).pushReplacementNamed('/');
                  }
                },
                child: const Text('Sair'),
              ),
            ],
          ),
        );
        break;
    }
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
