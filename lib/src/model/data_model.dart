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

  Branch get root => this.isRoot ? this : parent.root;

  List<DataModel> get children => _children != null ?
      _children : throw new UnsupportedError("A Leaf has no children");

  num get size => this.isLeaf ? _size : children.reduce(0, (prev,elem) => prev + elem.size);

  int get depth => this.isRoot ? 0 : 1 + parent.depth;

  
  bool get isBranch => !isLeaf;

  bool get isRoot => _parent == null;

  bool get isLeaf {
    try {
      this.children;
    } on UnsupportedError catch (ex) {
      return true;
    }
    return false;
  }
  
  /**
   * Creates a deep copy of [model].
   * The reference to a potential parent of [model] will **not** be copied to the clone.
   **/
  static DataModel copy(DataModel model) => model.isLeaf ?
      new Leaf._copy(model) :
      new Branch._copy(model);
}