library treemap_utils;


class Percentage {
  
  static final Percentage p100 = new Percentage._internal(100);
  static final Percentage p0 = new Percentage._internal(0);
  
  num _p;
  
  Percentage._internal(num percentage) {
    assert(percentage >= 0 && percentage <= 100);
    this._p = percentage;
  }
  
  factory Percentage.from(num amount, num basicValue) {
    assert(basicValue >= amount && amount >= 0);
    return new Percentage._internal((amount / basicValue) * 100);
  }
  
  num percentageValue(num basicValue) => (basicValue / 100) * this._p;
  
  Percentage of(Percentage other) => new Percentage._internal(this.percentageValue(other._p));
  
  operator +(Percentage other) => new Percentage._internal(this._p + other._p);
  
  operator -(Percentage other) => new Percentage._internal(this._p - other._p);
  
  operator ==(Percentage other) => this._p == other._p;
  
  String toString() => "${this._p.toString()}%";
  
}