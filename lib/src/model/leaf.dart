part of treemap_model;

class Leaf extends DataModel {

  Leaf(num size, String title, [String description = ""]) {
    assert(size > 0);
    _size = size;
    _title = title;
    _description = description;
  }

  factory Leaf._copy(Leaf other) {
    return new Leaf(other._size, other._title, other._description);
  }
  String toString() => "<Leaf size=${_size}, title=${_title}>";
}