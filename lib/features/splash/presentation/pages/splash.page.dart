import 'dart:async';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_conf_latam/core/routes/app_route_path.dart';
import 'package:flutter_conf_latam/core/widgets/animations/flutter_rive_animated.dart';
import 'package:flutter_conf_latam/styles/generated/assets.gen.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class SplashPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(3.seconds, () {
      Router.neglect(context, () {
        context.go('/${AppRoutePath.home.pathName}');
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox.square(
          dimension: 200,
          child: FlutterRiveAnimated(
            path: Assets.animations.flutterconflogo,
            animation: .flutterLogo,
          ),
        ),
      ),
    );
  }
}
