part of treemapView;

class ViewNode {

  static const String VERTICAL_ORIENTATION = "none";
  static const String HORIZONTAL_ORIENTATION = "left";
  final List<ViewNode> _children = new List();
  ViewNode parent;
  Orientation _orientation = Orientation.VERTICAL;
  DataModel _model;
  DivElement _container;
  DivElement _content;
  ParagraphElement _nodeLabel;
  int _padding = 2;
  int borderSize = 1;
  String borderColor = "black";
  String borderStyle;

  ViewNode(this._model, Percentage width, Percentage height, [this._orientation]) {
    assert(this._model != null);
    assert(this._orientation != null);
    _initNode(width, height);
  }

  ViewNode.from(DivElement rootArea, this._model) {
    assert(this._model.isRoot());
    assert(rootArea.clientHeight > 0);
    assert(rootArea.children.length == 0);
    _initNode(Percentage.p100, Percentage.p100);
    rootArea.append(this._container);
  }

  void _initNode(Percentage width, Percentage height) {
    borderStyle = "${borderSize}px solid ${borderColor}";
    _container = new DivElement();
    _container.style..boxSizing = "border-box"
        ..margin = "0px"
        ..position = "relative"
        ..float = _orientation.isVertical() ? "none" : "left"
        ..overflow = "hidden"
        ..width = width.toString()
        ..height = height.toString();
    _nodeLabel = new ParagraphElement();
    _nodeLabel.style..marginAfter = "0px"
        ..marginBefore = "0px";
    _nodeLabel.text = this._model.title;
    _container.classes.add(this.runtimeType.toString());
    _container.classes.add(this._orientation.toString());
    if (_model.isLeaf()) {
      _createLeafNode();
    } else {
      _createBranchNode();
    }
    _container.style.border = isRoot() && !isLeaf() ? "0px" : borderStyle;

  }

  void _createLeafNode() {
    _content = _container;
    _content.style..padding = "0px"
        ..backgroundColor = "#DDD";
    _content.append(_nodeLabel);
  }

  void _createBranchNode() {
    if (isRoot()) {
      _padding = 0;
      _nodeLabel.style.display = "none";
    }
    _nodeLabel.align = "center";
    _container.style.backgroundColor = "#999";
    _content = new DivElement();
    _content.style
        ..margin = "0px"
        ..padding = "0px"
        ..position = "absolute"
        ..left = "${_padding}px"
        ..right = "${_padding}px"
        ..bottom = "${_padding}px"
        ..top = "${_padding}px";
    _container.append(_nodeLabel);
    _container.append(_content);
  }

  void _fixBorders() {
    if (parent.children.some((child) => this.isPositionedBelow(child))) {
      _container.style.borderTopWidth = "0px";
      if (_container.offsetHeight <= borderSize) {
        _collapseHeight();
      }
    } else if (_container.offsetHeight <= 2 * borderSize) {
      _collapseHeight();
    }
    if (parent.children.some((child) => this.isPositionedRightOf(child))) {
      _container.style.borderLeftWidth = "0px";
      if (_container.offsetWidth <= borderSize) {
        _collapseWidth();
      }
    } else if (_container.offsetWidth <= 2 * borderSize) {
      _collapseWidth();
    }
  }

  void _collapseWidth() {
    _container.style.borderLeftWidth = "0px";
    _container.style.borderRightWidth = "0px";
    _content.style.backgroundColor = borderColor;
  }

  void _collapseHeight() {
    _container.style.borderTopWidth = "0px";
    _container.style.borderBottomWidth = "0px";
    _content.style.backgroundColor = borderColor;
  }

  bool isPositionedBelow(ViewNode other) {
    if (this.parent == other.parent) {
      return this._container.offsetTop > other._container.offsetTop;
    } else {
      throw new RuntimeError("Can't tell. Are you comparing nodes from different branches?");
    }
  }

  bool isPositionedRightOf(ViewNode other) {
    if (this.parent == other.parent) {
      return this._container.offsetLeft > other._container.offsetLeft;
    } else {
      throw new RuntimeError("Can't tell. Are you comparing nodes from different branches?");
    }
  }

  void add(ViewNode child) {
    _content.append(child._container);
    _linkNode(child);
  }

  void _linkNode(ViewNode child) {
    child.parent = this;
    _children.add(child);
    _rectifyVisualRepresentation(child);
  }

  void _rectifyVisualRepresentation(ViewNode child) {
    child._fixBorders();
    child._recalculateContentBox();
  }

  void _recalculateContentBox() {
    if (!isLeaf()) {
      _content.style.top = "${_nodeLabel.offsetHeight}px";
    }
  }

  void addAll(Collection<ViewNode> children) {
    children.forEach((child) {this.add(child);});
  }

  bool isLeaf() => this._model.isLeaf();

  bool isRoot() => this._model.isRoot();

  int get clientWidth => this._content.clientWidth;

  int get clientHeight => this._content.clientHeight;

  DataModel get model => this._model;

  List<ViewNode> get children => this._children;

}
