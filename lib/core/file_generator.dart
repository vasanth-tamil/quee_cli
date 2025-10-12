import 'dart:io';
import 'package:interact_cli/interact_cli.dart';
import 'package:quee_cli/core/terminal.dart';
import 'package:quee_cli/helper/file_helper.dart';

class FileGenerator {
  void createFile(String outputPath, String fileName, String content) {
    // Check directory exists
    if (FileHelper.directoryExists(outputPath) == false) {
      bool isConfirm =
          Confirm(
            prompt: 'Can i create directory (Yes/no) ?',
            defaultValue: true,
          ).interact();

      if (isConfirm) {
        FileHelper.createDirectory(outputPath);
      } else {
        Terminal.printError('User declined to create directory.');
        exit(0);
      }
    }

    // Create file
    fileName = '$outputPath/$fileName';

    if (FileHelper.fileExists(fileName)) {
      bool isConfirm =
          Confirm(
            prompt: 'Can i overwrite file (Yes/no) ?',
            defaultValue: true,
          ).interact();

      if (isConfirm == false) {
        Terminal.printError('User declined to overwrite file.');
        exit(0);
      }
    }

    print('');
    FileHelper.createFile(fileName, content);
    Terminal.printSuccess('$fileName successfully generated.');
  }
}
