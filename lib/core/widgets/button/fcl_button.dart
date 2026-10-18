import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';

part 'style/fcl_button_style.dart';

part 'style/fcl_button_style_primary.dart';

part 'style/fcl_button_style_secondary.dart';

enum ButtonVariant { primary, secondary }

enum ButtonSize { small, large }

enum ButtonTextSize { small, medium, large }

class FclButton extends StatelessWidget {
  const new primary({
    required this.label,
    required this.onPressed,
    required this.buttonSize,
    this.iconAlignment = .start,
    this.icon,
    this.color,
    this.textSize,
    super.key,
  }) : variant = .primary;

  const new secondary({
    required this.label,
    required this.onPressed,
    required this.buttonSize,
    this.iconAlignment = .start,
    this.icon,
    this.textSize,
    super.key,
  }) : variant = .secondary,
       color = null;

  final String label;
  final ButtonVariant variant;
  final ButtonSize buttonSize;
  final IconAlignment iconAlignment;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color? color;
  final ButtonTextSize? textSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: switch (variant) {
        .primary => _FclButtonStylePrimary(
          buttonSize: buttonSize,
          theme: context.theme,
          color: color,
          textSize: textSize,
        ),
        .secondary => _FclButtonStyleSecondary(
          buttonSize: buttonSize,
          theme: context.theme,
          textSize: textSize,
        ),
      },
      onPressed: onPressed,
      child: Row(
        spacing: 12,
        mainAxisSize: .min,
        mainAxisAlignment: .center,
        textDirection: switch (iconAlignment) {
          .start => .ltr,
          .end => .rtl,
        },
        children: <Widget>[
          ?icon,
          Flexible(child: Text(label, textAlign: .center)),
        ],
      ),
    );
  }
}
