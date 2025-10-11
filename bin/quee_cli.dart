import 'dart:io';

import 'package:args/args.dart';
import 'package:interact_cli/interact_cli.dart';
import 'package:quee_cli/controller_generator.dart';
import 'package:quee_cli/helper/file_helper.dart';
import 'package:quee_cli/helper/validation_helper.dart';
import 'package:quee_cli/page_generator.dart';
import 'package:quee_cli/quee.dart';
import 'package:quee_cli/route_generator.dart';
import 'package:quee_cli/service_generator.dart';
import 'package:quee_cli/widget_generator.dart';

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
    ..addFlag(
      'model',
      abbr: 'm',
      negatable: false,
      help: 'Generates a new model.',
    )
    ..addFlag(
      'page',
      abbr: 'p',
      negatable: false,
      help: 'Generates a new page.',
    )
    ..addFlag(
      'widget',
      abbr: 'w',
      negatable: false,
      help: 'Generates a new widget.',
    )
    ..addFlag(
      'generate',
      abbr: 'g',
      negatable: false,
      help: 'Generates a new model.',
    )
    ..addFlag(
      'service',
      abbr: 's',
      negatable: false,
      help: 'Generates a new service.',
    )
    ..addFlag(
      'controller',
      abbr: 'c',
      negatable: false,
      help: 'Generates a new controller.',
    )
    ..addFlag(
      'route',
      abbr: 'r',
      negatable: false,
      help: 'Generates a new route and associates it with a page.',
    )
    ..addFlag(
      'dialog',
      abbr: 'd',
      negatable: false,
      help: 'Generates a new dialog.',
    )
    ..addFlag('version', negatable: false, help: 'Print the tool version.');
}

void printUsage(ArgParser argParser) {
  print('Usage: dart quee_cli.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) async {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    if (results.rest.isEmpty) {
      List<String> availableOptions = [
        'Controllers',
        'Models',
        'Pages',
        'Services',
        'Routes',
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

        ControllerGenerator(className, serviceName).generate(sortedFunctions);
      } else if (optionSelected == 'Models') {
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

        String pageType = pages.elementAt(selection);
        print(pageType);

        PageGenerator(name).generate(selection);
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

        ServiceGenerator(serviceName).generate(filteredFunctions);
      } else if (optionSelected == 'Routes') {}

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

    // Route
    if (results.flag('route')) {
      if (results.rest.isEmpty) {
        Terminal.printError('No route name provided.');
        exit(1);
      }

      List<String> routes = results.rest;
      RouteGenerator(routes, 'example/app_routes.dart').generate();
    }

    // Model
    if (results.flag('widget')) {
      if (results.rest.isEmpty) {
        Terminal.printError('No model name provided.');
        exit(1);
      }

      String name = results.rest[0];
      WidgetGenerator(name).generate();
    }

    // Controller
    if (results.flag('controller')) {
      if (results.rest.isEmpty) {
        Terminal.printError('No Controller name provided.');
        exit(1);
      }

      String name = results.rest[0];

      String service = Terminal.askMessageWithInput('Your Service name ? ');
      ControllerGenerator controllerGenerator = ControllerGenerator(
        name,
        service,
      );

      controllerGenerator.generate([]);
    }

    // test
    if (results.flag('model')) {
      String name = '';
      String jsonPath = '';
      String outputPath = 'output';

      // check
      print('');
      for (String command in results.rest) {
        final cmd = command.split(':');
        if (cmd[0] == 'name') {
          name = cmd[1];
        }
        if (cmd[0] == 'json') {
          jsonPath = cmd[1];
        }
        if (cmd[0] == 'out') {
          outputPath = cmd[1];
        }
      }

      if (name.isEmpty || jsonPath.isEmpty) {
        Terminal.printError('Please provide a name and json path.');
        Terminal.printInfo(
          'Example: dart run quee_cli --model name:user json:example/user.json',
        );
        return;
      }

      print('Name: $name');
      print('Json: $jsonPath');
      print('Out : $outputPath');
      String jsonString = FileHelper.readJson(jsonPath);

      var modelGenerate = ModelGenerator(
        jsonString,
        className: name,
        outputPath: outputPath,
        toJson: true,
        fromJson: true,
      );
      modelGenerate.generate();
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
