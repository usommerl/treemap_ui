part of treemap_test_resources;

class Branch extends AbstractBranch {
  
  Branch(List<DataModel> children) : super(children);
  
  Element provideNodeLabel() {
    Element element = new Element.html("<p align=center>&nbsp;</p>");
    
    element.style..marginBefore = "0px"
                 ..marginAfter = "0px";
    return element;
  }
  
  Element provideTooltip() {
    Element element = new Element.html("<div></div>");
    element.style..backgroundColor = "white"
        ..fontSize = "0.8em"
        ..padding = "1px 5px 1px 5px";
    element.text = "Branch (size: ${size}, depth: ${depth})";      
    return element;
  }
  
  /**
   * Creates a deep copy of this [Branch].
   * The parent reference will **not** be copied to the clone.
   **/
  Branch copy() {
    List<DataModel> childrenCopy = new List();
    children.forEach((child) => childrenCopy.add(child.copy()));
    return new Branch(childrenCopy);
  }
}