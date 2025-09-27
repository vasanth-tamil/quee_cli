import 'dart:io';


class FileGenerate {
  bool fileExists(String file) => File(file).existsSync();
  bool directoryExists(String directory) => Directory(directory).existsSync();

  void createFile(String file, String content) {
    File(file).writeAsStringSync(content);
    print('File created: $file');
  }

  void updateFile(String file, String content) {
    File(file).writeAsStringSync(content);
    print('File updated: $file');
  }

  void deleteFile(String file) {
    File(file).delete();
    print('File deleted: $file');
  }

  void createDirectory(String directory) {
    Directory(directory).createSync(recursive: true);
    print('Directory created: $directory');
  }

  void deleteDirectory(String directory) {
    Directory(directory).deleteSync(recursive: true);
    print('Directory deleted: $directory');
  }
}
