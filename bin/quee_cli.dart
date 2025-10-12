import 'dart:io';

import 'package:args/args.dart';
import 'package:interact_cli/interact_cli.dart';
import 'package:quee_cli/controller_generator.dart';
import 'package:quee_cli/core/quee_cli_config.dart';
import 'package:quee_cli/helper/code_helper.dart';
import 'package:quee_cli/helper/file_helper.dart';
import 'package:quee_cli/helper/validation_helper.dart';
import 'package:quee_cli/page_generator.dart';
import 'package:quee_cli/quee.dart';
import 'package:quee_cli/route_generator.dart';
import 'package:quee_cli/service_generator.dart';
import 'package:yaml/yaml.dart';

const String version = '0.0.3';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag('version', negatable: false, help: 'Print the tool version.');
}

void printUsage(ArgParser argParser) {
  print('Usage: dart quee_cli.dart <flags> [arguments]');
  print(argParser.usage);
}

QueeCliConfig? readQueeCliConfig(String fileName) {
  try {
    // 1. Define the path to your config file
    final configFile = File(fileName);

    if (!configFile.existsSync()) {
      print('Error: Configuration file not found at $fileName');
      return null;
    }
    // 2. Read the config file
    final yamlString = configFile.readAsStringSync();

    // 3. Convert the YAML string to a Dart object
    final yamlConfig = loadYaml(yamlString) as YamlMap;
    final config = QueeCliConfig.fromJson(yamlConfig);

    return config;
  } on FileSystemException catch (e) {
    print('File system error: $e');
    return null;
  } catch (e) {
    print('An error occurred: $e');
    return null;
  }
}

