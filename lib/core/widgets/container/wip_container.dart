import 'dart:math' as math;

import 'package:flutter_conf_latam/core/widgets/animations/flutter_rive_animated.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/generated/assets.gen.dart';
import 'package:material_ui/material_ui.dart';

class WipContainer extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            FlutterLatamColors.mainBlue,
            FlutterLatamColors.darkBlue,
            FlutterLatamColors.mainBlue,
          ],
          begin: .topCenter,
          end: .bottomCenter,
        ),
      ),
      child: Center(
        child: Transform(
          alignment: .center,
          transform: Matrix4.rotationY(math.pi),
          child: SizedBox.square(
            dimension: 500,
            child: FlutterRiveAnimated(
              path: Assets.animations.flutterdash,
              animation: .flutterDashConst,
            ),
          ),
        ),
      ),
    );
  }
}
