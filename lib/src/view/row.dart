part of treemapView;

class Row {
  DivElement _container = new DivElement();
  List<ViewNode> _children = new List();
  ViewNode _parent;

  Row(num size, Orientation orientation, this._parent) {
    assert(size > 0 && size <= 100);
    _container.style..margin = "0px"
        ..padding = "0px"
        ..float = orientation.isVertical() ? "left" : "none"
        ..borderWidth = "0px";
    if (orientation.isHorizontal()) {
      _container.style..width = "100%"
          ..height = "${size}%";
    } else {
      _container.style..width = "${size}%"
          ..height = "100%";
    }
    _parent._content.append(this._container);
  }

  void add(ViewNode child) {
    this._container.append(child._container);
    _parent._linkNode(child);
  }
}