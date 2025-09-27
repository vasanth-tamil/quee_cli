import 'package:args/args.dart';
import 'package:quee_cli/helper/file_helper.dart';
import 'package:quee_cli/quee.dart';

const String version = '0.0.1';

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

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

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
    if (results.flag('model')) {
      String name = '';
      String jsonPath = '';
      String outputPath = 'examples/models';

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
      print('Name: $name');
      print('Json: $jsonPath');
      print('Out : $outputPath');
      print('');

      if (name.isEmpty || jsonPath.isEmpty) {
        Terminal.printError('Please provide a name and json path.');
        return;
      }

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
