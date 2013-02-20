part of treemap_test_resources;

class Leaf extends AbstractLeaf {
  
  int _someProperty = 0;
  
  List<Color> colors = [Color.LIGHT_GRAY, Color.CRIMSON, Color.GOLD, Color.KHAKI, 
                        Color.LIGHT_STEEL_BLUE, Color.MEDIUM_VIOLET_RED, 
                        Color.ROSY_BROWN, Color.YELLOW_GREEN];

  Leaf(num size) : super(size); 
  
  Element provideNodeLabel() => new Element.html("<span class='myLabel'>${_someProperty}</span>");
  
  Element provideTooltip() {
    Element element = new Element.html("<div></div>");
    element.style..backgroundColor = "white"
        ..fontSize = "0.8em"
        ..padding = "1px 5px 1px 5px";
    element.text = "${_someProperty} [size: ${size}]";
    return element;
  }

  set someProperty(int value) {
    _someProperty = value;
    updateView();
  }
  
  Color provideBackgroundColor() => colors.elementAt(_someProperty % colors.length);
  
  /**
   * Creates a deep copy of this [Leaf].
   * The parent reference will **not** be copied to the clone.
   **/
  Leaf copy() {
    return new Leaf(size);
  }
}
