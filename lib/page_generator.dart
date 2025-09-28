import 'package:quee_cli/helper/name_helper.dart';
import 'package:quee_cli/quee.dart';

class PageGenerator {
  String name = '';

  PageGenerator(this.name);

  String getStatfulCode() {
    StringBuffer buffer = StringBuffer();

    String className = NameHelper().toClassName('$name-age');

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

  void generate() {
    Terminal.printBold('\n1.Stateful Page Generated.');
    String statefulCode = getStatfulCode();
    print(statefulCode);

    Terminal.printBold('2.Stateless Page Generated.');
    String statelessCode = getStalessCode();
    print(statelessCode);
  }
}
