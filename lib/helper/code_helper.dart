class CodeHelper {
  static Map<String, String> extractArg(String arg) {
    var codes = arg.split(':');
    return {'func': codes[0], 'method': codes[1]};
  }
}
