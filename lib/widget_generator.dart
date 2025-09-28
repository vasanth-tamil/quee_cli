import 'package:quee_cli/helper/name_helper.dart';
import 'package:quee_cli/quee.dart';

class WidgetGenerator {
  String name = '';

  WidgetGenerator(this.name);

  String getStatfulCode() {
    StringBuffer buffer = StringBuffer();

    String className = NameHelper().toClassName(name);

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
    buffer.writeln("    return Container();");
    buffer.writeln("  }");
    buffer.writeln("}");

    return buffer.toString();
  }

  String getStalessCode() {
    final buffer = StringBuffer();

    String className = NameHelper().toClassName(name);

    buffer.writeln("import 'package:flutter/material.dart';");
    buffer.writeln("");
    buffer.writeln("class $className extends StatelessWidget {");
    buffer.writeln("  const $className({super.key});");
    buffer.writeln("");
    buffer.writeln("  @override");
    buffer.writeln("  Widget build(BuildContext context) {");
    buffer.writeln("    return Container();");
    buffer.writeln("  }");
    buffer.writeln("}");

    return buffer.toString();
  }

  void generate() {
    Terminal.printBold('\n1.Stateful Widget Generated.');
    String statefulCode = getStatfulCode();
    print(statefulCode);

    Terminal.printBold('2.Stateless Widget Generated.');
    String statelessCode = getStalessCode();
    print(statelessCode);
  }
}
