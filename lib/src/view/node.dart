part of treemap_view;

abstract class Node {

  final DivElement container = new DivElement();
  final DataModel _model;
  final Orientation orientation;
  const int _borderSize = 1;
  const String _borderColor = "black"; 
  final Percentage width, height;
  String _borderStyle;
  BranchNode parent;
  DivElement _content;
  ParagraphElement _nodeLabel;

  factory Node(DataModel model, Percentage width, Percentage height, Orientation orientation) 
    => model.isLeaf ? 
        new LeafNode(model,width,height,orientation) :
        new BranchNode(model,width,height,orientation);
        
  factory Node.forRoot(DivElement rootHtmlElement, DataModel model) {
    assert(model.isRoot);
    assert(rootHtmlElement.clientHeight > 0);
    assert(rootHtmlElement.children.length == 0);
    final rootNode = new Node(model, Percentage.x100, Percentage.x100, Orientation.vertical);
    rootHtmlElement.append(rootNode.container);
    return rootNode;
  }
  
  Node._internal(this._model, this.width, this.height, this.orientation) {
    container.classes.add(this.runtimeType.toString());
    container.classes.add(this.orientation.toString());
    container.style..boxSizing = "border-box"
        ..margin = "0px"
        ..position = "relative"
        ..float = orientation.isVertical ? "none" : "left"
        ..overflow = "hidden"
        ..width = width.toString()
        ..height = height.toString();
    _nodeLabel = new ParagraphElement();
    _nodeLabel.style..marginAfter = "0px"
        ..marginBefore = "0px";
    _nodeLabel.text = _model.title;
    _borderStyle = "${_borderSize}px solid ${_borderColor}";
  }

  void _fixBorders() {
    if (parent.children.some((child) => this.isPositionedBelow(child))) {
      container.style.borderTopWidth = "0px";
      if (container.offsetHeight <= _borderSize) {
        _collapseHeight();
      }
    } else if (container.offsetHeight <= 2 * _borderSize) {
      _collapseHeight();
    }
    if (parent.children.some((child) => this.isPositionedRightOf(child))) {
      container.style.borderLeftWidth = "0px";
      if (container.offsetWidth <= _borderSize) {
        _collapseWidth();
      }
    } else if (container.offsetWidth <= 2 * _borderSize) {
      _collapseWidth();
    }
  }

  void _collapseWidth() {
    container.style.borderLeftWidth = "0px";
    container.style.borderRightWidth = "0px";
    _content.style.backgroundColor = _borderColor;
  }

  void _collapseHeight() {
    container.style.borderTopWidth = "0px";
    container.style.borderBottomWidth = "0px";
    _content.style.backgroundColor = _borderColor;
  }

  bool isPositionedBelow(Node other) => this.parent == other.parent? 
    this.container.offsetTop > other.container.offsetTop :
    throw new RuntimeError("Can't tell. Are you comparing nodes from different branches?");

  bool isPositionedRightOf(Node other) => this.parent == other.parent ? 
    this.container.offsetLeft > other.container.offsetLeft :
    throw new RuntimeError("Can't tell. Are you comparing nodes from different branches?");   
  
  bool get isLeaf => model.isLeaf;
  
  bool get isBranch => model.isBranch;
  
  int get clientWidth => _content.clientWidth;
  
  int get clientHeight => _content.clientHeight;
  
  DataModel get model;
}

