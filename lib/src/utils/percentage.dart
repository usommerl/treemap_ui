part of treemap_ui.utils;

class Percentage {

  final num _percentage;
  static const Percentage ONE_HUNDRED = const Percentage._internal(100);
  static const Percentage ZERO = const Percentage._internal(0);

  const Percentage._internal(this._percentage);

  factory Percentage.from(num amount, num basicValue) {
    assert(amount >= 0);
    assert(basicValue >= amount);
    if (amount == 0) {
      return Percentage.ZERO;
    } else {
      return new Percentage._internal((amount / basicValue) * 100);
    }
  }

  num percentageValue(num basicValue) => (basicValue / 100) * this._percentage;

  Percentage of(Percentage other) => new Percentage._internal(this.percentageValue(other._percentage));

  Percentage operator +(Percentage other) => new Percentage._internal(this._percentage + other._percentage);

  Percentage operator -(Percentage other) => new Percentage._internal(this._percentage - other._percentage);

  bool operator ==(Percentage other) => this._percentage == other._percentage;

  String toString() => "${this._percentage.toString()}%";
}
