part of treemap_view;

class LeafNode extends Node {
  
  LeafNode(Leaf dataModel, width, height, orientation) :
    super._internal(dataModel,width,height,orientation) {
    _content = container;
    _content.style..padding = "0px"
        ..backgroundColor = "#DDD";
    _content.append(_nodeLabel);
  }
  
  Leaf get dataModel => this._dataModel;
  
}