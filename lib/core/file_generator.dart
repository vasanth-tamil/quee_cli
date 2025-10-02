import 'dart:io';
import 'package:quee_cli/core/terminal.dart';
import 'package:quee_cli/helper/file_helper.dart';

class FileGenerator {
  void createFile(String outputPath, String fileName, String content) {
    // Check directory exists
    if (FileHelper.directoryExists(outputPath) == false) {
      bool isConfirm = Terminal.askConfirmation(
        'Can i create directory (Yes/no) ?',
      );

      if (isConfirm) {
        FileHelper.createDirectory(outputPath);
      } else {
        Terminal.printError('User declined to create directory.');
        exit(0);
      }
    }

    // Create file
    fileName = '$outputPath/$fileName';

    FileHelper.createFile(fileName, content);
    Terminal.printSuccess('$fileName successfully generated.');
  }
}
