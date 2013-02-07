part of treemap_view;

class LeafNode extends Node {
  
  Tooltip tooltip;

  LeafNode(Leaf dataModel, viewModel, width, height, orientation) :
    super._internal(dataModel, viewModel, width, height, orientation) {
    _content = container;
    _nodeLabel = dataModel.ancillaryData.provideNodeLabel();
    _content.append(_nodeLabel);  
  }

  Leaf get dataModel => this._dataModel;
 
}