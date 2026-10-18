import 'package:flutter_conf_latam/core/enums/enums.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rive/rive.dart';

class FlutterRiveAnimated extends StatefulWidget {
  const new({required this.path, required this.animation, super.key});

  final String path;
  final FlutterConfAnimations animation;

  @override
  State<FlutterRiveAnimated> createState() => _FlutterRiveAnimatedState();
}

class _FlutterRiveAnimatedState extends State<FlutterRiveAnimated> {
  late final _fileLoader = FileLoader.fromAsset(
    widget.path,
    riveFactory: .rive,
  );

  @override
  void dispose() {
    _fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => SizedBox.fromSize(
        size: Size(constraints.maxWidth, constraints.maxHeight),
        child: RiveWidgetBuilder(
          fileLoader: _fileLoader,
          artboardSelector: ArtboardSelector.byName(widget.animation.name),
          builder: (_, state) => switch (state) {
            RiveLoaded() => RiveWidget(
              controller: state.controller,
              fit: .cover,
            ),
            _ => const Offstage(),
          },
        ),
      ),
    );
  }
}
