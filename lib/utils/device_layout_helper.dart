import 'dart:math';
import 'package:flutter/widgets.dart';

class DeviceLayoutHelper {
  static const double _tabletDiagonal = 1100;

  static bool get isTablet {
    final Size size =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
    final deviceDiagonal = sqrt(pow(size.width, 2) + pow(size.height, 2));

    return deviceDiagonal > _tabletDiagonal;
  }

  static Orientation get orientation {
    return MediaQueryData.fromWindow(WidgetsBinding.instance.window)
        .orientation;
  }

  static bool get isPortrait {
    return orientation == Orientation.portrait;
  }

  static bool get isLandscape {
    return orientation == Orientation.landscape;
  }
}
