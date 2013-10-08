import 'package:unittest/unittest.dart';
import 'package:treemap_ui/model.dart';

main() {
  group('model tests -', () {
    var leaf1, leaf2, leaf3, branch1, branch2;

    setUp(() {
      leaf1 = new Leaf(5);
      leaf2 = new Leaf(2);
      leaf3 = new Leaf(10);
      branch1 = new Branch([leaf1,leaf2]);
      branch2 = new Branch([branch1,leaf3]);
    });

    test('x.size (branch with two leafes)', () {
      expect(branch1.size, equals(leaf1.size + leaf2.size));
    });
    test('x.size (branch with three leafes)', () {
      expect(branch2.size, equals(branch1.size + leaf3.size));
    });
    test('${new Leaf(1).runtimeType}(size,...) (size < 0 => exception)', () {
      expect(() => new Leaf(-1),
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
    test('A Leaf can only be a child of one branch 1', () {
      final leaf = new Leaf(1);
      final branchA = new Branch([leaf]);
      final branchB = new Branch([leaf]);
      expect(branchB.children.contains(leaf), isTrue);
      expect(branchA.children.contains(leaf), isFalse);
    });
    test('A Leaf can only be a child of one branch 2', () {
      final leaf = new Leaf(1);
      final branchA = new Branch([leaf]);
      final branchB = new Branch();
      branchB.children.onAdd.listen((_) {
        expect(branchB.children.contains(leaf), isTrue);
        expect(branchA.children.contains(leaf), isFalse);
      });
      branchB.children.add(leaf);
    });
    test('A Leaf can only be a child of one branch 3', () {
      final leaf = new Leaf(1);
      final branchA = new Branch([leaf]);
      final branchB = new Branch([new Leaf(99)]);
      branchB.children.onUpdate.listen((_) {
        expect(branchB.children.contains(leaf), isTrue);
        expect(branchA.children.contains(leaf), isFalse);
      });
      branchB.children[0] = leaf;
    });
  });
}
