import 'package:material_ui/material_ui.dart';

class FclColorScheme extends ThemeExtension<FclColorScheme> {
  new({
    required this.background,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.neutral,
    required this.inverseNeutral,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.accentTertiary,
    required this.primaryFixed,
    required this.tertiaryFixed,
    required this.error,
    required this.accentError,
    required this.surface,
    required this.accentSurface,
    required this.outline,
    required this.accentOutline,
  });

  final Color background;

  final Color primary;
  final Color secondary;
  final Color tertiary;

  final Color neutral;
  final Color inverseNeutral;

  final Color accentPrimary;
  final Color accentSecondary;
  final Color accentTertiary;

  final Color primaryFixed;
  final Color tertiaryFixed;

  final Color error;
  final Color accentError;

  final Color surface;
  final Color accentSurface;

  final Color outline;
  final Color accentOutline;

  @override
  ThemeExtension<FclColorScheme> copyWith({
    Color? background,
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? neutral,
    Color? inverseNeutral,
    Color? accentPrimary,
    Color? accentSecondary,
    Color? accentTertiary,
    Color? primaryFixed,
    Color? tertiaryFixed,
    Color? error,
    Color? accentError,
    Color? surface,
    Color? accentSurface,
    Color? outline,
    Color? accentOutline,
  }) {
    return FclColorScheme(
      background: background ?? this.background,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      neutral: neutral ?? this.neutral,
      inverseNeutral: inverseNeutral ?? this.inverseNeutral,
      accentPrimary: accentPrimary ?? this.accentPrimary,
      accentSecondary: accentSecondary ?? this.accentSecondary,
      accentTertiary: accentTertiary ?? this.accentTertiary,
      primaryFixed: primaryFixed ?? this.primaryFixed,
      tertiaryFixed: tertiaryFixed ?? this.tertiaryFixed,
      error: error ?? this.error,
      accentError: accentError ?? this.accentError,
      surface: surface ?? this.surface,
      accentSurface: accentSurface ?? this.accentSurface,
      outline: outline ?? this.outline,
      accentOutline: accentOutline ?? this.accentOutline,
    );
  }

  @override
  ThemeExtension<FclColorScheme> lerp(
    covariant ThemeExtension<FclColorScheme>? other,
    double t,
  ) {
    if (other is! FclColorScheme) return this;

    return FclColorScheme(
      background: _lerpColor(background, other.background, t),
      primary: _lerpColor(primary, other.primary, t),
      secondary: _lerpColor(secondary, other.secondary, t),
      tertiary: _lerpColor(tertiary, other.tertiary, t),
      neutral: _lerpColor(neutral, other.neutral, t),
      inverseNeutral: _lerpColor(inverseNeutral, other.inverseNeutral, t),
      accentPrimary: _lerpColor(accentPrimary, other.accentPrimary, t),
      accentSecondary: _lerpColor(accentSecondary, other.accentSecondary, t),
      accentTertiary: _lerpColor(accentTertiary, other.accentTertiary, t),
      primaryFixed: _lerpColor(primaryFixed, other.primaryFixed, t),
      tertiaryFixed: _lerpColor(tertiaryFixed, other.tertiaryFixed, t),
      error: _lerpColor(error, other.error, t),
      accentError: _lerpColor(accentError, other.accentError, t),
      surface: _lerpColor(surface, other.surface, t),
      accentSurface: _lerpColor(accentSurface, other.accentSurface, t),
      outline: _lerpColor(outline, other.outline, t),
      accentOutline: _lerpColor(accentOutline, other.accentOutline, t),
    );
  }

  Color _lerpColor(Color? main, Color? second, double value) {
    return Color.lerp(main, second, value)!;
  }
}
