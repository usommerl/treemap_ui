part of treemap.model;

abstract class AbstractBranch extends DataModel {

  final ObservableList<DataModel> children;

  AbstractBranch([Iterable<DataModel> children])
          : children = children == null ?
                new ObservableList.from([]) :
                new ObservableList.from(children) {
    this.children.forEach((child) => child._parent = this);
    this.children.onAdd.listen((newChild) {
      newChild._parent = this;
      _propagateModelChange();
    });
    this.children.onRemove.listen((removedChild) {
      removedChild._parent = null;
      _propagateModelChange();
    });
    this.children.onUpdate.listen((event) {
      event.oldValue._parent = null;
      event.newValue._parent = this;
      _propagateModelChange();
    });
  }

  num get size => children.reduce(0, (prev,elem) => prev + elem.size);

  bool get isLeaf => false;
}


