import 'package:args/args.dart';
import 'package:interact_cli/interact_cli.dart';
import 'package:quee_cli/controller_generator.dart';
import 'package:quee_cli/helper/file_helper.dart';
import 'package:quee_cli/helper/validation_helper.dart';
import 'package:quee_cli/page_generator.dart';
import 'package:quee_cli/quee.dart';
import 'package:quee_cli/service_generator.dart';

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
      'widget',
      abbr: 'w',
      negatable: false,
      help: 'Generates a new widget.',
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
        'Dialogues',
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
            outputPath: 'output/models',
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
