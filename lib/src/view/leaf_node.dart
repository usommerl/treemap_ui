part of treemap_view;

class LeafNode extends Node {
  
  LeafNode(Leaf dataModel, vModel, width, height, orientation) :
    super._internal(dataModel, vModel, width, height, orientation, CssIdentifiers.LEAF) {
    _content = container;
    _content.append(_nodeLabel);
  }
  
  Leaf get dataModel => this._dataModel;
  
}