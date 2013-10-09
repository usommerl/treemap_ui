part of treemap_ui.view;

class DefaultLeafDecorator implements LeafDecorator<Leaf> {
  
  const DefaultLeafDecorator();
  
  Element createLabel(Leaf model) => null;
  
  Element createTooltip(Leaf model) {
    DivElement element = new DivElement();
    element.style..backgroundColor = Color.WHITE.toString()
        ..fontSize = "0.8em"
        ..padding = "1px 5px 1px 5px";
    element.text = "Leaf [size: ${model.size}]";
    return element;
  }
  
  Color defineNodeColor(Leaf model) => Color.LIGHT_GREY;
}