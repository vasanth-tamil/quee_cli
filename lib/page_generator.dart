import 'package:quee_cli/helper/name_helper.dart';
import 'package:quee_cli/quee.dart';

// Generates a Flutter page.
class PageGenerator {
  // The name of the page.
  String name;

  // The output path for the generated file.
  String output;

  // Creates a new instance of [PageGenerator].
  PageGenerator({required this.name, this.output = 'output/pages'});

  // Generates the code for a stateful widget page.
  String getStatfulCode() {
    StringBuffer buffer = StringBuffer();

    String className = NameHelper.toClassName(name);

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

  // Generates the code for a stateless widget page.
  String getStalessCode() {
    final buffer = StringBuffer();

    String className = NameHelper.toClassName(name);

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

  // Generates the page files.
  void generate(int pageType) {
    String fileName = "${NameHelper.toUnderscoreName(name)}.dart";

    if (pageType == 0) {
      String statefulCode = getStatfulCode();
      FileGenerator().createFile(output, fileName, statefulCode);
    } else if (pageType == 1) {
      String statelessCode = getStalessCode();
      FileGenerator().createFile(output, fileName, statelessCode);
    }
  }
}
