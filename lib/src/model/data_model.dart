part of treemap_model;

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