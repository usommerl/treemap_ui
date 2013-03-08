part of treemap.model;

abstract class DataModel {

  final StreamController<num> _modelChangeController = new StreamController.broadcast();
  Stream<num> _onModelChange;
  final StreamController _nodeContentChangeController = new StreamController.broadcast();
  Stream _onNodeContentChange;
  AbstractBranch _root;
  AbstractBranch _parent;

  DataModel() {
    _onModelChange = _modelChangeController.stream;
    _onNodeContentChange = _nodeContentChangeController.stream;
  }

  AbstractBranch get parent => _parent;

  AbstractBranch get root => this.isRoot ? this : parent.root;

  int get depth => this.isRoot ? 0 : 1 + parent.depth;

  bool get isRoot => _parent == null;

  bool get isBranch => !isLeaf;

  bool get isLeaf;

  num get size;

  Stream<int> get onModelChange => _onModelChange;

  Stream get onNodeContentChange => _onNodeContentChange;

  Element provideNodeLabel();

  Element provideTooltip();

  void _propagateModelChange() {
    _modelChangeController.add(size);
    if (parent != null) {
      parent._propagateModelChange();
    }
  }

  void repaintNode() {
    _nodeContentChangeController.add(null);
  }
}
