class NameHelper {
  static String createFileName(String name, {String suffix = ''}) {
    return '${name.toLowerCase()}_$suffix.dart';
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

  String toPascalCase(String str) {
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
}
