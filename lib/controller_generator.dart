import 'package:quee_cli/helper/name_helper.dart';
import 'package:quee_cli/quee.dart';

/// Generates a GetX controller class.
class ControllerGenerator {
  /// The output path for the generated file.
  String output;

  /// The name of the controller.
  String name;

  /// The name of the service to be injected.
  String service;

  /// Creates a new instance of [ControllerGenerator].
  ControllerGenerator({
    required this.name,
    required this.service,
    this.output = 'output/controllers',
  });

  /// Generates a function for the controller.
  StringBuffer getFunctionCode({required String name}) {
    StringBuffer buffer = StringBuffer();

    buffer.writeln("");
    buffer.writeln("  /* $name */");
    buffer.writeln(
      "  Future<void> ${NameHelper().toCamelCase(name)}() async {",
    );
    buffer.writeln("    isTestLoading.toggle();");
    buffer.writeln("");
    buffer.writeln("    try {");
    buffer.writeln("      /* Service Call */");
    buffer.writeln(
      "      final response = await _${NameHelper().toCamelCase(service)}.test();",
    );
    buffer.writeln("");
    buffer.writeln("      if (response.isSuccess) {");
    buffer.writeln("        LogHelper.printJSON(response.data);");
    buffer.writeln("      } else {");
    buffer.writeln("        LogHelper.print(response.error.toString());");
    buffer.writeln("      }");
    buffer.writeln("    } catch (e) {");
    buffer.writeln("      LogHelper.print(e.toString());");
    buffer.writeln("    }");
    buffer.writeln("");
    buffer.writeln("    isTestLoading.toggle();");
    buffer.writeln("  }");

    return buffer;
  }

  /// Generates the code for the controller class.
  String getControllerCode(List<String> functions) {
    StringBuffer buffer = StringBuffer();

    String className = NameHelper.toClassName(name);

    buffer.writeln("import 'package:get/get.dart';");
    buffer.writeln("import 'package:template/helpers/log_helper.dart';");
    buffer.writeln(
      "import 'package:template/services/${NameHelper.toUnderscoreName(service)}.dart';",
    );
    buffer.writeln("");
    buffer.writeln("class $className extends GetxController {");
    buffer.writeln("  RxBool isTestLoading = false.obs;");
    buffer.writeln("");
    buffer.writeln("  /* Services */");
    buffer.writeln(
      "  final ${NameHelper.toClassName(service)} _${NameHelper().toCamelCase(service)} = ${NameHelper.toClassName(service)}();",
    );
    buffer.writeln("");
    buffer.writeln("  /* Controllers */");
    buffer.writeln("");
    buffer.writeln("  /* Models */");
    buffer.writeln("");
    buffer.writeln("  /* Actions */");
    buffer.writeln(
      functions.map((func) => getFunctionCode(name: func)).join(''),
    );
    buffer.writeln("");
    buffer.writeln("}");

    return buffer.toString();
  }

  /// Generates the controller file.
  void generate(List<String> functionList) {
    String fileName = '${NameHelper.toUnderscoreName(name)}.dart';
    String code = getControllerCode(functionList);

    FileGenerator().createFile(output, fileName, code);
  }
}
