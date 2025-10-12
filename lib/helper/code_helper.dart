import 'dart:core';

class CodeHelper {
  static bool hasRouteConstant(String c, String routeName) {
    String escapedRouteName = RegExp.escape(routeName);
    final String pattern =
        "static String \\w+ = ['\"]/?$escapedRouteName['\"];";

    final RegExp routePattern = RegExp(pattern);

    return routePattern.hasMatch(c);
  }
}
