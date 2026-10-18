import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/widgets/icons/circle_icon.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:material_ui/material_ui.dart';

class DialogContainer extends StatelessWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FlutterLatamColors.darkBlue,
      child: SizedBox(
        width: .infinity,
        child: Stack(
          children: <Widget>[
            child,
            _CloseButton(onClose: () => Navigator.of(context).pop()),
          ],
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const new({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      top: switch (context.screenSize) {
        .extraLarge || .large => 20,
        .normal || .small => 0,
      },
      child: InkWell(
        onTap: onClose,
        child: const CircleIcon(
          child: Icon(Icons.close, color: FlutterLatamColors.white),
        ),
      ),
    );
  }
}
