import 'dart:io';

import 'package:quee_cli/helper/name_helper.dart';
import 'package:quee_cli/quee.dart';

/// Generates a Flutter widget.
class RouteGenerator {
  final List<String> routes;
  final String routeFile;

  RouteGenerator({
    required this.routes,
    this.routeFile = 'example/routes.dart',
  });

  String insertPage(String routesCode, String routeListString) {
    RegExp pattern = RegExp(r'(\s*])(;)');

    String updatedCode = routesCode.replaceAllMapped(pattern, (match) {
      return '\n$routeListString${match.group(1)!}${match.group(2)!}';
    });

    return updatedCode;
  }

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
      String routeListString = "";

      print('');
      for (var name in routes) {
        String routeName = NameHelper().toCamelCase(name);
        String route = NameHelper().toDashCase(name);

        customString += "static String $routeName = '/$route';\n  ";
        routeListString +=
            '    GetPage(name: AppConstants.$routeName, page: () => const Container()),\n';

        Terminal.printText(
          "Route added: static String /$routeName = '$route';",
        );
      }

      String result =
          '${code.substring(0, insertPos)}$customString\n  ${code.substring(insertPos)}';
      String updatedCode = insertPage(result, routeListString);
      buffer.write(updatedCode);
    } else {
      buffer.write(code);
    }

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
