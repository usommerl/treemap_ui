part of treemapView;

class Row {
  DivElement _container = new DivElement();
  List<ViewNode> _children = new List();
  ViewNode _parent;

  Row._internal(num width, num height, this._parent) {
    assert(width > 0 && width <= 100);
    assert(height > 0 && height <= 100);
    _container.style..margin = "0px"
        ..boxSizing = "border-box"
        ..padding = "0px"
        ..width = "${width}%"
        ..height = "${height}%";
    _container.classes.add(this.runtimeType.toString());
    _parent._content.append(this._container);
  }
  
  factory Row.forStripLayout(num size, Orientation orientation, ViewNode parent) {
    Row row;
    if (orientation.isHorizontal()) {
      row = new Row._internal(100, size, parent);
      row._container.style.float = "none";
    } else {
      row = new Row._internal(size, 100, parent);
      row._container.style.float = "left";
    }
    row._container.classes.add(orientation.toString());
    return row;
  }

  factory Row.forSquarifiedLayout(num width, num height, ViewNode parent) {
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

//int availableHeight(ViewNode node) {
//  var parent = node._content;
//  var children = new List.from(parent.children);
//  var availableHeight = 0;
//  try {
//    var child = children.removeLast();
//    while (child.offsetLeft + child.offsetWidth - parent.offsetLeft != parent.clientWidth) {
//      child = children.removeLast();
//    }
//    availableHeight = parent.clientHeight - (child.offsetTop + child.offsetHeight - parent.offsetTop);
//  } on RangeError catch (err) {
//    availableHeight = parent.clientHeight;
//
//  }
//  return availableHeight;
//}
//
//int availableWidth(ViewNode node) {
//  var parent = node._content;
//  var children = new List.from(parent.children);
//  var availableWidth = 0;
//  try {
//    var child = children.removeLast();
//    while (child.offsetTop + child.offsetHeight - parent.offsetTop != parent.clientHeight) {
//      child = children.removeLast();
//    }
//    availableWidth = parent.clientWidth - (child.offsetLeft + child.offsetWidth - parent.offsetLeft);
//  } on RangeError catch (err) {
//    availableWidth = parent.clientWidth;
//  }
//  return availableWidth;
//}