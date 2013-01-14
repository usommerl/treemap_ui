part of treemap_view;

class TreemapNode {

  final List<TreemapNode> children = [];
  final List<LayoutHelper> layoutHelpers = [];
  final DivElement container = new DivElement();
  final DataModel model;
  final Orientation orientation;
  const int _borderSize = 1;
  const String _borderColor = "black"; 
  TreemapNode parent;
  DivElement _content;
  ParagraphElement _nodeLabel;

  TreemapNode(this.model, Percentage width, Percentage height, this.orientation) {
    assert(this.model != null);
    assert(this.orientation != null);
    container.classes.add(this.runtimeType.toString());
    container.classes.add(this.orientation.toString());
    container.style..boxSizing = "border-box"
        ..margin = "0px"
        ..position = "relative"
        ..float = orientation.isVertical() ? "none" : "left"
        ..overflow = "hidden"
        ..width = width.toString()
        ..height = height.toString();
    _nodeLabel = new ParagraphElement();
    _nodeLabel.style..marginAfter = "0px"
        ..marginBefore = "0px";
    _nodeLabel.text = this.model.title;
    if (model.isLeaf) {
      _createLeafNode();
    } else {
      _createBranchNode();
    }
    final borderStyle = "${_borderSize}px solid ${_borderColor}";
    container.style.border = model.isRoot && model.isBranch ? "0px" : borderStyle;
  }
  
  factory TreemapNode.root(DivElement rootHtmlElement, DataModel model) {
      assert(model.isRoot);
      assert(rootHtmlElement.clientHeight > 0);
      assert(rootHtmlElement.children.length == 0);
      var rootNode = new TreemapNode(model, Percentage.x100, Percentage.x100, Orientation.vertical);
      rootHtmlElement.append(rootNode.container);
      return rootNode;
  }

  void _createLeafNode() {
    _content = container;
    _content.style..padding = "0px"
        ..backgroundColor = "#DDD";
    _content.append(_nodeLabel);
  }

  void _createBranchNode() {
    var padding;
    if (model.isRoot) {
      padding = 0;
      _nodeLabel.style.display = "none";
    } else {
      padding = 2;
    }
    _nodeLabel.attributes["align"] = "center";
    container.style.backgroundColor = "#999";
    _content = new DivElement();
    _content.style
        ..margin = "0px"
        ..padding = "0px"
        ..position = "absolute"
        ..left = "${padding}px"
        ..right = "${padding}px"
        ..bottom = "${padding}px"
        ..top = "${padding}px";
    container.append(_nodeLabel);
    container.append(_content);
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

  bool isPositionedBelow(TreemapNode other) {
    if (this.parent == other.parent) {
      return this.container.offsetTop > other.container.offsetTop;
    } else {
      throw new RuntimeError("Can't tell. Are you comparing nodes from different branches?");
    }
  }

  bool isPositionedRightOf(TreemapNode other) {
    if (this.parent == other.parent) {
      return this.container.offsetLeft > other.container.offsetLeft;
    } else {
      throw new RuntimeError("Can't tell. Are you comparing nodes from different branches?");
    }
  }

  void add(TreemapNode child) {
    _content.append(child.container);
    register(child);
  }
  
  void addHelper(LayoutHelper helper) {
    _content.append(helper.container);
    layoutHelpers.add(helper);
  }

  void register(TreemapNode child) {
    child.parent = this;
    children.add(child);
    child._fixBorders();
    child._recalculateContentBox();
  }

  void _recalculateContentBox() {
    if (model.isBranch) { 
      _content.style.top = "${_nodeLabel.offsetHeight}px";
    }
  }
  
  int get clientWidth => this._content.clientWidth;
  
  int get clientHeight => this._content.clientHeight;
  
}
