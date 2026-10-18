import 'package:signals/signals.dart';

class PagePreloader {
  static Future<void> preload(List<FutureSignal<dynamic>> signals) async {
    await Future.wait(
      signals.map((signal) => signal.future.catchError((_) => null)),
    );
  }
}
