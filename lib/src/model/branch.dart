part of treemap_model;

class Branch extends DataModel {

  final List<DataModel> children;

  Branch(this.children, String title, [String description = ""]) {
    assert(children != null);
    _title = title;
    _description = description;
    children.forEach((child) => child._parent = this);
  }

  factory Branch._copy(Branch other) {
    List<DataModel> childrenCopy = new List();
    other.children.forEach((child) {childrenCopy.add(DataModel.copy(child));});
    return new Branch(childrenCopy, other._title, other._description);
  }

  num get size => children.reduce(0, (prev,elem) => prev + elem.size);

  bool get isLeaf => false;
}