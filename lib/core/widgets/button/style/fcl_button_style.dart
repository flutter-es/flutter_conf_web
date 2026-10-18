part of '../fcl_button.dart';

class _FclButtonStyle extends ButtonStyle {
  const new({required this.buttonSize, required this.theme, this.textSize});

  final ButtonSize buttonSize;
  final ThemeData theme;
  final ButtonTextSize? textSize;

  @override
  AlignmentGeometry? get alignment => .center;

  @override
  Duration? get animationDuration => const Duration(milliseconds: 200);

  @override
  InteractiveInkFeatureFactory? get splashFactory => InkRipple.splashFactory;

  @override
  MaterialTapTargetSize? get tapTargetSize => .shrinkWrap;

  @override
  WidgetStateProperty<EdgeInsetsGeometry?>? get padding {
    return WidgetStatePropertyAll(switch (buttonSize) {
      .small => const .symmetric(horizontal: 20),
      .large => const .symmetric(horizontal: 40),
    });
  }

  @override
  WidgetStateProperty<Size?>? get maximumSize {
    return const WidgetStatePropertyAll(.fromHeight(68));
  }

  @override
  WidgetStateProperty<Size?>? get fixedSize {
    return WidgetStatePropertyAll(switch (buttonSize) {
      .small => const .fromHeight(44),
      .large => const .fromHeight(68),
    });
  }

  @override
  VisualDensity? get visualDensity => .adaptivePlatformDensity;

  @override
  WidgetStateProperty<double?>? get elevation {
    return .resolveWith((states) {
      if (states.contains(WidgetState.disabled)) return 0;
      return 2;
    });
  }

  @override
  WidgetStateProperty<Color?>? get iconColor {
    return const WidgetStatePropertyAll(FlutterLatamColors.white);
  }

  @override
  WidgetStateProperty<double>? get iconSize {
    return WidgetStatePropertyAll(switch (buttonSize) {
      .small => 20,
      .large => 24,
    });
  }

  @override
  WidgetStateProperty<Color?>? get foregroundColor {
    return const WidgetStatePropertyAll(FlutterLatamColors.white);
  }

  @override
  WidgetStateProperty<TextStyle?>? get textStyle {
    final typo = theme.fclThemeScheme.typography;
    final resolved = switch (textSize) {
      .small => typo.buttonSmallMedium,
      .medium => typo.buttonSmallMedium.copyWith(fontSize: 18),
      .large => typo.buttonNormalMedium,
      null => switch (buttonSize) {
        .small => typo.buttonSmallMedium,
        .large => typo.buttonNormalMedium,
      },
    };
    return WidgetStatePropertyAll(resolved);
  }

  @override
  WidgetStateProperty<Color?>? get overlayColor {
    return .resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return FlutterLatamColors.white.withValues(alpha: .3);
      }
      return null;
    });
  }
}
