import 'package:quee_cli/helper/name_helper.dart';

class ModelHelper {
  String getType(String key, dynamic value, String parentClass) {
    if (value is int) {
      return 'int';
    } else if (value is double) {
      return 'double';
    } else if (value is bool) {
      return 'bool';
    } else if (value is String) {
      return 'String';
    } else if (value is List) {
      if (value.isEmpty) return 'List<dynamic>';
      var first = value.first;
      if (first is Map) {
        return 'List<${NameHelper().toPascalCase(key)}>';
      }
      return 'List<${getType(key, first, parentClass)}>';
    } else if (value is Map) {
      return NameHelper().toPascalCase(key);
    }
    return 'dynamic';
  }
}
