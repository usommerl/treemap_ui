part of treemap_ui.view;

class NodeLabel implements Attachable{

  final Element _shell = new DivElement();
  final Node _node;

  NodeLabel(Node this._node) {
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

  Element get shell => _shell;

}