void main(List<String> arguments) async {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    QueeCliConfig? config = readQueeCliConfig('quee_config.yaml');

    if (config == null) {
      Terminal.printWarning('Using configuration file: quee_config.yaml');
      exit(1);
    }

    if (results.rest.isNotEmpty) {
      if (results.rest[0] == 'init') {
        String content = '''
name: quee_cli
version: $version

settings:
  route: lib/constants/app_routes.dart
  page: lib/pages
  controller: lib/controllers
  service: lib/services
  model:
    - lib/models/request
    - lib/models/response
''';

        if (FileHelper.fileExists('quee_configs.yaml') == false) {
          FileGenerator().createFile('.', 'quee_configs.yaml', content);
        } else {
          Terminal.printWarning('quee_configs.yaml already exists.');
          exit(1);
        }

        final gift =
            Spinner(
              icon: '🎁',
              leftPrompt: (done) => '',
              rightPrompt:
                  (state) => switch (state) {
                    SpinnerStateType.inProgress => 'Processing...',
                    SpinnerStateType.done => 'Done!',
                    SpinnerStateType.failed => 'Failed!',
                  },
            ).interact();

        await Future.delayed(const Duration(seconds: 1));
        gift.done();
      }
    }

    if (results.rest.isEmpty) {
      List<String> availableOptions = [
        'Controllers',
        'Models',
        'Pages',
        'Services',
        'Routes',
        'Exit',
      ];
      final option =
          Select(
            prompt: 'What do you want to do?',
            options: availableOptions,
          ).interact();

      final optionSelected = availableOptions[option];

      if (optionSelected == 'Controllers') {
        // Class Name
        String className =
            Input(
              prompt: 'Enter your controller name',
              validator: (String input) {
                if (input.trim().isEmpty) {
                  throw ValidationError('Input cannot be empty.');
                } else if (ValidationHelper.isValidInput(input)) {
                  return true;
                } else {
                  throw ValidationError(
                    'Invalid input provided. Only lowercase letters are allowed.',
                  );
                }
              },
            ).interact();

        // Service Name
        String serviceName =
            Input(
              prompt: 'Enter your service name',
              validator: (String input) {
                if (input.trim().isEmpty) {
                  throw ValidationError('Input cannot be empty.');
                } else if (ValidationHelper.isValidInput(input)) {
                  return true;
                } else {
                  throw ValidationError(
                    'Invalid input provided. Only lowercase letters are allowed.',
                  );
                }
              },
            ).interact();

        // Functions
        List<String> functions = [];
        bool isContinue;

        do {
          String funcName =
              Input(
                prompt: 'Enter your function name',
                validator: (String input) {
                  if (input.trim().isEmpty) {
                    throw ValidationError('Input cannot be empty.');
                  } else if (ValidationHelper.isValidInput(input)) {
                    return true;
                  } else {
                    throw ValidationError(
                      'Invalid input provided. Only lowercase letters are allowed.',
                    );
                  }
                },
              ).interact();

          functions.add(funcName);
          isContinue =
              Confirm(
                prompt: 'Do you want to add another function ?',
                defaultValue: true,
                waitForNewLine: true,
              ).interact();
        } while (isContinue == true);

        final sortedFunctions =
            Sort(
              prompt: 'Sort your functions ?',
              options: functions,
              showOutput: false,
            ).interact();

        ControllerGenerator(
          output: config.settings!.controller!,
          name: className,
          service: serviceName,
        ).generate(sortedFunctions);
      } else if (optionSelected == 'Models') {
        final jsonFiles = await FileHelper.listJsonFilesInDirectory(
          'example',
        ).then((value) => value.map((e) => e.path.split('/').last).toList());

        final selectedJsonFiles =
            MultiSelect(
              prompt: 'Select your json file ?',
              options: jsonFiles,
              defaults:
                  jsonFiles.map((i) => jsonFiles.indexOf(i) == 0).toList(),
            ).interact();

        // Functions
        List<Map<String, String>> models = [];

        for (var index in selectedJsonFiles) {
          String jsonFile = jsonFiles.elementAt(index);
          String defaultClassName = jsonFile
              .split(r'\')
              .last
              .split('.')[0]
              .replaceAll('_', '-');
          String className =
              Input(
                prompt: 'Enter your model name',
                defaultValue: defaultClassName,
                validator: (String input) {
                  if (input.trim().isEmpty) {
                    throw ValidationError('Input cannot be empty.');
                  } else if (ValidationHelper.isValidInput(input)) {
                    return true;
                  } else {
                    throw ValidationError(
                      'Invalid input provided. Only lowercase letters are allowed.',
                    );
                  }
                },
              ).interact();

          models.add({'json': jsonFile, 'name': className});
        }

        // Output
        final output =
            Select(
              prompt: 'Select your output directory ?',
              options: config.settings!.model!,
            ).interact();
        String modelOutput = config.settings!.model!.elementAt(output);

        // toJson, fromJson
        final options = ['toJson', 'fromJson'];
        final selectedOptions =
            MultiSelect(
              prompt: 'Do you want to generate Options ?',
              options: options,
              defaults: [true, true],
            ).interact();

        bool isToJson = (selectedOptions.indexOf(0) == 0);
        bool isFromJson = (selectedOptions.indexOf(1) == 1);

        for (var model in models) {
          String jsonPath = model['json'].toString();
          String name = model['name'].toString();

          String jsonString = FileHelper.readJson(jsonPath);

          var modelGenerate = ModelGenerator(
            jsonString,
            className: name,
            output: modelOutput,
            toJson: isToJson,
            fromJson: isFromJson,
          );
          modelGenerate.generate();
        }
      } else if (optionSelected == 'Pages') {
        final pages = ['Stateful Page', 'Stateless Page'];

        // Page Name
        String name =
            Input(
              prompt: 'Enter your page name',
              validator: (String input) {
                if (input.trim().isEmpty) {
                  throw ValidationError('Input cannot be empty.');
                } else if (ValidationHelper.isValidInput(input)) {
                  return true;
                } else {
                  throw ValidationError(
                    'Invalid input provided. Only lowercase letters are allowed.',
                  );
                }
              },
            ).interact();

        final selection =
            Select(
              prompt: 'Your service method ?',
              options: pages,
              initialIndex: 0,
            ).interact();

        PageGenerator(
          name: name,
          output: config.settings!.page!,
        ).generate(selection);
      } else if (optionSelected == 'Services') {
        final methods = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'];

        String serviceName =
            Input(
              prompt: 'Enter your service name',
              validator: (String input) {
                if (input.trim().isEmpty) {
                  throw ValidationError('Input cannot be empty.');
                } else if (ValidationHelper.isValidInput(input)) {
                  return true;
                } else {
                  throw ValidationError(
                    'Invalid input provided. Only lowercase letters are allowed.',
                  );
                }
              },
            ).interact();

        // Functions
        List<Map<String, String>> functionList = [];
        bool isContinue;

        do {
          String funcName =
              Input(
                prompt: 'Enter your function name',
                validator: (String input) {
                  if (input.trim().isEmpty) {
                    throw ValidationError('Input cannot be empty.');
                  } else if (ValidationHelper.isValidInput(input)) {
                    return true;
                  } else {
                    throw ValidationError(
                      'Invalid input provided. Only lowercase letters are allowed.',
                    );
                  }
                },
              ).interact();

          final selection =
              Select(
                prompt: 'Your service method ?',
                options: methods,
              ).interact();

          functionList.add({
            'func': funcName,
            'method': methods.elementAt(selection),
            'label': '$funcName (${methods.elementAt(selection)})',
          });
          isContinue =
              Confirm(
                prompt: 'Do you want to add another function ?',
                defaultValue: true,
                waitForNewLine: true,
              ).interact();
        } while (isContinue == true);

        final sortedFunctions =
            Sort(
              prompt: 'Sort your functions ?',
              options:
                  functionList.map((e) => e['label']).toList().cast<String>(),
              showOutput: false,
            ).interact();

        List<Map<String, String>> filteredFunctions = [];
        for (var sort in sortedFunctions) {
          for (var func in functionList) {
            if (func['label'] == sort) {
              filteredFunctions.add(func);
            }
          }
        }

        ServiceGenerator(
          name: serviceName,
          output: config.settings!.service!,
        ).generate(filteredFunctions);
      } else if (optionSelected == 'Routes') {
        // Routes
        List<String> routes = [];
        bool isContinue = true;
        String code = File(config.settings!.route!).readAsStringSync();

        do {
          String routeName =
              Input(
                prompt: 'Enter your route name',
                validator: (String input) {
                  if (input.trim().isEmpty) {
                    throw ValidationError('Input cannot be empty.');
                  } else if (ValidationHelper.isValidInput(input)) {
                    return true;
                  } else {
                    throw ValidationError(
                      'Invalid input provided. Only lowercase letters are allowed.',
                    );
                  }
                },
              ).interact();

          if (routes.contains(routeName)) {
            Terminal.printWarning(
              'Route name already exists. Please try again.',
            );
            continue;
          }

          if (CodeHelper.hasRouteConstant(code, routeName)) {
            Terminal.printWarning(
              'Route name already exists. Please try again.',
            );
            continue;
          }

          routes.add(routeName);
          isContinue =
              Confirm(
                prompt: 'Do you want to add another route ?',
                defaultValue: true,
                waitForNewLine: true,
              ).interact();
        } while (isContinue == true);

        final sortedRoutes =
            Sort(
              prompt: 'Sort your functions ?',
              options: routes,
              showOutput: false,
            ).interact();

        // Generate routes
        RouteGenerator(
          routeFile: config.settings!.route!,
          routes: sortedRoutes,
        ).generate();
      } else if (optionSelected == 'Dialogues') {
      } else if (optionSelected == 'Exit') {
        exit(0);
      }

      return;
    }

    // Process the parsed arguments.
    if (results.flag('help')) {
      printUsage(argParser);
      return;
    }
    if (results.flag('version')) {
      print('quee_cli version: $version');
      return;
    }

    if (results.flag('verbose')) {
      verbose = true;
    }

    // test
    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
