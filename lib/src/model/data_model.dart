part of treemap.model;

abstract class DataModel {

  final StreamController _structuralChangeController = new StreamController.broadcast();
  
  final StreamController _contentChangeController = new StreamController.broadcast();
  
  AbstractBranch _root;
  
  AbstractBranch _parent;

  AbstractBranch get parent => _parent;

  AbstractBranch get root => this.isRoot ? this : parent.root;

  int get depth => this.isRoot ? 0 : 1 + parent.depth;

  bool get isRoot => _parent == null;

  bool get isBranch => !isLeaf;

  bool get isLeaf;

  num get size;

  Stream get onStructuralChange => _structuralChangeController.stream;

  Stream get onContentChange => _contentChangeController.stream;

  Element provideNodeLabel();

  Element provideTooltip();

  void _propagateModelChange() {
    _structuralChangeController.add(null);
    if (parent != null) {
      parent._propagateModelChange();
    }
  }

  void repaintNode() {
    _contentChangeController.add(null);
  }
}
