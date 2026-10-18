import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/widgets/button/fcl_button.dart';
import 'package:material_ui/material_ui.dart';

class OptionButtonList extends StatelessWidget {
  const new({
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    super.key,
  });

  final List<String> options;
  final int selectedValue;
  final ValueSetter<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 10,
      spacing: switch (context.screenSize) {
        .extraLarge || .large => 20,
        .normal || .small => 10,
      },
      children: <Widget>[
        for (final (index, item) in options.indexed)
          if (index == selectedValue)
            FclButton.primary(
              label: item,
              onPressed: () => onChanged(index),
              buttonSize: .small,
            )
          else
            FclButton.secondary(
              label: item,
              onPressed: () => onChanged(index),
              buttonSize: .small,
            ),
      ],
    );
  }
}
