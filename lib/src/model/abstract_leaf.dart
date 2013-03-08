part of treemap.model;

abstract class AbstractLeaf extends DataModel {

  num _size;

  AbstractLeaf(num this._size) {
      _validateSizeArgument(size);
  }

  bool get isLeaf => true;

  num get size => _size;

  set size(num size) {
    _validateSizeArgument(size);
    _size = size;
    _propagateModelChange();
  }

  void _validateSizeArgument(num size) {
    if (size == null || size < 0) {
      throw new ArgumentError("Size has to be a non-negative value");
    }
  }

  Color provideBackgroundColor();
}

