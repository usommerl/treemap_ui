part of treemap_ui.view;

class LeafNode extends Node {

  LeafNode(dataModel, viewModel, width, height, orientation) :
    super._internal(dataModel, viewModel, width, height, orientation) {
    _content = container;
    _content.append(_nodeLabel.container);
    container.style.backgroundColor = decorator.defineColor(dataModel).toString();
    parent.then((parent) {
      _tooltip = parent.tooltip;
      _tooltip.registerSubscriptions([container],this.dataModel);
    });
  }

  Leaf get dataModel => _dataModel;
  
  LeafDecorator get decorator => viewModel.leafDecorator;

  void repaint() {
    super.repaint();
    container.style.backgroundColor = decorator.defineColor(dataModel).toString();
  }
}
