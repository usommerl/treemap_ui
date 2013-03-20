import 'package:unittest/unittest.dart';
import '../lib/src/utils/treemap_ui_utils.dart';

main() {
  group('color tests -', () {
    test('RGB wrong color value format 1 => exception)', () {
      expect(() => new Color.rgb([0,0]),
          throwsA(new isInstanceOf<ArgumentError>()));
    });
    test('RGB wrong color value format 2 => exception)', () {
      expect(() => new Color.rgb([0,0,0,0]),
          throwsA(new isInstanceOf<ArgumentError>()));
    });
    test('RGB wrong color value format 3 => exception)', () {
      expect(() => new Color.rgb([]),
          throwsA(new isInstanceOf<ArgumentError>()));
    });
    test('RGB wrong color value format 4 => exception)', () {
      expect(() => new Color.rgb(null),
          throwsA(new isInstanceOf<ArgumentError>()));
    });
    test('RGB wrong color value format 5 => exception)', () {
      expect(() => new Color.rgb([0,0,-1]),
          throwsA(new isInstanceOf<ArgumentError>()));
    });
    test('RGB wrong color value format 6 => exception)', () {
      expect(() => new Color.rgb([0,256,-0]),
          throwsA(new isInstanceOf<ArgumentError>()));
    });
    test('HEX wrong color value format 1 => exception)', () {
      expect(() => new Color.hex("XXX"),
          throwsA(new isInstanceOf<ArgumentError>()));
    });
    test('HEX wrong color value format 2 => exception)', () {
      expect(() => new Color.hex("xx"),
          throwsA(new isInstanceOf<ArgumentError>()));
    });
    test('HEX wrong color value format 3 => exception)', () {
      expect(() => new Color.hex("#0000007"),
          throwsA(new isInstanceOf<ArgumentError>()));
    });
    test('HEX wrong color value format 4 => exception)', () {
      expect(() => new Color.hex(null),
          throwsA(new isInstanceOf<ArgumentError>()));
    });
    test('HEX wrong color value format 5 => exception)', () {
      expect(() => new Color.hex(""),
          throwsA(new isInstanceOf<ArgumentError>()));
    });
  });
}

