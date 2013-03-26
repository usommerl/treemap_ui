part of treemap_ui.view;

class LeafNode extends Node {

  LeafNode(dataModel, viewModel, width, height, orientation) :
    super._internal(dataModel, viewModel, width, height, orientation) {
    _content = container;
    _content.append(_nodeLabel.container);
    container.style.backgroundColor = dataModel.provideBackgroundColor().toString();
    parent.then((parent) {
      _tooltip = parent.tooltip;
      _tooltip.registerSubscriptions([container],this.dataModel);
    });
  }

  AbstractLeaf get dataModel => _dataModel;

  void repaintContent() {
    super.repaintContent();
    container.style.backgroundColor = dataModel.provideBackgroundColor().toString();
  }
}
