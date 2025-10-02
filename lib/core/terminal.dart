import 'dart:io';

class Terminal {
  List<String> confirmationList = ['y', 'yes'];

  static bool askConfirmation(String? message) {
    stdout.write("${message ?? 'You sure'} (Yes/no) ? ");
    String input = stdin.readLineSync() ?? '';

    return Terminal().confirmationList.contains(input.toLowerCase().trim());
  }

  static String askMessageWithInput(String message) {
    String input = stdin.readLineSync() ?? '';

    if (input.isEmpty) {
      askConfirmation(message);
    }
    return input.toLowerCase().trim();
  }

  static String askOptionsWithInput(
    String title,
    List<Map<String, dynamic>> options,
  ) {
    printBold(title);

    for (var i = 0; i < options.length; i++) {
      printText('${options[i]['value']}. ${options[i]['label']}');
    }

    stdout.write('\nYour choice ? ');
    String input = stdin.readLineSync() ?? '';

    List<String> availableOptions =
        options.map((e) => e['value'].toString()).toList();

    if (availableOptions.contains(input) == false) {
      askOptionsWithInput(title, options);
    }

    for (var i = 0; i < options.length; i++) {
      if (options[i]['value'] == input) {
        options[i]['action']();
        break;
      }
    }

    return input;
  }

  static void _log(String message, String startCode, [String? icon]) {
    final prefix = icon != null ? '$icon ' : '';
    print('$startCode$prefix$message\x1B[0m');
  }

  static void printText(String message) => print(message);

  static void printError(String message) => _log(message, '\x1B[31m', '✖');

  static void printSuccess(String message) => _log(message, '\x1B[32m', '✓');

  static void printWarning(String message) => _log(message, '\x1B[33m', '⚠');

  static void printInfo(String message) => _log(message, '\x1B[34m', 'i');

  static void printDebug(String message) => _log(message, '\x1B[35m', 'd');

  static void printBold(String message) => _log(message, '\x1B[1m');

  static void printUnderline(String message) => _log(message, '\x1B[4m');

  static void printReverse(String message) => _log(message, '\x1B[7m');
}
