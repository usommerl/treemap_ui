part of treemap;

class ViewNode {

  static const String VERTICAL_ORIENTATION = "none";
  static const String HORIZONTAL_ORIENTATION = "left";
  final List<ViewNode> _children = new List();
  ViewNode parent;
  String _orientation = VERTICAL_ORIENTATION;
  DataModel _model;
  DivElement _container;
  DivElement _content;
  ParagraphElement _nodeLabel;
  int _padding = 2;
  int borderSize = 1;
  String borderColor = "black";
  String borderStyle;

  ViewNode(this._model, num width, num height, [this._orientation]) {
    assert(this._model != null);
    assert(this._orientation != null);
    assert(width > 0 && width <= 100);
    assert(height > 0 && width <= 100);
    _initNode(width, height);
  }

  ViewNode.from(DivElement rootArea, this._model) {
    assert(this._model.isRoot());
    assert(rootArea.clientHeight > 0);
    assert(rootArea.children.length == 0);
    _initNode(100, 100);
    rootArea.append(this._container);
  }

  void _initNode(num width, num height) {
    borderStyle = "${borderSize}px solid ${borderColor}";
    _container = new DivElement();
    _container.style..boxSizing = "border-box"
        ..margin = "0px"
        ..position = "relative"
        ..float = this._orientation
        ..overflow = "hidden"
        ..width = "${width}%"
        ..height = "${height}%";
    _nodeLabel = new ParagraphElement();
    _nodeLabel.style..marginAfter = "0px"
        ..marginBefore = "0px";
    _nodeLabel.text = this._model.title;
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
    _content.style..boxSizing = "border-box"
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
    this.append(child._container);
    child.parent = this;
    this._children.add(child);
    _recitfyVisualRepresentation(child);
  }
  
  void _recitfyVisualRepresentation(ViewNode child) {
    child._fixBorders();
    child._recalculateContentBox();
  }
  
  void _recalculateContentBox() {
    if (!isLeaf()) {
      _content.style.top = "${_nodeLabel.offsetHeight}px";
    }
  }
  
  void append(Element e) {
    _content.append(e);
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
