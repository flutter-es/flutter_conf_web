import 'package:material_ui/material_ui.dart';

class KeepAliveContainer extends StatefulWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  State<KeepAliveContainer> createState() => _KeepAliveContainerState();
}

class _KeepAliveContainerState extends State<KeepAliveContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
