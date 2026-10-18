import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

enum ScreenSize {
  small(300),
  normal(400),
  large(600),
  extraLarge(1200);

  new(this.size);

  final double size;
}

enum DeviceSegment { mobileWeb, desktopWeb, other }

DeviceSegment get currentDevice {
  return switch (defaultTargetPlatform) {
    .android || .iOS when kIsWeb => .mobileWeb,
    .windows || .linux || .macOS when kIsWeb => .desktopWeb,
    _ => .other,
  };
}

extension AdaptiveLayoutContext on BuildContext {
  bool get isPortrait => MediaQuery.orientationOf(this) == .portrait;

  ScreenSize get screenSize {
    final currentSize = switch (currentDevice) {
      .mobileWeb || .desktopWeb => MediaQuery.sizeOf(this).width,
      _ => MediaQuery.sizeOf(this).shortestSide,
    };

    return switch (currentSize) {
      _ when currentSize > ScreenSize.extraLarge.size => .extraLarge,
      _ when currentSize > ScreenSize.large.size => .large,
      _ when currentSize > ScreenSize.normal.size => .normal,
      _ => .small,
    };
  }

  bool get isMobileFromResponsive => screenSize != .extraLarge;
}
