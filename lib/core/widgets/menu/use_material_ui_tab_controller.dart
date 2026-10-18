import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_ui/material_ui.dart';

/// TEMPORARY until flutter_hooks fix this issue.
/// Mirrors `flutter_hooks`' `useTabController`, but builds `material_ui`'s
/// own [TabController] instead of Flutter's — `material_ui` forks
/// `TabBar`/`TabController` and hasn't shipped a hook for it yet.
TabController useMaterialUiTabController({
  required int initialLength,
  Duration? animationDuration = kTabScrollDuration,
  TickerProvider? vsync,
  int initialIndex = 0,
  List<Object?>? keys,
}) {
  vsync ??= useSingleTickerProvider(keys: keys);
  return use(
    _MaterialUiTabControllerHook(
      vsync: vsync,
      length: initialLength,
      initialIndex: initialIndex,
      animationDuration: animationDuration,
      keys: keys,
    ),
  );
}

class _MaterialUiTabControllerHook extends Hook<TabController> {
  const new({
    required this.length,
    required this.vsync,
    required this.initialIndex,
    required this.animationDuration,
    super.keys,
  });

  final int length;
  final TickerProvider vsync;
  final int initialIndex;
  final Duration? animationDuration;

  @override
  HookState<TabController, Hook<TabController>> createState() =>
      _MaterialUiTabControllerHookState();
}

class _MaterialUiTabControllerHookState
    extends HookState<TabController, _MaterialUiTabControllerHook> {
  late final controller = TabController(
    length: hook.length,
    initialIndex: hook.initialIndex,
    animationDuration: hook.animationDuration,
    vsync: hook.vsync,
  );

  @override
  TabController build(BuildContext context) => controller;

  @override
  void dispose() => controller.dispose();

  @override
  String get debugLabel => 'useMaterialUiTabController';
}
