import 'package:clean_tracker/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Validators.email acepta correos válidos y rechaza inválidos', () {
    expect(Validators.email('nombre@correo.com'), isNull);
    expect(Validators.email('no-es-correo'), isNotNull);
  });

  test('Validators.password exige mínimo 8 caracteres', () {
    expect(Validators.password('12345678'), isNull);
    expect(Validators.password('1234'), isNotNull);
  });
}
