part of treemap_view;

class NodeLabel implements Attachable{

  Element _container;
  final Node _node;

  NodeLabel(Node this._node) {
    if (_node.isBranch) {
      _container = new Element.html("<div align=center></div>");
    } else {
      _container = new DivElement();
    }
    container.classes.add("${_node.viewModel.style._classNames[runtimeType.toString()]}");
    repaintContent();
  }

  void repaintContent() {
    container.children.clear();
    container.append(_node.dataModel.provideNodeLabel());
  }
  
  Element get container => _container;
  
}
