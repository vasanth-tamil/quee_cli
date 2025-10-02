import 'dart:io';

import 'package:quee_cli/helper/name_helper.dart';
import 'package:quee_cli/quee.dart';

/// Generates a Flutter page.
class PageGenerator {
  /// The name of the page.
  String name = '';

  /// Creates a new instance of [PageGenerator].
  PageGenerator(this.name);

  /// Generates the code for a stateful widget page.
  String getStatfulCode() {
    StringBuffer buffer = StringBuffer();

    String className = NameHelper().toClassName('$name-page');

    buffer.writeln("import 'package:flutter/material.dart';");
    buffer.writeln(
      "import 'package:template/pages/layouts/responsive_layout.dart';",
    );
    buffer.writeln("");
    buffer.writeln("class $className extends StatefulWidget {");
    buffer.writeln("  const $className({super.key});");
    buffer.writeln("");
    buffer.writeln("  @override");
    buffer.writeln(
      "  State<$className> createState() => _${className}State();",
    );
    buffer.writeln("}");
    buffer.writeln("");
    buffer.writeln("class _${className}State extends State<$className> {");
    buffer.writeln("  @override");
    buffer.writeln("  void initState() {");
    buffer.writeln("    super.initState();");
    buffer.writeln("  }");
    buffer.writeln("");
    buffer.writeln("  @override");
    buffer.writeln("  Widget build(BuildContext context) {");
    buffer.writeln("    return ResponsiveLayout(");
    buffer.writeln("      phoneLayout: Scaffold(),");
    buffer.writeln("      tabletLayout: Scaffold(),");
    buffer.writeln("      desktopLayout: Scaffold(),");
    buffer.writeln("    );");
    buffer.writeln("  }");
    buffer.writeln("}");

    return buffer.toString();
  }

  /// Generates the code for a stateless widget page.
  String getStalessCode() {
    final buffer = StringBuffer();

    String className = NameHelper().toClassName('$name-page');

    buffer.writeln("import 'package:flutter/material.dart';");
    buffer.writeln(
      "import 'package:template/pages/layouts/responsive_layout.dart';",
    );
    buffer.writeln("");
    buffer.writeln("class $className extends StatelessWidget {");
    buffer.writeln("  const $className({super.key});");
    buffer.writeln("");
    buffer.writeln("  @override");
    buffer.writeln("  Widget build(BuildContext context) {");
    buffer.writeln("    return ResponsiveLayout(");
    buffer.writeln("      phoneLayout: Scaffold(),");
    buffer.writeln("      tabletLayout: Scaffold(),");
    buffer.writeln("      desktopLayout: Scaffold(),");
    buffer.writeln("    );");
    buffer.writeln("  }");
    buffer.writeln("}");

    return buffer.toString();
  }

  /// Generates the page files.
  void generate() {
    String outputPath = 'output/pages';
    String fileName = NameHelper.createFileName(name, suffix: 'page');

    List<Map<String, dynamic>> options = [
      {
        'label': 'Stateful Page.',
        'value': '1',
        'action': () {
          Terminal.printBold('\n1.Stateful Page Generated.');
          String statefulCode = getStatfulCode();
          print(statefulCode);
          FileGenerator().createFile(outputPath, fileName, statefulCode);
        },
      },
      {
        'label': 'Stateless Page.',
        'value': '2',
        'action': () {
          Terminal.printBold('\n2.Stateless Page Generated.');
          String statelessCode = getStalessCode();
          print(statelessCode);
          FileGenerator().createFile(outputPath, fileName, statelessCode);
        },
      },
      {
        'label': 'Exit.',
        'value': '0',
        'action': () {
          Terminal.printText('Bye.');
          exit(0);
        },
      },
    ];

    Terminal.askOptionsWithInput('Page Options:', options);
  }
}
