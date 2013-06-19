part of treemap_ui.model;

/**
 * Base class for a [Treemap] data model.
 *
 * The classes [Leaf] and [Branch] extend 
 * this class to compose a tree data structure.
 */
abstract class DataModel {

  Branch _root;
  Branch _parent;
  final StreamController _structuralChangeController = new StreamController.broadcast();
  final StreamController _visiblePropertyChangeController = new StreamController.broadcast();
  
  /// Parent [DataModel] of `this`.
  Branch get parent => _parent;

  /// Root [DataModel] of the entire data structure.
  Branch get root => this.isRoot ? this : parent.root;

  /**
   * Hierarchy level of this [DataModel]
   *
   * The [root] element of a [DataModel] has a depth of 0. 
   * Children of an element with depth n have a depth of n + 1.
   */ 
  int get depth => this.isRoot ? 0 : 1 + parent.depth;

  /// Value which is used to calculate the size of the corresponding treemap node.
  num get size;

  /**
   * Events which are triggered by changes to the structure of the data model.
   * 
   * Examples for structural changes are the removal of a child or the modification
   * of the [size] of a [DataModel]. This affects the entire visual representation 
   * of the treemap. The [DataModel] generates these events automatically and the 
   * [Treemap] instance listens to this stream to determine when it needs to repaint 
   * itself entirely.
   */
  Stream get onStructuralChange => _structuralChangeController.stream;

  /**
   * Events which are triggered by changes to the visual properties of this data model.
   *
   * The [Treemap] instance listens to this stream to determine when a node needs to be repainted.
   * A custom [DataModel] can generate such events by calling [fireVisiblePropertyChangedEvent].
   */
  Stream get onVisiblePropertyChange => _visiblePropertyChangeController.stream;

  /**
   * Notifies the treemap that a visual property has changed.
   *
   * Call this method in your custom data model when a property has
   * changed that affects the label, tooltip or color of a treemap node. 
   */
  void fireVisiblePropertyChangedEvent() {
    _visiblePropertyChangeController.add(null);
  }

  bool get isRoot => _parent == null;

  bool get isBranch => !isLeaf;

  bool get isLeaf;

  _propagateStructuralChange() {
    _structuralChangeController.add(null);
    if (parent != null) {
      parent._propagateStructuralChange();
    }
  }
}
