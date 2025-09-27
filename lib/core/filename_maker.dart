import 'dart:io';

import 'package:quee_cli/core/file_generate.dart';
import 'package:quee_cli/core/terminal.dart';

class FilenameMaker {
  String createFileName(String name, {String suffix = ''}) {
    return '${name.toLowerCase()}_$suffix.dart';
  }

  String createModelFileName(String name) =>
      createFileName(name, suffix: 'model');
  String createControllerFileName(String name) =>
      createFileName(name, suffix: 'controller');
  String createServiceFileName(String name) =>
      createFileName(name, suffix: 'service');
  String createRouteFileName(String name) =>
      createFileName(name, suffix: 'route');
  String createDialogFileName(String name) =>
      createFileName(name, suffix: 'dialog');
  String createWidgetFileName(String name) =>
      createFileName(name, suffix: 'widget');
  String createPageFileName(String name) =>
      createFileName(name, suffix: 'page');

  void createFile(String outputPath, String fileName, String content) {
    FileGenerate fileGenerate = FileGenerate();

    // Check directory exists
    if (FileGenerate().directoryExists(outputPath) == false) {
      bool isConfirm = Terminal.askConfirmation(
        'Can i create directory (Yes/no) ?',
      );

      if (isConfirm) {
        FileGenerate().createDirectory(outputPath);
      } else {
        Terminal.printError('User declined to create directory.');
        exit(0);
      }
    }
    fileName = '$outputPath/${createModelFileName(fileName)}';
    fileGenerate.createFile(fileName, content);
    Terminal.printSuccess('$fileName Model successfully generated.');
  }
}
