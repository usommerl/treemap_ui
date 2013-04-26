part of treemap_ui.model;

abstract class DataModel {

  Stream _onStructuralChange;
  
  Stream _onContentChange;
  
  final StreamController _structuralChangeController = new StreamController();
  
  final StreamController _contentChangeController = new StreamController();
  
  DataModel() {
    _onStructuralChange = _structuralChangeController.stream.asBroadcastStream();
    _onContentChange = _contentChangeController.stream.asBroadcastStream();
  }
  
  AbstractBranch _root;
  
  AbstractBranch _parent;

  AbstractBranch get parent => _parent;

  AbstractBranch get root => this.isRoot ? this : parent.root;

  int get depth => this.isRoot ? 0 : 1 + parent.depth;

  bool get isRoot => _parent == null;

  bool get isBranch => !isLeaf;

  bool get isLeaf;

  num get size;

  Stream get onStructuralChange => _onStructuralChange;

  Stream get onContentChange => _onContentChange;

  Element get label;

  Element get tooltip;
  
  _propagateModelChange() {
    _structuralChangeController.add(null);
    if (parent != null) {
      parent._propagateModelChange();
    }
  }

  void repaintNode() {
    _contentChangeController.add(null);
  }
}
