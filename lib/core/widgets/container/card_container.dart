import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:material_ui/material_ui.dart';

class CardContainer extends StatelessWidget {
  const new({required this.borderColor, required this.child, super.key});

  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: FlutterLatamColors.darkBlue,
      clipBehavior: .antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: .circular(20)),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: .start,
          children: <Widget>[
            Container(width: 10, decoration: BoxDecoration(color: borderColor)),
            Expanded(
              child: Padding(
                padding: .symmetric(
                  horizontal: switch (context.screenSize) {
                    .extraLarge => 64,
                    .large => 48,
                    .normal || .small => 24,
                  },
                  vertical: 32,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
