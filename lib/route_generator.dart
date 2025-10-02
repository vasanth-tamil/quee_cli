import 'dart:io';

import 'package:quee_cli/helper/name_helper.dart';
import 'package:quee_cli/quee.dart';

/// Generates a Flutter widget.
class RouteGenerator {
  final List<String> routes;
  final String routeFile;

  RouteGenerator(this.routes, this.routeFile);

  /// Generates the code for a stateless widget.
  String getRouteCode() {
    final buffer = StringBuffer();

    if (!File(routeFile).existsSync()) {
      Terminal.printError('Route file not found: $routeFile');
      exit(1);
    }

    // Read the file
    final pattern = RegExp(r'static\s+List<GetPage>\s+routes\s*=\s*\[');
    String code = File(routeFile).readAsStringSync();

    final match = pattern.firstMatch(code);

    if (match != null) {
      // Insert custom string after matched part's end
      int insertPos = match.start;
      String customString = "";

      for (var name in routes) {
        String routeName = NameHelper().toCamelCase(name);
        String route = NameHelper().toDashCase(name);
        customString += "static String $routeName = '$route';\n  ";

        Terminal.printText("Route added: static String $routeName = '$route';");
      }

      String result =
          '${code.substring(0, insertPos)}$customString\n  ${code.substring(insertPos)}';
      buffer.write(result);
    } else {
      buffer.write(code);
    }
    buffer.writeln("");

    return buffer.toString();
  }

  /// Generates the widget files.
  void generate() {
    String routeCode = getRouteCode();

    // write file
    File(routeFile).writeAsStringSync(routeCode);
    Terminal.printSuccess('Routes successfully added.');
  }
}
