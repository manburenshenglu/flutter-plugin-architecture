import 'package:flutter_test/flutter_test.dart';
import 'package:module_auth/src/data/remote/parsers/login_xml_parser.dart';

void main() {
  const parser = LoginXmlParser();

  test('parses success payload with userId and message', () {
    const xml = '''
<response>
  <success>true</success>
  <userId>u-100</userId>
  <message>ok</message>
</response>
''';

    final dto = parser.parse(xml);

    expect(dto.success, isTrue);
    expect(dto.userId, 'u-100');
    expect(dto.message, 'ok');
  });

  test('treats code=0 as success when success field is missing', () {
    const xml = '''
<result>
  <code>0</code>
  <msg>login ok</msg>
  <data>
    <uid>legacy-1</uid>
  </data>
</result>
''';

    final dto = parser.parse(xml);

    expect(dto.success, isTrue);
    expect(dto.userId, 'legacy-1');
    expect(dto.message, 'login ok');
  });

  test('returns failed dto for empty payload', () {
    final dto = parser.parse('   ');

    expect(dto.success, isFalse);
    expect(dto.message, 'Empty XML response');
  });
}
