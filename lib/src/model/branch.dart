part of treemap_ui.model;

/// Base class for a custom  implementations of a branch in a tree data structure.
class Branch extends DataModel {

  /// A list of child elements of this branch.
  final ObservableList<DataModel> children;

  Branch([Iterable<DataModel> children])
          : children = children == null ?
                new ObservableList.from([]) :
                new ObservableList.from(children) {
    this.children.forEach((child) => _setParent(child));
    this.children.onAdd.listen((child) {
      _setParent(child);
      _propagateStructuralChange();
    });
    this.children.onRemove.listen((child) {
      child._parent = null;
      _propagateStructuralChange();
    });
    this.children.onUpdate.listen((event) {
      event.oldValue._parent = null;
      _setParent(event.newValue);
      _propagateStructuralChange();
    });
  }

  num get size => children.fold(0, (prev,elem) => prev + elem.size);

  bool get isLeaf => false;
  
  void _setParent(DataModel child) {
    final previousParent = child.parent;
    if (previousParent != null && !identical(previousParent,this)) {
      previousParent.children.remove(child);
    }
    child._parent = this;
  }
}


