import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:material_ui/material_ui.dart';

class SectionContainer extends StatelessWidget {
  const new({required this.children, this.spacing, super.key});

  final List<Widget> children;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final defaultSpacing = switch (context.screenSize) {
      .extraLarge || .large => 96.0,
      .normal || .small => 48.0,
    };

    return Padding(
      padding: .symmetric(
        horizontal: switch (context.screenSize) {
          .extraLarge => 122,
          .large => 72,
          .normal || .small => 28,
        },
        vertical: switch (context.screenSize) {
          .extraLarge || .large => 96,
          .normal || .small => 48,
        },
      ),
      child: Column(
        spacing: spacing ?? defaultSpacing,
        mainAxisSize: .min,
        children: children,
      ),
    );
  }
}
