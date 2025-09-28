import 'dart:io';

class Terminal {
  List<String> confirmationList = ['y', 'yes'];

  static bool askConfirmation(String? message) {
    stdout.write("${message ?? 'You sure'} (Yes/no) ? ");
    String input = stdin.readLineSync() ?? '';

    return Terminal().confirmationList.contains(input.toLowerCase().trim());
  }

  static String askMessageWithInput(String message) {
    stdout.write(message);
    String input = stdin.readLineSync() ?? '';

    if (input.isEmpty) {
      askConfirmation(message);
    }
    return input.toLowerCase().trim();
  }

  static void printError(String message) {
    print('\x1B[31m✖ $message\x1B[0m');
  }

  static void printSuccess(String message) {
    print('\x1B[32m✓ $message\x1B[0m');
  }

  static void printWarning(String message) {
    print('\x1B[33m⚠ $message\x1B[0m');
  }

  static void printInfo(String message) {
    print('\x1B[34mi $message\x1B[0m');
  }

  static void printDebug(String message) {
    print('\x1B[35md $message\x1B[0m');
  }

  static void printBold(String message) {
    print('\x1B[1m$message\x1B[0m');
  }

  static void printUnderline(String message) {
    print('\x1B[4m$message\x1B[0m');
  }

  static void printReverse(String message) {
    print('\x1B[7m$message\x1B[0m');
  }
}
