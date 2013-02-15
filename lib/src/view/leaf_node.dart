part of treemap_view;

class LeafNode extends Node {
  
  LeafNode(dataModel, viewModel, width, height, orientation) :
    super._internal(dataModel, viewModel, width, height, orientation) {
    _content = container;
    _content.append(_nodeLabel.container);  
    container.style.backgroundColor = dataModel.provideBackgroundColor().toString();
  }

  AbstractLeaf get dataModel => this._dataModel;

  void repaintContent() {
    _nodeLabel.repaintContent();
    _tooltip.repaintContent();
    container.style.backgroundColor = dataModel.provideBackgroundColor().toString();
  }
  
}
