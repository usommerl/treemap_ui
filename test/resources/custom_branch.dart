part of treemap_test_resources;

class CustomBranch extends Branch implements CustomModel{

  CustomBranch([List<DataModel> children]) : super(children) {
    var counter = 0;
    this.children.forEach((child) {
      if (child.isLeaf) {
        (child as CustomLeaf).someProperty = counter++;
      }
    });
  }

  /**
   * Creates a deep copy of this [CustomBranch].
   * The parent reference will **not** be copied to the clone.
   **/
  CustomBranch copy() {
    List<DataModel> childrenCopy = new List();
    children.forEach((CustomModel child) => childrenCopy.add(child.copy()));
    return new CustomBranch(childrenCopy);
  }
}
