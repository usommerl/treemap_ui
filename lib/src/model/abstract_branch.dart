part of treemap_model;

abstract class AbstractBranch extends DataModel {

  final List<DataModel> children;

  AbstractBranch(List<DataModel> this.children) {
    assert(children != null);
    children.forEach((child) => child._parent = this);
  }

  num get size => children.reduce(0, (prev,elem) => prev + elem.size);

  bool get isLeaf => false;
}


