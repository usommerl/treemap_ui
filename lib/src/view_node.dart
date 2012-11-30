part of treemap;

class ViewNode {
  
  static const String VERTICAL_ORIENTATION = "none";
  static const String HORIZONTAL_ORIENTATION = "left";
  final List<ViewNode> _children = new List();
  ViewNode _parent;
  String _orientation = VERTICAL_ORIENTATION;
  DataModel _model;
  DivElement _container;
  DivElement _content;
  ParagraphElement _nodeLabel;
  final int _labelHeight = 19;
  final int _padding = 3;

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
    rootArea.children.add(this._container);
  }
  
  void _initNode(num width, num height) {
    _container = new DivElement();
    _container.style..boxSizing = "border-box"
        ..margin = "0px"
        ..position = "relative"
        ..float = this._orientation
        ..width = "${width}%"
        ..height = "${height}%";
    _nodeLabel = new ParagraphElement();
    _nodeLabel.style..marginAfter = "0px"
        ..marginBefore = "0px";
    _nodeLabel.text = this._model.title;
    _nodeLabel.style.height = "${_labelHeight}";
    if (_model.isLeaf()) {
      _createLeafNode();
    } else {
      _createBranchNode();
    }
    _container.style.border = "1px solid black";
  }

  void _createLeafNode() {
    _content = _container;
    _content.style..padding = "0px"
        ..backgroundColor = "#DDD";
    _content.children.add(_nodeLabel);
  }

  void _createBranchNode() {
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
        ..top = "${_labelHeight + _padding}px";
    _container.children.add(_nodeLabel);
    _container.children.add(_content);
  }
  
  void _fixBorders(ViewNode node) {
    if (this._children.some((child) => node._isPositionedBelow(child))) {
      node._container.style.borderTopWidth = "0px";
    }
    if (this._children.some((child) => node._isPositionedRightOf(child))) {
      node._container.style.borderLeftWidth = "0px";
    }
  }
  
  bool _isPositionedBelow(ViewNode other) {
    if (this.parent == other.parent) {
      return this._container.offsetTop > other._container.offsetTop;
    } else {
      throw new RuntimeError("Can't tell. Are you comparing nodes from different branches?");
    }
  }
  
  bool _isPositionedRightOf(ViewNode other) {
    if (this.parent == other.parent) {
      return this._container.offsetLeft > other._container.offsetLeft;
    } else {
      throw new RuntimeError("Can't tell. Are you comparing nodes from different branches?");
    } 
  }

  void add(ViewNode child) {
    _content.children.add(child._container);
    child._parent = this;
    this._children.add(child);
    _fixBorders(child);
  }

  void addAll(Collection<ViewNode> children) {
    children.forEach((child) {this.add(child);});
  }
  
  bool isLeaf() => this._model.isLeaf();
  
  bool isRoot() => this._model.isRoot();
  
  int get clientWidth => this._content.clientWidth;
 
  int get clientHeight => this._content.clientHeight;
  
  DataModel get model => this._model;
  
  ViewNode get parent => this._parent;
  
}
