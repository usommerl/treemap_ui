part of treemap_test_resources;

class BranchImpl extends Branch {

  BranchImpl([List<DataModel> children]) : super(children) {
    var counter = 0;
    this.children.forEach((child) {
      if (child.isLeaf) {
        (child as LeafImpl).someProperty = counter++;
      }
    });
  }

  Element get label => new Element.html('<span>Branch</span>');

  Element get tooltip {
    Element element = new Element.html("<div></div>");
    element.style..backgroundColor = "white"
        ..fontSize = "0.8em"
        ..padding = "1px 5px 1px 5px";
    element.text = "Branch [size: ${size}]";
    return element;
  }

  /**
   * Creates a deep copy of this [BranchImpl].
   * The parent reference will **not** be copied to the clone.
   **/
  BranchImpl copy() {
    List<DataModel> childrenCopy = new List();
    children.forEach((child) => childrenCopy.add(child.copy()));
    return new BranchImpl(childrenCopy);
  }
}
