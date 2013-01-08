library treemap_model;

abstract class DataModel {

  num _size;
  String _title;
  String _description;
  Branch _root;
  Branch _parent;
  List<DataModel> _children;

  String get title => _title;

  String get description => _description;

  Branch get parent => _parent;

  Branch get root {
    if (this.isRoot()) {
      return this;
    } else {
      return this.parent.root;
    }
  }

  List<DataModel> get children {
    if (_children == null) {
      throw new UnsupportedError("A Leaf has no children");
    } else {
      return _children;
    }
  }

  num get size {
    if (this.isLeaf()) {
      return _size;
    } else {
      return this.children.reduce(0, (prev,elem) => prev + elem.size);
    }
  }

  int get depth {
    if (this.isRoot()) {
      return 0;
    } else {
      return 1 + this.parent.depth;
    }
  }

  bool isLeaf() {
    try {
      this.children;
    } on UnsupportedError catch (ex) {
      return true;
    }
    return false;
  }

  bool isRoot() => _parent == null;

  /**
   * Creates a deep copy of [other].
   *
   * The reference to a potential parent [DataModel] of [other] will **not** be copied to the clone.
   *
   **/
  static DataModel copy(DataModel other) {
    if (other.isLeaf()) {
      return new Leaf._copy(other);
    } else {
      return new Branch._copy(other);
    }
  }
}

class Leaf extends DataModel {

  Leaf(num size, String title, [String description = ""]) {
    assert(size > 0);
    _size = size;
    _title = title;
    _description = description;
  }

  factory Leaf._copy(Leaf other) {
    return new Leaf(other._size, other._title, other._description);
  }
  String toString() => "<Leaf size=${_size}, title=${_title}>";
}

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