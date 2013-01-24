part of treemap_view;

class LeafNode extends Node {

  LeafNode(Leaf dModel, vModel, width, height, orientation) :
    super._internal(dModel, vModel, width, height, orientation) {
    _content = container;
    _nodeLabel = dataModel.ancillaryData.provideNodeLabel();
    _content.append(_nodeLabel);
  }

  Leaf get dataModel => this._dataModel;

}