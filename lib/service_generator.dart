import 'package:quee_cli/helper/code_helper.dart';
import 'package:quee_cli/helper/name_helper.dart';
import 'package:quee_cli/quee.dart';

/// Generates a service class.
class ServiceGenerator {
  /// The name of the service.
  String name = '';

  /// Creates a new instance of [ServiceGenerator].
  ServiceGenerator(this.name);

  /// Generates a function for the service.
  StringBuffer getFunctionCode({
    required String name,
    String method = 'get',
    String url = 'ApiConstants.fetch(id)',
    bool isAuth = false,
    bool isDebug = true,
  }) {
    StringBuffer buffer = StringBuffer();

    buffer.writeln("  /* ${method.toUpperCase()}: $name */");
    buffer.writeln("  Future<Response> $name() async {");
    buffer.writeln("    final response = await Requests(");
    buffer.writeln("      method: Requests.$method,");
    buffer.writeln("      url: $url,");
    buffer.writeln("      data: {},");
    if (isAuth) {
      buffer.writeln("      isAuth: true,");
    }
    if (isDebug) {
      buffer.writeln("      isDebug: true,");
    }
    buffer.writeln("    ).send();");
    buffer.writeln("    return response;");
    buffer.writeln("  }");
    buffer.writeln("");

    return buffer;
  }

  /// Generates the code for the service class.
  String getServiceCode(List<String> functions) {
    StringBuffer buffer = StringBuffer();

    String className = NameHelper.toClassName('$name-service');

    buffer.writeln("import 'package:template/constants/app_apis.dart';");
    buffer.writeln("import 'package:template/helpers/request_helper.dart';");
    buffer.writeln("import 'package:template/models/response.dart';");
    buffer.writeln("");
    buffer.writeln("class $className {");
    for (String func in functions) {
      Map<String, String> data = CodeHelper.extractArg(func);
      buffer.write(
        getFunctionCode(
          name: data['func']!,
          method: data['method']!,
          url: 'ApiConstants.test',
          isAuth: false,
        ),
      );
    }
    buffer.writeln("}");

    return buffer.toString();
  }

  /// Generates the service file.
  void generate(List<String> functionList) {
    Terminal.printBold('\n1.Service Generated.');

    String defaultCode = getServiceCode(functionList);
    print(defaultCode);
  }
}
