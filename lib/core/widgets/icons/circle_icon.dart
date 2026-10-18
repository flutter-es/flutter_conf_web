import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:material_ui/material_ui.dart';

class CircleIcon extends StatelessWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 32,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: .circle,
          color: FlutterLatamColors.mediumBlue,
        ),
        child: Padding(padding: const .all(4), child: child),
      ),
    );
  }
}
