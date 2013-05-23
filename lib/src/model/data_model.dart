part of treemap_ui.model;

/**
 * Base class for a [Treemap] data model.
 *
 * The classes [AbstractLeaf] and [AbstractBranch] extend 
 * this class to compose a tree data structure.
 */
abstract class DataModel {

  AbstractBranch _root;
  AbstractBranch _parent;
  Stream _onStructuralChange;
  Stream _onContentChange;
  final StreamController _structuralChangeController = new StreamController();
  final StreamController _contentChangeController = new StreamController();
  
  DataModel() {
    _onStructuralChange = _structuralChangeController.stream.asBroadcastStream();
    _onContentChange = _contentChangeController.stream.asBroadcastStream();
  }
  
  /// Parent object of `this`.
  AbstractBranch get parent => _parent;

  /// Root object of the entire data structure.
  AbstractBranch get root => this.isRoot ? this : parent.root;

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
   * Structural changes are for example the removal of a child or the modification
   * of the [size] of a data model. It is called structural change because such modifications
   * affect the entire visual representation of a treemap. A [Treemap] instance listens to 
   * this stream to determine when it needs to repaint itself entirely.
   */
  Stream get onStructuralChange => _onStructuralChange;

  /**
   * Events which are triggered by changes to the visual properties of this data model.
   *
   * The treemap listens to this stream to determine when a single node needs to be repainted.
   * A custom [DataModel] can generate such events by calling [repaintNode].
   */
  Stream get onContentChange => _onContentChange;

  /// HTML element that will be displayed as the label of the corresponding treemap node.
  Element get label;

  /// HTML element that will be displayed as the tooltip of the corresponding treemap node.
  Element get tooltip;

  /**
   * Triggers a [onContentChange] event.
   *
   * Use this method in a concrete data model to notify the treemap that a 
   * property has changed which in turn affects the label, tooltip or color 
   * of the corresponding node.
   */
  void repaintNode() {
    _contentChangeController.add(null);
  }

  bool get isRoot => _parent == null;

  bool get isBranch => !isLeaf;

  bool get isLeaf;

  _propagateModelChange() {
    _structuralChangeController.add(null);
    if (parent != null) {
      parent._propagateModelChange();
    }
  }
}
