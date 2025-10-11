class NameHelper {
  static String createFileName(String name, {String suffix = ''}) {
    return '${name.toLowerCase()}_$suffix.dart';
  }

  static String toUnderscoreName(String name) {
    return name
        .replaceAllMapped(
          RegExp(r'(?<=[a-z])(?=[A-Z-])'),
          (match) => '_${match.group(0)!.toLowerCase()}',
        )
        .replaceAll('-', '');
  }

  static String toClassName(String input) {
    final cleaned = input.replaceAll(RegExp(r'[_\-]+'), ' ').trim();
    final parts = cleaned.split(RegExp(r' +'));
    final className =
        parts.map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        }).join();
    return className.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
  }

  String toCamelCaseToUnderscore(String str) =>
      str
          .replaceAllMapped(
            RegExp(r'(?<=[a-z])(?=[A-Z])'),
            (match) => '_${match.group(0)!.toLowerCase()}',
          )
          .toLowerCase();

  String toCapitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1);
  }

  bool isPascalCase(String str) {
    return RegExp(r'^[A-Z][a-z0-9]+(?:[A-Z][a-z0-9]+)*$').hasMatch(str);
  }

  String toPascalCase(String str) {
    if (isPascalCase(str)) return str;

    return str
        .split(RegExp(r'[-_]'))
        .map((s) {
          if (s.isEmpty) return '';
          return s[0].toUpperCase() + s.substring(1).toLowerCase();
        })
        .join('');
  }

  String toCamelCase(String str) {
    final pascal = toPascalCase(str);
    if (pascal.isEmpty) return '';
    return pascal[0].toLowerCase() + pascal.substring(1);
  }

  String toDashCase(String str) {
    return str
        .replaceAll(RegExp(r'[ _]+'), '-')
        .replaceAllMapped(RegExp(r'(?<=[a-z0-9])(?=[A-Z])'), (match) => '-')
        .toLowerCase();
  }
}
