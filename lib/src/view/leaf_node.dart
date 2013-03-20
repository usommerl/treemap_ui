part of treemap_ui_view;

class LeafNode extends Node {

  LeafNode(dataModel, viewModel, width, height, orientation) :
    super._internal(dataModel, viewModel, width, height, orientation) {
    _content = container;
    _content.append(_nodeLabel.container);
    container.style.backgroundColor = dataModel.provideBackgroundColor().toString();
  }

  AbstractLeaf get dataModel => this._dataModel;

  void repaintContent() {
    super.repaintContent();
    container.style.backgroundColor = dataModel.provideBackgroundColor().toString();
  }
  
  set tooltip(Tooltip tooltip) {
    _tooltip = tooltip;
    _tooltip.registerSubscriptions([container], dataModel);
  }
}
