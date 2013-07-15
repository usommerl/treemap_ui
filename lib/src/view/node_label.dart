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
    shell.classes.add("${_node.viewModel.styleNames[runtimeType.toString()]}");
    repaintContent();
  }

  void repaintContent() {
    shell.children.clear();
    final labelContent = _node.decorator.createLabel(_node.dataModel);
    if (labelContent != null) {
      shell.append(labelContent);
    }
  }

  Element get shell => _container;

}
