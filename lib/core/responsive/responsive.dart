import 'package:flutter/material.dart';

class Responsive {
  static const double mobile = 600;
  static const double tablet = 1024;

  static double width(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double height(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  static bool isMobile(BuildContext context) {
    return width(context) < mobile;
  }

  static bool isTablet(BuildContext context) {
    return width(context) >= mobile && width(context) < tablet;
  }

  static bool isDesktop(BuildContext context) {
    return width(context) >= tablet;
  }
}
