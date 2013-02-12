part of treemap_view;

class LeafNode extends Node {
  
  Tooltip tooltip;

  LeafNode(AbstractLeaf dataModel, viewModel, width, height, orientation) :
    super._internal(dataModel, viewModel, width, height, orientation) {
    _content = container;
    _nodeLabel = dataModel.provideNodeLabel();
    container.style.backgroundColor = dataModel.provideBackgroundColor().toString();
    _content.append(_nodeLabel);  
  }

  AbstractLeaf get dataModel => this._dataModel;
 
}