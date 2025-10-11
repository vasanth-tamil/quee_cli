import 'dart:io';
import 'package:quee_cli/quee.dart';

class FileHelper {
  static bool fileExists(String file) => File(file).existsSync();
  static bool directoryExists(String directory) =>
      Directory(directory).existsSync();

  static void createFile(String file, String content) {
    File(file).writeAsStringSync(content);
    print('File created: $file');
  }

  static void updateFile(String file, String content) {
    File(file).writeAsStringSync(content);
    print('File updated: $file');
  }

  static void deleteFile(String file) {
    File(file).delete();
    print('File deleted: $file');
  }

  static void createDirectory(String directory) {
    Directory(directory).createSync(recursive: true);
    print('Directory created: $directory');
  }

  static void deleteDirectory(String directory) {
    Directory(directory).deleteSync(recursive: true);
    print('Directory deleted: $directory');
  }

  static Future<List<File>> listFilesInDirectory(String path) async {
    final dir = Directory(path);
    final List<File> files = [];

    await for (FileSystemEntity entity in dir.list(
      recursive: false,
      followLinks: false,
    )) {
      if (entity is File) {
        files.add(entity);
      }
    }

    return files;
  }

  static Future<List<File>> listJsonFilesInDirectory(String path) async {
    final dir = Directory(path);
    final List<File> files = [];

    await for (FileSystemEntity entity in dir.list(
      recursive: false,
      followLinks: false,
    )) {
      if (entity is File) {
        if (entity.path.endsWith('.json')) {
          files.add(entity);
        }
      }
    }

    return files;
  }

  static String readJson(String path) {
    try {
      return File(path).readAsStringSync();
    } catch (e) {
      Terminal.printError('Error reading JSON file: $e');
      exit(1);
    }
  }
}
