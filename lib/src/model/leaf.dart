part of treemap_model;

class Leaf extends DataModel {

  num _size;

  Leaf(num size, String title, [String description = ""]) {
    assert(size > 0);
    _size = size;
    _title = title;
    _description = description;
  }

  factory Leaf._copy(Leaf other) {
    return new Leaf(other._size, other._title, other._description);
  }

  num get size => _size;

  bool get isLeaf => true;
}