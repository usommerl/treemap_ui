part of treemap_ui_utils;

class Orientation {

  final int _value;
  static const int _HORIZONTAL_VALUE = 0;
  static const int _VERTICAL_VALUE = 1;

  static const Orientation VERTICAL = const Orientation._internal(_VERTICAL_VALUE);
  static const Orientation HORIZONTAL = const Orientation._internal(_HORIZONTAL_VALUE);

  const Orientation._internal(this._value);

  bool get isVertical => this._value == _VERTICAL_VALUE;

  bool get isHorizontal => !isVertical;

  bool operator ==(Orientation other) => this._value == other._value;

  String toString() => this.isHorizontal ? "horizontal" : "vertical";

}
