import 'dart:io';

import 'package:args/args.dart';
import 'package:interact_cli/interact_cli.dart';
import 'package:quee_cli/controller_generator.dart';
import 'package:quee_cli/helper/file_helper.dart';
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
      final gift =
          Spinner(
            icon: '⚡',
            leftPrompt: (done) => '', // prompts are optional
            rightPrompt:
                (state) => switch (state) {
                  SpinnerStateType.inProgress => 'Processing...',
                  SpinnerStateType.done => 'Done $optionSelected !',
                  SpinnerStateType.failed => 'Failed!',
                },
          ).interact();

      await Future.delayed(const Duration(seconds: 3));
      gift.done();
      // print(optionSelected);

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

    // Page
    if (results.flag('page')) {
      if (results.rest.isEmpty) {
        Terminal.printError('No page name provided.');
        exit(1);
      }

      String name = results.rest[0];
      PageGenerator(name).generate();
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

    // Service
    if (results.flag('service')) {
      if (results.rest.isEmpty) {
        Terminal.printError('No Service name provided.');
        exit(1);
      }

      String name = results.rest[0];
      ServiceGenerator serviceGenerator = ServiceGenerator(name);

      if (results.rest.length < 2) {
        Terminal.printWarning('No functions provided.');
        bool useDefault = Terminal.askConfirmation('Use default functions');

        if (!useDefault) return;

        serviceGenerator.generate([
          'fetchAll:get',
          'fetchOne:get',
          'fetchById:get',
          'create:post',
          'update:put',
          'delete:delete',
        ]);
        return;
      }

      serviceGenerator.generate(results.rest.sublist(1));
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
