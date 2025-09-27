import 'dart:io';
import 'package:quee_cli/quee.dart';

class FileHelper {
  static String readJson(String path) {
    try {
      return File(path).readAsStringSync();
    } catch (e) {
      Terminal.printError('Error reading JSON file: $e');
      exit(1);
    }
  }
}
