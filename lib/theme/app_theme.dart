import 'package:flutter/material.dart';

/// AppTheme defines design tokens and the global theme based on MoMo Design Guidelines.
/// Reference: docs/momo-design-guideline/tokens.md
class AppTheme {
  AppTheme._();

  // --- Brand & Semantic Colors ---
  /// MoMo Primary — "Branding color Primary" of MoMo Design System
  /// (https://ds.momoapp.vn/9346742a0/p/773202-color).
  /// Lưu ý: bản Mini App guideline dùng `#D82D8B`; app dùng màu chính thức của DS.
  static const Color primary = Color(0xFFEB2F96);

  /// Darker shade of MoMo Primary for depth (cùng hue/sat, L -12%)
  static const Color primaryDark = Color(0xFFD10A77);

  /// MoMo Secondary - Light pink background for icons and badges
  static const Color secondary = Color(0xFFFFD6E7);

  /// Default text color (Black-17)
  static const Color textDefault = Color(0xFF303233);

  /// Uppercase / Secondary text color (Black-14)
  static const Color textSecondary = Color(0xFF565656);

  /// Hint text / Strikethrough (Black-12)
  static const Color textHint = Color(0xFF727272);

  /// Placeholder / Disabled icon border (Black-09)
  static const Color placeholder = Color(0xFFB9B9B9);

  /// Page background & disabled container (Black-02)
  static const Color background = Color(0xFFF9F9F9);

  /// Pure white surface
  static const Color white = Color(0xFFFFFFFF);

  /// Border color for cards and fields (Black-04)
  static const Color border = Color(0xFFE8E8E8);

  // --- Status Colors ---
  static const Color success = Color(0xFF52C41A);
  static const Color successLight = Color(0xFFD9F7BE);

  static const Color warning = Color(0xFFFA541C);
  static const Color warningLight = Color(0xFFFFF7E6);

  static const Color error = Color(0xFFF5222D);
  static const Color errorLight = Color(0xFFFFCCC7);

  static const Color info = Color(0xFF096DD9);
  static const Color infoLight = Color(0xFFF0F5FF);

  // --- Spacing Tokens (Multiples of 4) ---
  static const double spacingXXS = 4.0;
  static const double spacingXS = 8.0;
  static const double spacingS = 12.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // --- Corner Radius Tokens ---
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusFull = 999.0;

  // --- Responsive Breakpoints ---
  static const double maxContentWidth = 600.0;

  /// Helper to format currency in Vietnamese Dong (VND)
  static String formatCurrency(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i > 0) {
        buffer.write('.');
      }
    }
    final formatted = buffer.toString().split('').reversed.join('');
    return '$formatted đ';
  }

  /// Global ThemeData configured with MoMo design system tokens
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        surface: background,
        onPrimary: white,
        onSurface: textDefault,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        iconTheme: IconThemeData(color: white),
      ),
      cardTheme: CardThemeData(
        color: white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: white,
          disabledBackgroundColor: placeholder,
          disabledForegroundColor: white,
          elevation: 0,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingS + 2,
        ),
        hintStyle: const TextStyle(
          color: textHint,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
      ),
    );
  }
}
