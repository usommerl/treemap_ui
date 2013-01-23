part of treemap_utils;

class Orientation {

  final int _value;
  static const int _HORIZONTAL_VALUE = 0;
  static const int _VERTICAL_VALUE = 1;

  static final Orientation vertical = new Orientation._internal(_VERTICAL_VALUE);
  static final Orientation horizontal = new Orientation._internal(_HORIZONTAL_VALUE);

  Orientation._internal(this._value);

  bool get isVertical => this._value == _VERTICAL_VALUE;

  bool get isHorizontal => !isVertical;

  bool operator ==(Orientation other) => this._value == other._value;

  String toString() => this.isHorizontal ? "horizontal" : "vertical";

}
