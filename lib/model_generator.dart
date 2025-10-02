import 'dart:convert';
import 'package:quee_cli/helper/name_helper.dart';
import 'package:quee_cli/quee.dart';

/// Generates a Dart model class from a JSON string.
class ModelGenerator {
  /// The JSON string to convert to a model.
  final String jsonString;

  /// The name of the class to generate.
  final String className;

  /// The path to output the generated file.
  final String outputPath;

  /// Whether to include a `toJson` method in the generated class.
  final bool toJson;

  /// Whether to include a `fromJson` factory constructor in the generated class.
  final bool fromJson;

  /// Creates a new instance of [ModelGenerator].
  ModelGenerator(
    this.jsonString, {
    this.className = 'test',
    required this.outputPath,
    this.toJson = false,
    this.fromJson = false,
  });

  final Map<String, String> _generatedClasses = {};

  /// Converts the JSON string to a Dart model.
  String jsonToModel() {
    Map<String, dynamic> map = jsonDecode(jsonString);

    _generatedClasses.clear();
    _generateClass(className, map);
    return _generatedClasses.values.join('\n\n');
  }

  /// Generates a class from a JSON map.
  void _generateClass(String nameStr, Map<String, dynamic> jsonMap) {
    if (_generatedClasses.containsKey(nameStr)) {
      return; // Avoid duplicates
    }

    StringBuffer buffer = StringBuffer();
    String name = NameHelper().toPascalCase(nameStr);

    buffer.writeln('class $name {');

    // Fields
    jsonMap.forEach((key, value) {
      String fieldName = NameHelper().toCamelCase(key);
      String type = _getType(key, value, name);
      if (type == 'dynamic') {
        buffer.writeln('  $type $fieldName;');
      } else {
        buffer.writeln('  $type? $fieldName;');
      }
    });

    // Constructor
    buffer.write('  $name({');
    jsonMap.forEach((key, _) {
      String fieldName = NameHelper().toCamelCase(key);
      buffer.write('this.$fieldName, ');
    });
    buffer.writeln('});\n');

    // fromJson named constructor
    if (fromJson) {
      buffer.writeln('  $name.fromJson(Map<String, dynamic> json) {');
      jsonMap.forEach((key, value) {
        String fieldName = NameHelper().toCamelCase(key);
        String type = _getType(key, value, name);
        if (_isCustomType(type)) {
          if (type.startsWith('List<')) {
            String subType = type.substring(5, type.length - 1);
            buffer.writeln('    if (json[\'$key\'] != null) {');
            buffer.writeln('      $fieldName = <$subType>[];');
            buffer.writeln('      json[\'$key\'].forEach((v) {');
            buffer.writeln('        $fieldName!.add($subType.fromJson(v));');
            buffer.writeln('      });');
            buffer.writeln('    }');
          } else {
            buffer.writeln(
              '    $fieldName = json[\'$key\'] != null ? $type.fromJson(json[\'$key\']) : null;',
            );
          }
        } else {
          buffer.writeln('    $fieldName = json[\'$key\'];');
        }
      });
      buffer.writeln('  }\n');
    }

    // toJson method
    if (toJson) {
      buffer.writeln('  Map<String, dynamic> toJson() {');
      buffer.writeln('    return {');
      jsonMap.forEach((key, value) {
        String fieldName = NameHelper().toCamelCase(key);
        if (_isCustomType(_getType(key, value, name))) {
          if (_getType(key, value, name).startsWith('List<')) {
            buffer.writeln(
              '      \'$key\': $fieldName!.map((v) => v.toJson()).toList(),',
            );
          } else {
            buffer.writeln('      \'$key\': $fieldName!.toJson(),');
          }
        } else {
          buffer.writeln('      \'$key\': $fieldName,');
        }
      });
      buffer.writeln('      };');
      buffer.writeln('    }');
    }

    buffer.write('}');

    _generatedClasses[name] = buffer.toString();

    // Recursively generate nested classes
    jsonMap.forEach((key, value) {
      if (value is Map) {
        _generateClass(
          NameHelper().toPascalCase(key),
          value as Map<String, dynamic>,
        );
      } else if (value is List && value.isNotEmpty && value.first is Map) {
        _generateClass(
          NameHelper().toPascalCase(key),
          value.first as Map<String, dynamic>,
        );
      }
    });
  }

  /// Infers the type of a value.
  String _getType(String key, dynamic value, String parentClass) {
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
      // infer type from first element
      return 'List<${_getType(key, first, parentClass)}>';
    } else if (value is Map) {
      return NameHelper().toPascalCase(key);
    }
    return 'dynamic';
  }

  /// Checks if a type is a custom type.
  bool _isCustomType(String type) {
    return !['int', 'double', 'bool', 'String', 'dynamic'].contains(type) &&
        !type.startsWith('List<dynamic>');
  }

  /// Generates the model file.
  void generate() {
    String modelCode = jsonToModel();

    String fileName = NameHelper.createFileName(className, suffix: 'model');
    String outputPath = 'output/models';

    FileGenerator().createFile(outputPath, fileName, modelCode);
  }
}
