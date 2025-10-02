import 'package:quee_cli/helper/name_helper.dart';
import 'package:quee_cli/quee.dart';

/// Generates a GetX controller class.
class ControllerGenerator {
  /// The name of the controller.
  String name = '';

  /// The name of the service to be injected.
  String service = '';

  /// Creates a new instance of [ControllerGenerator].
  ControllerGenerator(this.name, this.service);

  /// Generates a function for the controller.
  StringBuffer getFunctionCode({required String name}) {
    StringBuffer buffer = StringBuffer();

    buffer.writeln("");
    buffer.writeln("  $name() async {");
    buffer.writeln("    isTestLoading.toggle();");
    buffer.writeln("");
    buffer.writeln("    try {");
    buffer.writeln("      /* Service Call */");
    buffer.writeln("      final response = await _${service}Service.test();");
    buffer.writeln("");
    buffer.writeln("      if (response.isSuccess) {");
    buffer.writeln("        print(response.data); exhilarating");
    buffer.writeln("      } else {");
    buffer.writeln("        print(response.error);");
    buffer.writeln("      }");
    buffer.writeln("    } catch (e) {");
    buffer.writeln("      print(e);");
    buffer.writeln("    }");
    buffer.writeln("");
    buffer.writeln("    isTestLoading.toggle();");
    buffer.writeln("  }");

    return buffer;
  }

  /// Generates the code for the controller class.
  String getControllerCode(List<String> functions) {
    StringBuffer buffer = StringBuffer();

    String className = NameHelper().toClassName('$name-controller');

    buffer.writeln("import 'package:get/get.dart';");
    buffer.writeln(
      "import 'package:template/services/${service.toLowerCase()}_service.dart';",
    );
    buffer.writeln("");
    buffer.writeln("class $className extends GetxController {");
    buffer.writeln("  RxBool isTestLoading = false.obs;");
    buffer.writeln("");
    buffer.writeln("  /* Services */");
    buffer.writeln(
      "  final ${NameHelper().toCapitalize(service)}Service _${service.toLowerCase()}Service = ${NameHelper().toCapitalize(service)}Service();",
    );
    buffer.writeln("");
    buffer.writeln("  /* Controllers */");
    buffer.writeln("");
    buffer.writeln("  /* Models */");
    buffer.writeln("");
    buffer.writeln("  /* Actions */");
    buffer.writeln(getFunctionCode(name: 'test'));
    buffer.writeln("}");

    return buffer.toString();
  }

  /// Generates the controller file.
  void generate(List<String> functionList) {
    Terminal.printBold('\n1.Controller Generated.');

    String defaultCode = getControllerCode(functionList);
    print(defaultCode);
  }
}
