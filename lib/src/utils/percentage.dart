part of treemap_utils;

class Percentage {
  
  final num _percentage;
  static final Percentage x100 = new Percentage._internal(100);
  static final Percentage x0 = new Percentage._internal(0);

  Percentage._internal(this._percentage){
    assert(_percentage >= 0 && _percentage <= 100);
  }

  factory Percentage.from(num amount, num basicValue) {
    assert(basicValue >= amount && amount >= 0);
    return new Percentage._internal((amount / basicValue) * 100);
  }

  num percentageValue(num basicValue) => (basicValue / 100) * this._percentage;

  Percentage of(Percentage other) => new Percentage._internal(this.percentageValue(other._percentage));

  Percentage operator +(Percentage other) => new Percentage._internal(this._percentage + other._percentage);

  Percentage operator -(Percentage other) => new Percentage._internal(this._percentage - other._percentage);

  bool operator ==(Percentage other) => this._percentage == other._percentage;

  String toString() => "${this._percentage.toString()}%";
}
