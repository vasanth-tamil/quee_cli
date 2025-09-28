import 'package:test/test.dart';
import 'package:quee_cli/helper/name_helper.dart';

void main() {
  group('NameHelper', () {
    final nameHelper = NameHelper();

    test('createFileName creates a valid file name', () {
      expect(
        NameHelper.createFileName('test', suffix: 'page'),
        'test_page.dart',
      );
    });

    test('toCapitalize capitalizes the first letter', () {
      expect(nameHelper.toCapitalize('string'), 'String');
      expect(nameHelper.toCapitalize('string_name'), 'String_name');
    });

    test(
      'toPascalCase converts from snake_case and kebab-case to PascalCase',
      () {
        expect(nameHelper.toPascalCase('string-home'), 'StringHome');
        expect(nameHelper.toPascalCase('string_home'), 'StringHome');
      },
    );

    test(
      'toCamelCase converts from snake_case and kebab-case to camelCase',
      () {
        expect(nameHelper.toCamelCase('string-home'), 'stringHome');
        expect(nameHelper.toCamelCase('string_home'), 'stringHome');
      },
    );
  });
}
