part of treemap_ui.model;

/// Base class for concrete implementations of a leaf in a tree data structure.
abstract class Leaf extends DataModel {

  num _size;

  Leaf(num this._size) {
      _validateSizeArgument(size);
  }

  bool get isLeaf => true;

  num get size => _size;

  set size(num size) {
    _validateSizeArgument(size);
    _size = size;
    _propagateStructuralChange();
  }

  void _validateSizeArgument(num size) {
    if (size == null || size < 0) {
      throw new ArgumentError("Size has to be a non-negative value");
    }
  }

  /// Background color of the corresponding treemap node.
  Color get color;
}

