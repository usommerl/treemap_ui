part of treemap_ui.view;

class LeafNode extends Node {

  LeafNode(dataModel, viewModel, width, height, orientation) :
    super._internal(dataModel, viewModel, width, height, orientation) {
    _content = container;
    _content.append(_nodeLabel.container);
    container.style.backgroundColor = decorator.defineColor(dataModel).toString();
  }

  Leaf get dataModel => _dataModel;
  
  LeafDecorator get decorator => viewModel.leafDecorator;
  
  Iterable<Element> get mouseoverElements =>[container];

  void repaint() {
    super.repaint();
    container.style.backgroundColor = decorator.defineColor(dataModel).toString();
  }
}
