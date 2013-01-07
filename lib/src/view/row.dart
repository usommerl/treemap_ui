part of treemapView;

class Row {
  DivElement _container = new DivElement();
  List<ViewNode> _children = new List();
  ViewNode _parent;

  Row._internal(Percentage width, Percentage height, this._parent) {
    _container.style..margin = "0px"
        ..boxSizing = "border-box"
        ..padding = "0px"
        ..width = width.toString()
        ..height = height.toString();
    _container.classes.add(this.runtimeType.toString());
    _parent._content.append(this._container);
  }

  factory Row.forStripLayout(Percentage size, Orientation orientation, ViewNode parent) {
    Row row;
    if (orientation.isHorizontal()) {
      row = new Row._internal(Percentage.p100, size, parent);
      row._container.style.float = "none";
    } else {
      row = new Row._internal(size, Percentage.p100, parent);
      row._container.style.float = "left";
    }
    row._container.classes.add(orientation.toString());
    return row;
  }

  factory Row.forSquarifiedLayout(Percentage width, Percentage height, ViewNode parent) {
    var row = new Row._internal(width, height, parent);
    row._container.style.float = "left";
    return row;
  }

  void add(ViewNode child) {
    this._container.append(child._container);
    _parent._linkNode(child);
  }

  CssClassSet get classes => _container.classes;
}