import 'package:flutter_conf_latam/app.dart';
import 'package:flutter_conf_latam/bootstrap.dart';
import 'package:flutter_conf_latam/firebase_options.dart';

void main() async {
  await bootstrap(
    () async => const FlutterConfWeb(),
    DefaultFirebaseOptions.currentPlatform,
  );
}
