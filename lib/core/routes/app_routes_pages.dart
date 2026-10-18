import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:material_ui/material_ui.dart';

class ScreenPage<T> extends Page<T> {
  const new({required super.key, required this.child});

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return MaterialPageRoute<T>(settings: this, builder: (_) => child);
  }
}

class ModalBottomPage<T> extends Page<T> {
  const new({
    required super.key,
    required this.child,
    this.isDismissible = true,
    this.showDragHandle = true,
    this.isScrollControlled = false,
    this.initialChildSize = .5,
    this.heightFactor,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;
  final bool isDismissible;
  final bool showDragHandle;
  final bool isScrollControlled;
  final double initialChildSize;
  final double? heightFactor;

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute<T>(
      settings: this,
      clipBehavior: .hardEdge,
      isDismissible: isDismissible,
      showDragHandle: showDragHandle,
      isScrollControlled: isScrollControlled,
      backgroundColor: FlutterLatamColors.darkBlue,
      modalBarrierColor: FlutterLatamColors.black.withValues(alpha: .25),
      shape: const RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(24)),
      ),
      builder: (_) {
        if (heightFactor == null) {
          return switch (isScrollControlled) {
            true => DraggableScrollableSheet(
              expand: false,
              initialChildSize: initialChildSize,
              builder: (_, controller) =>
                  SingleChildScrollView(controller: controller, child: child),
            ),
            false => child,
          };
        }
        return FractionallySizedBox(heightFactor: heightFactor, child: child);
      },
    );
  }
}

typedef SizeFactor = ({double width, double height});

class DialogPage<T> extends Page<T> {
  const new({
    required super.key,
    required this.child,
    this.sizeFactor = (width: .6, height: .6),
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;
  final SizeFactor sizeFactor;

  @override
  Route<T> createRoute(BuildContext context) {
    return DialogRoute<T>(
      settings: this,
      context: context,
      builder: (_) => FractionallySizedBox(
        widthFactor: sizeFactor.width,
        heightFactor: sizeFactor.height,
        child: Container(
          margin: const .all(32),
          clipBehavior: .antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: FlutterLatamColors.darkBlue,
            borderRadius: .circular(24),
          ),
          child: child,
        ),
      ),
    );
  }
}
