import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';
import 'package:treemap_ui/model.dart';
import '../resources/test_resources.dart';

main() {
  useHtmlConfiguration();
  group('model tests -', () {
    var leaf1, leaf2, leaf3, branch1, branch2;

    setUp(() {
      leaf1 = new LeafImpl(5);
      leaf2 = new LeafImpl(2);
      leaf3 = new LeafImpl(10);
      branch1 = new BranchImpl([leaf1,leaf2]);
      branch2 = new BranchImpl([branch1,leaf3]);
    });

    test('x.size (branch with two leafes)', () {
      expect(branch1.size, equals(leaf1.size + leaf2.size));
    });
    test('x.size (branch with three leafes)', () {
      expect(branch2.size, equals(branch1.size + leaf3.size));
    });
    test('${new LeafImpl(1).runtimeType}(size,...) (size < 0 => exception)', () {
      expect(() => new LeafImpl(-1),
          throwsA(new isInstanceOf<ArgumentError>()));
    });
    test('x.depth', () {
      expect(leaf1.depth, equals(2));
      expect(leaf3.depth, equals(1));
      expect(branch2.depth, equals(0));
    });
    test('x.parent', () {
      expect(leaf1.parent, equals(branch1));
      expect(leaf2.parent, equals(branch1));
      expect(branch1.parent, equals(branch2));
      expect(leaf3.parent, equals(branch2));
    });
    test('x.root', () {
      expect(leaf1.root, equals(branch2));
      expect(leaf2.root, equals(branch2));
      expect(leaf3.root, equals(branch2));
      expect(branch1.root, equals(branch2));
      expect(branch2.root, equals(branch2));
    });
    test('x.isLeaf()', () {
      expect(leaf1.isLeaf, isTrue);
      expect(leaf2.isLeaf, isTrue);
      expect(leaf3.isLeaf, isTrue);
      expect(branch1.isLeaf, isFalse);
      expect(branch2.isLeaf, isFalse);
    });
  });
}
