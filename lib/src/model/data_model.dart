part of treemap.model;

abstract class DataModel {

  final StreamController<num> _modelChangeController = new StreamController.broadcast();
  Stream<num> _onModelChange;
  final StreamController _visualContentChangeController = new StreamController.broadcast();
  Stream _onVisualContentChange;
  AbstractBranch _root;
  AbstractBranch _parent;

  DataModel() {
    _onModelChange = _modelChangeController.stream;
    _onVisualContentChange = _visualContentChangeController.stream;
  }

  AbstractBranch get parent => _parent;

  AbstractBranch get root => this.isRoot ? this : parent.root;

  int get depth => this.isRoot ? 0 : 1 + parent.depth;

  bool get isRoot => _parent == null;

  bool get isBranch => !isLeaf;

  bool get isLeaf;

  num get size;

  Stream<int> get onModelChange => _onModelChange;

  Stream get onPropertyChange => _onVisualContentChange;

  Element provideNodeLabel();

  Element provideTooltip();

  void _propagateModelChange() {
    _modelChangeController.add(size);
    if (parent != null) {
      parent._propagateModelChange();
    }
  }

  void updateView() {
    _visualContentChangeController.add(null);
  }
}
