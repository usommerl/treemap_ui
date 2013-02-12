part of treemap_test_resources;

class Leaf extends AbstractLeaf {
  
  Leaf(num size) : super(size); 
  
  Element provideNodeLabel() => new Element.html("<span></span>");
  
  Element provideTooltip() {
    Element element = new Element.html("<div></div>");
    element.style..backgroundColor = "white"
        ..fontSize = "0.8em"
        ..padding = "1px 5px 1px 5px";
    element.text = "Leaf, size: ${size}";
    return element;
  }
  
  Color provideBackgroundColor() => new Color.hex("DDD");
  
  /**
   * Creates a deep copy of this [Leaf].
   * The parent reference will **not** be copied to the clone.
   **/
  Leaf copy() {
    return new Leaf(size);
  }
}