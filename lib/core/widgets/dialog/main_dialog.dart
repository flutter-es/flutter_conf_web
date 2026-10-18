import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:material_ui/material_ui.dart';

class MainDialog extends StatelessWidget {
  const new({required this.child, super.key});

  final Widget child;

  static Future<T?> show<T>(BuildContext context, {required Widget child}) {
    return switch (context.screenSize) {
      .extraLarge || .large => showDialog<T>(
        context: context,
        barrierDismissible: false,
        builder: (_) => FractionallySizedBox(
          widthFactor: .6,
          heightFactor: .6,
          child: Container(
            clipBehavior: .antiAliasWithSaveLayer,
            decoration: BoxDecoration(borderRadius: .circular(24)),
            child: MainDialog(child: child),
          ),
        ),
      ),
      .normal || .small => showModalBottomSheet<T>(
        context: context,
        isDismissible: false,
        showDragHandle: true,
        useRootNavigator: true,
        isScrollControlled: true,
        clipBehavior: .hardEdge,
        backgroundColor: FlutterLatamColors.darkBlue,
        barrierColor: FlutterLatamColors.black.withValues(alpha: .3),
        shape: const RoundedRectangleBorder(
          borderRadius: .vertical(top: .circular(24)),
        ),
        builder: (_) => MainDialog(child: child),
      ),
    };
  }

  @override
  Widget build(BuildContext context) => child;
}
