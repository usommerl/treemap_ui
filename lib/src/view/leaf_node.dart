part of treemap_ui.view;

class LeafNode extends Node {

  LeafNode(dataModel, viewModel, width, height, orientation) :
    super._internal(dataModel, viewModel, width, height, orientation) {
    _content = shell;
    _content.append(_nodeLabel.shell);
  }

  Leaf get dataModel => _dataModel;
  
  LeafDecorator get decorator => viewModel.leafDecorator;
  
  Iterable<Element> get mouseoverElements =>[shell];

  void repaint() {
    super.repaint();
    shell.style.backgroundColor = decorator.defineColor(dataModel).toString();
  }
}
