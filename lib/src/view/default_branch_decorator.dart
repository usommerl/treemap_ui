part of treemap_ui.view;

class DefaultBranchDecorator implements BranchDecorator<Branch> {
  
  const DefaultBranchDecorator();
  
  Element createLabel(Branch model) => new Element.html('<h4 style="text-align: center; margin: 0px; font-weight: normal">Branch</h4>');

  Element createTooltip(Branch model) {
    Element element = new Element.html("<div></div>");
    element.style..backgroundColor = "white"
        ..fontSize = "0.8em"
        ..padding = "1px 5px 1px 5px";
    element.text = "Branch [size: ${model.size}]";
    return element;
  }
  
  Color defineNodeColor(Branch model) => Color.GRAY;
}