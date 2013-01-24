part of treemap_model;

class Branch extends DataModel {

  final List<DataModel> children;

  Branch(List<DataModel> this.children, [AncillaryData ancillaryData]) : super._internal(ancillaryData) {
    assert(children != null);
    children.forEach((child) => child._parent = this);
  }
  
  factory Branch.withTitle(List<DataModel> children, String title) {
    return new Branch(children, new SimpleTitleData(title));
  }

  Branch copy() {
    List<DataModel> childrenCopy = new List();
    children.forEach((child) => childrenCopy.add(child.copy()));
    return new Branch(childrenCopy, ancillaryData.copy());
  }

  num get size => children.reduce(0, (prev,elem) => prev + elem.size);

  bool get isLeaf => false;
}