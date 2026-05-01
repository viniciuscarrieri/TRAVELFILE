import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- Cores ---
  static const Color primaryDark = Color(0xFF0A2463);
  static const Color primaryMid = Color(0xFF1B4FBF);
  static const Color accent = Color(0xFF3E92CC);
  static const Color accentLight = Color(0xFF74B9E6);
  static const Color success = Color(0xFF27AE60);
  static const Color danger = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color surfaceLight = Color(0xFFF4F7FB);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0A2463);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

  // Dark mode
  static const Color darkBg = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkCard = Color(0xFF1F2937);
  static const Color darkBorder = Color(0xFF374151);

  // --- Gradientes ---
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primaryMid, accent],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient softGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A2463), Color(0xFF1B4FBF)],
  );

  // --- Sombras ---
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withAlpha(13),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: primaryDark.withAlpha(51),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  // --- Espaçamentos ---
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXL = 32.0;

  // --- Tema Light ---
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryDark,
        primary: primaryDark,
        secondary: accent,
        surface: surfaceLight,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: surfaceLight,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        headlineLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 28,
          color: primaryDark,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: primaryDark,
        ),
        titleLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: primaryDark,
        ),
        titleMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: primaryDark,
        ),
        bodyLarge: GoogleFonts.poppins(fontSize: 15, color: textPrimary),
        bodyMedium: GoogleFonts.poppins(fontSize: 14, color: textSecondary),
        labelLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryDark,
          side: const BorderSide(color: primaryDark, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: danger),
        ),
        labelStyle: GoogleFonts.poppins(color: textSecondary, fontSize: 14),
        hintStyle: GoogleFonts.poppins(color: textSecondary, fontSize: 14),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardLight,
        indicatorColor: accent.withAlpha(26),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              color: primaryDark,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            );
          }
          return GoogleFonts.poppins(
            color: textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryDark, size: 24);
          }
          return const IconThemeData(color: Colors.grey, size: 24);
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: StadiumBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primaryDark,
        contentTextStyle: GoogleFonts.poppins(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: primaryDark,
        ),
        contentTextStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: textSecondary,
        ),
      ),
    );
  }

  // --- Tema Dark ---
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        primary: accent,
        secondary: accentLight,
        surface: darkSurface,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: darkBg,
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        headlineLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 28,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.white,
        ),
        titleMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.poppins(fontSize: 15, color: Colors.white70),
        bodyMedium: GoogleFonts.poppins(fontSize: 14, color: Colors.white54),
        labelLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: darkSurface,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: accent, width: 2),
        ),
        labelStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 14),
        hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 14),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        indicatorColor: accent.withAlpha(51),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              color: accentLight,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            );
          }
          return GoogleFonts.poppins(
            color: Colors.white38,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: accentLight, size: 24);
          }
          return const IconThemeData(color: Colors.white38, size: 24);
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: StadiumBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkCard,
        contentTextStyle: GoogleFonts.poppins(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.white,
        ),
        contentTextStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
    );
  }
}

// --- Widget reutilizável: botão gradiente ---
class GradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;

  const GradientButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient:
            onPressed != null
                ? AppTheme.primaryGradient
                : const LinearGradient(colors: [Colors.grey, Colors.grey]),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: onPressed != null ? AppTheme.elevatedShadow : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Center(
            child:
                isLoading
                    ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                    : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          label,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
