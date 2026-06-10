import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Палитра
// ─────────────────────────────────────────────────────────────────────────────

abstract final class AppColors {
  // Фоны — 5 уровней глубины
  static const Color bg0 = Color(0xFF090909); // абсолютный фон
  static const Color bg1 = Color(0xFF111114); // карточки первого уровня
  static const Color bg2 = Color(0xFF1A1A1E); // карточки второго уровня
  static const Color bg3 = Color(0xFF242428); // чипы, инпуты
  static const Color bg4 = Color(0xFF2E2E32); // hover / pressed

  // Границы
  static const Color border1 = Color(0xFF2A2A2E); // очень тонкая
  static const Color border2 = Color(0xFF3C3C40); // заметная

  // Акценты
  static const Color blue   = Color(0xFF5B8FF9); // электрик синий
  static const Color amber  = Color(0xFFFF9500); // iOS янтарный
  static const Color green  = Color(0xFF30D158); // iOS зелёный
  static const Color yellow = Color(0xFFFFD60A); // iOS жёлтый
  static const Color red    = Color(0xFFFF375F); // iOS красный

  // Специальный: синий градиент для шапки
  static const Color headerStart = Color(0xFF0B1629);
  static const Color headerEnd   = Color(0xFF07101E);

  // Текст
  static const Color text1 = Color(0xFFF5F5F7); // основной (почти белый)
  static const Color text2 = Color(0xFF8D8D92); // вторичный
  static const Color text3 = Color(0xFF48484C); // третичный / placeholder
}

// ─────────────────────────────────────────────────────────────────────────────
// Тема
// ─────────────────────────────────────────────────────────────────────────────

ThemeData buildAppTheme() {
  final textTheme = GoogleFonts.manropeTextTheme().copyWith(
    displayLarge:   GoogleFonts.manrope(fontSize: 57, fontWeight: FontWeight.w800, color: AppColors.text1, letterSpacing: -2),
    displayMedium:  GoogleFonts.manrope(fontSize: 45, fontWeight: FontWeight.w800, color: AppColors.text1, letterSpacing: -1.5),
    displaySmall:   GoogleFonts.manrope(fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.text1, letterSpacing: -1),
    headlineLarge:  GoogleFonts.manrope(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.text1, letterSpacing: -0.8),
    headlineMedium: GoogleFonts.manrope(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.text1, letterSpacing: -0.5),
    headlineSmall:  GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.text1, letterSpacing: -0.3),
    titleLarge:     GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text1, letterSpacing: -0.2),
    titleMedium:    GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.text1),
    titleSmall:     GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text1),
    bodyLarge:      GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.text1),
    bodyMedium:     GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.text1),
    bodySmall:      GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.text2),
    labelLarge:     GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text1),
    labelMedium:    GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.text2),
    labelSmall:     GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.text3, letterSpacing: 0.8),
  );

  const colorScheme = ColorScheme(
    brightness:              Brightness.dark,
    primary:                 AppColors.blue,
    onPrimary:               AppColors.text1,
    secondary:               AppColors.amber,
    onSecondary:             Color(0xFF1C1C1E),
    error:                   AppColors.red,
    onError:                 AppColors.text1,
    surface:                 AppColors.bg0,
    onSurface:               AppColors.text1,
    surfaceContainerHighest: AppColors.bg1,
    outline:                 AppColors.border1,
    outlineVariant:          AppColors.border2,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: AppColors.bg0,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.bg1,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.border1, width: 0.5),
      ),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.bg1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: GoogleFonts.manrope(
        fontSize: 18, fontWeight: FontWeight.w700,
        color: AppColors.text1,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bg3,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border1, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border1, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
      ),
      labelStyle: GoogleFonts.manrope(color: AppColors.text2, fontSize: 14),
      hintStyle: GoogleFonts.manrope(color: AppColors.text3, fontSize: 14),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.text1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        elevation: 0,
        textStyle: GoogleFonts.manrope(
          fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.1,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.blue,
        textStyle: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.bg1,
      modalBackgroundColor: AppColors.bg1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),

    bottomAppBarTheme: const BottomAppBarThemeData(
      color: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.zero,
    ),
  );
}
