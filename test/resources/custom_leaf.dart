part of treemap_test_resources;

class CustomLeaf extends Leaf {

  int _someProperty = 0;

  CustomLeaf(num size) : super(size);

  set someProperty(int value) {
    _someProperty = value;
    fireVisiblePropertyChangedEvent();
  }

  int get someProperty => _someProperty;

  /**
   * Creates a deep copy of this [CustomLeaf].
   * The parent reference will **not** be copied to the clone.
   **/
  CustomLeaf copy() {
    return new CustomLeaf(size);
  }
}
