part of treemap_model;

class Branch extends DataModel {
  Branch(List<DataModel> children, String title, [String description = ""]) {
    assert(children != null);
    _children = children;
    _title = title;
    _description = description;
    _children.forEach((c) => c._parent = this);
  }

  factory Branch._copy(Branch other) {
    List<DataModel> childrenCopy = new List();
    other._children.forEach((child) {childrenCopy.add(DataModel.copy(child));});
    return new Branch(childrenCopy, other._title, other._description);
  }
}