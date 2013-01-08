part of treemap_view;

class Orientation {

  static const int _horizontalValue = 0;
  static const int _verticalValue = 1;
  final int _value;
  static final Orientation VERTICAL = new Orientation._internal(_verticalValue);
  static final Orientation HORIZONTAL = new Orientation._internal(_horizontalValue);

  Orientation._internal(this._value);

  bool isVertical() => this._value == _verticalValue;

  bool isHorizontal() => !isVertical();

  bool equals(Orientation other) => this._value == other._value;

  String toString() => this.isHorizontal() ? "horizontalOrientation" : "verticalOrientation";

}
