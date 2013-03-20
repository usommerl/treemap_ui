import 'dart:html';
import 'dart:async';
import '../resources/test_resources.dart';

main() {
    final size = window.innerHeight - 16;
    final componentRoot = document.query("#treemapContainer");
    componentRoot.style..width = "${size}px"..height = "${size}px";
    Treemap treemap;
    final leaf1 = new Leaf(100);
    final leaf2 = new Leaf(200);
    final leaf3 = new Leaf(700);
    var i = 0;
    leaf1.someProperty = Leaf.grayscale.length + i++;
    leaf2.someProperty = Leaf.grayscale.length + i++;
    leaf3.someProperty = Leaf.grayscale.length + i++;
    final copy1 = leaf1.copy();
    copy1.someProperty = Leaf.grayscale.length + i++;
    final copy2 = leaf2.copy();
    copy2.someProperty = Leaf.grayscale.length + i++;
    final copy3 = leaf3.copy();
    copy3.someProperty = Leaf.grayscale.length + i++;
    final model = (TestResources.dataModel5 as Branch).copy();
    treemap = new Treemap(componentRoot, model, TestResources.layoutAlgorithms.last);

    new Timer(const Duration(milliseconds: 500), () {
      new Timer(const Duration(milliseconds: 500), () => model.children.add(leaf1));
      new Timer(const Duration(milliseconds: 1000), () => model.children.add(leaf2));
      new Timer(const Duration(milliseconds: 1500), () => model.children.add(leaf3));
    });
    new Timer(const Duration(milliseconds: 2500), () {
      new Timer(const Duration(milliseconds: 500), () => model.children.remove(leaf1));
      new Timer(const Duration(milliseconds: 1000), () => model.children.remove(leaf2));
      new Timer(const Duration(milliseconds: 1500), () => model.children.remove(leaf3));
    });
    new Timer(const Duration(milliseconds: 4500), () {
      model.children.addAll([leaf1,leaf2,leaf3]);
      final length = model.children.length;
      new Timer(const Duration(milliseconds: 500), () => model.children[length-3] = copy1);
      new Timer(const Duration(milliseconds: 1000), () => model.children[length-2] = copy2);
      new Timer(const Duration(milliseconds: 1500), () => model.children[length-1] = copy3);
    });
    new Timer(const Duration(milliseconds: 7500), () {
      new Timer(const Duration(milliseconds: 500), () => model.children.removeLast());
      new Timer(const Duration(milliseconds: 1000), () => model.children.retainAll([copy2, copy1]));
      new Timer(const Duration(milliseconds: 2500), () => model.children.removeMatching(
         (e) => (e as Leaf).someProperty == 6));
      new Timer(const Duration(milliseconds: 3000), () => model.children.clear());
      new Timer(const Duration(milliseconds: 3500), () {
          var newModel = new Branch();
          treemap.model = newModel;
          newModel.children.addAll(TestResources.dataModel2.children);
        });
    });
}
