part of treemap_model;

abstract class DataModel {

  Branch _root;
  Branch _parent;
  AncillaryData _ancillaryData;
  
  DataModel._internal([AncillaryData ancillaryData]) {
    if (ancillaryData != null) {
      this._ancillaryData = ancillaryData;
    } else {
      this._ancillaryData = new DebugData();
    }
    this._ancillaryData._model = this;
  }
  
  AncillaryData get ancillaryData => _ancillaryData;

  Branch get parent => _parent;

  Branch get root => this.isRoot ? this : parent.root;

  int get depth => this.isRoot ? 0 : 1 + parent.depth;

  bool get isRoot => _parent == null;

  bool get isBranch => !isLeaf;

  bool get isLeaf;

  num get size;

  /**
   * Creates a deep copy of this [DataModel].
   * The reference to a potential parent will **not** be copied to the clone.
   **/
  DataModel copy();
}