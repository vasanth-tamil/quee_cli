class ValidationHelper {
  static bool isValidInput(String input) {
    final lowerCase = RegExp(r'^[a-z-]+$');
    return lowerCase.hasMatch(input);
  }
}
