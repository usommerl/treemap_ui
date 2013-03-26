part of treemap_ui.view;

class NodeLabel implements Attachable{

  Element _container;
  final Node _node;

  NodeLabel(Node this._node) {
    if (_node.isBranch) {
      _container = new Element.html("<div align=center></div>");
    } else {
      _container = new DivElement();
    }
    container.classes.add("${_node.viewModel.styleNames[runtimeType.toString()]}");
    repaintContent();
  }

  void repaintContent() {
    container.children.clear();
    final labelContent = _node.dataModel.provideNodeLabel();
    if (labelContent != null) {
      container.append(labelContent);
    }
  }

  Element get container => _container;

}
