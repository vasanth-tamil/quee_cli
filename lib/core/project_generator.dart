import 'dart:io';

import 'package:quee_cli/core/terminal.dart';

class ProjectInitializer {
  /// Creates the project directory and initial set of files,
  /// replacing the 'git clone' and 'git init/commit' operations.
  ///
  /// [projectName]: The name of the directory to be created.
  void createProjectFiles(String projectName) {
    Terminal.printText('Initializing project files for "$projectName"...');

    try {
      // 1. Create the project directory recursively
      final projectDir = Directory(projectName);
      if (projectDir.existsSync()) {
        Terminal.printError(
          'Directory "$projectName" already exists. Aborting.',
        );
        exit(1);
      }
      projectDir.createSync(recursive: true);

      // 2. Define content for initial files
      String pubspecContent = '''
name: $projectName
description: A new Flutter project.
environment:
  sdk: '>=3.0.0 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
  # Add other dependencies here
''';

      String mainDartContent = '''
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$projectName',
      home: const Center(
        child: Text('Hello World!'),
      ),
    );
  }
}
''';

      // 3. Write initial configuration files
      File('$projectName/pubspec.yaml').writeAsStringSync(pubspecContent);
      Terminal.printText('  > Created pubspec.yaml');

      // 4. Create lib directory and main file
      Directory('$projectName/lib').createSync();
      File('$projectName/lib/main.dart').writeAsStringSync(mainDartContent);
      Terminal.printText('  > Created lib/main.dart');

      // 5. Skip Git operations entirely (clone, init, commit)

      Terminal.printSuccess(
        'Project "$projectName" initialized successfully without cloning.',
      );
    } catch (e) {
      Terminal.printError('Failed to initialize project: $e');
      exit(1);
    }
  }
}

// Example usage:
// ProjectInitializer().createProjectFiles('my_new_app');
