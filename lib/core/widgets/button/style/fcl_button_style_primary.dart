part of '../fcl_button.dart';

class _FclButtonStylePrimary extends _FclButtonStyle {
  const new({
    required super.buttonSize,
    required super.theme,
    super.textSize,
    this.color,
  });

  final Color? color;

  @override
  WidgetStateProperty<Color?>? get backgroundColor {
    final base = color ?? FlutterLatamColors.blue;
    return .resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return base.withValues(alpha: .3);
      }
      return base;
    });
  }

  @override
  ButtonLayerBuilder? get backgroundBuilder {
    return (BuildContext context, Set<WidgetState> state, Widget? child) {
      if (child == null) return const Offstage();
      return child;
    };
  }

  @override
  WidgetStateProperty<OutlinedBorder?>? get shape {
    return const WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: .all(.circular(12))),
    );
  }
}
