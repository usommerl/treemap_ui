part of treemap_model;

abstract class DataModel {

  String _title;
  String _description;
  Branch _root;
  Branch _parent;

  String get title => _title;

  String get description => _description;

  Branch get parent => _parent;

  Branch get root => this.isRoot ? this : parent.root;

  int get depth => this.isRoot ? 0 : 1 + parent.depth;

  bool get isRoot => _parent == null;

  bool get isBranch => !isLeaf;

  bool get isLeaf;

  num get size;

  /**
   * Creates a deep copy of [model].
   * The reference to a potential parent of [model] will **not** be copied to the clone.
   **/
  static DataModel copy(DataModel model) => model.isLeaf ?
      new Leaf._copy(model) :
      new Branch._copy(model);
}