part of treemap_model;

abstract class DataModel {
  
  final StreamController<num> _sizeChangeController = new StreamController.broadcast();
  Stream<num> onSizeChange;
  AbstractBranch _root;
  AbstractBranch _parent;
  
  DataModel() {
    onSizeChange = _sizeChangeController.stream;
  }

  AbstractBranch get parent => _parent;

  AbstractBranch get root => this.isRoot ? this : parent.root;

  int get depth => this.isRoot ? 0 : 1 + parent.depth;

  bool get isRoot => _parent == null;

  bool get isBranch => !isLeaf;

  bool get isLeaf;

  num get size;
  
  Element provideNodeLabel();
  
  Element provideTooltip();  

  void _propagateSizeChange() {
    _sizeChangeController.add(size);
    if (parent != null) {
      parent._propagateSizeChange();
    }
  }
}