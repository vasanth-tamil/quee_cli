import 'dart:convert';
import 'dart:io';
import 'package:quee_cli/core/file_generate.dart';
import 'package:quee_cli/core/terminal.dart';
import 'package:quee_cli/helper/name_helper.dart';

class ModelGenerator {
  final String jsonString;
  final String className;
  final String outputPath;
  final bool toJson;
  final bool fromJson;

  ModelGenerator(
    this.jsonString, {
    this.className = 'test',
    required this.outputPath,
    this.toJson = false,
    this.fromJson = false,
  });

  final Map<String, String> _generatedClasses = {};

  String jsonToModel() {
    Map<String, dynamic> map = jsonDecode(jsonString);

    _generatedClasses.clear();
    _generateClass(className, map);
    return _generatedClasses.values.join('\n\n');
  }

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
      buffer.writeln('  $type? $fieldName;');
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
      buffer.writeln(
        '    final Map<String, dynamic> data = <String, dynamic>{};',
      );
      jsonMap.forEach((key, value) {
        String fieldName = NameHelper().toCamelCase(key);
        buffer.writeln('    if ($fieldName != null) {');
        if (_isCustomType(_getType(key, value, name))) {
          if (_getType(key, value, name).startsWith('List<')) {
            buffer.writeln(
              '      data[\'$key\'] = $fieldName!.map((v) => v.toJson()).toList();',
            );
          } else {
            buffer.writeln('      data[\'$key\'] = $fieldName!.toJson();');
          }
        } else {
          buffer.writeln('      data[\'$key\'] = $fieldName;');
        }
        buffer.writeln('    }');
      });
      buffer.writeln('    return data;');
      buffer.writeln('  }');
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

  bool _isCustomType(String type) {
    return !['int', 'double', 'bool', 'String', 'dynamic'].contains(type) &&
        !type.startsWith('List<dynamic>');
  }

  void generate() {
    String modelCode = jsonToModel();

    FileGenerate fileGenerate = FileGenerate();

    // check directory
    if (FileGenerate().directoryExists(outputPath) == false) {
      stdout.write("Can i create directory (Yes/no) ? ");
      String input = stdin.readLineSync() ?? '';
      List<String> confirmationList = ['y', 'Y', 'Yes', 'yes'];

      if (confirmationList.contains(input)) {
        FileGenerate().createDirectory(outputPath);
      } else {
        Terminal.printError('User declined to create directory.');
        exit(0);
      }
    }

    String fileName =
        '$outputPath/${NameHelper().toCamelCaseToUnderscore(className)}.dart';
    fileGenerate.createFile(fileName, modelCode);
    // print(modelCode);
    Terminal.printSuccess('$fileName Model successfully generated.');
  }
}
