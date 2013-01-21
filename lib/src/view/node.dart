part of treemap_view;

abstract class Node {

  final DivElement container = new DivElement();
  final Orientation orientation;
  final Percentage width, height;
  final DataModel _dataModel;
  final ViewModel viewModel;
  BranchNode parent;
  DivElement _content;
  ParagraphElement _nodeLabel;

  factory Node(DataModel dModel, ViewModel vModel, Percentage width, Percentage height, Orientation orientation) 
    => dModel.isLeaf ? 
        new LeafNode(dModel,vModel,width,height,orientation) :
        new BranchNode(dModel,vModel,width,height,orientation);
        
  factory Node.forRoot(DataModel dataModel, ViewModel viewModel) {
    assert(dataModel.isRoot);
    final rootNode = new Node(dataModel, viewModel, Percentage.x100, Percentage.x100, Orientation.vertical);
    rootNode.viewModel.treemapHtmlRoot.append(rootNode.container);
    rootNode.viewModel.currentViewRoot = rootNode;
    return rootNode;
  }
  
  Node._internal(this._dataModel, this.viewModel, this.width, this.height, this.orientation, String cssIdentifier) {
    container.classes.add("${viewModel.style.cssPrefix}${cssIdentifier}");
    container.classes.add("${viewModel.style.cssPrefix}${orientation.toString()}");
    container.style..width = width.toString()
                   ..height = height.toString();
    _nodeLabel = new ParagraphElement();
    _nodeLabel.style..marginAfter = "0px"
        ..marginBefore = "0px";
    _nodeLabel.text = _dataModel.title;
  }

  void _fixBorders() {
    if (parent.children.some((child) => this.isPositionedBelow(child))) {
      container.classes.add("${viewModel.style.cssPrefix}${CssIdentifiers.NO_TOP_BORDER}");
      if (container.offsetHeight <= viewModel.style.borderSize) {
        container.classes.add("${viewModel.style.cssPrefix}${CssIdentifiers.COLLAPSED_HEIGHT}");
      }
    } else if (container.offsetHeight <= 2 * viewModel.style.borderSize) {
      container.classes.add("${viewModel.style.cssPrefix}${CssIdentifiers.COLLAPSED_HEIGHT}");
    }
    if (parent.children.some((child) => this.isPositionedRightOf(child))) {
      container.classes.add("${viewModel.style.cssPrefix}${CssIdentifiers.NO_LEFT_BORDER}");
      if (container.offsetWidth <= viewModel.style.borderSize) {
        container.classes.add("${viewModel.style.cssPrefix}${CssIdentifiers.COLLAPSED_WIDTH}");
      }
    } else if (container.offsetWidth <= 2 * viewModel.style.borderSize) {
      container.classes.add("${viewModel.style.cssPrefix}${CssIdentifiers.COLLAPSED_WIDTH}");
    }
  }

  bool isPositionedBelow(Node other) => this.parent == other.parent ? 
    this.container.offsetTop > other.container.offsetTop :
    throw new RuntimeError("Can't tell. Are you comparing nodes from different branches?");

  bool isPositionedRightOf(Node other) => this.parent == other.parent ? 
    this.container.offsetLeft > other.container.offsetLeft :
    throw new RuntimeError("Can't tell. Are you comparing nodes from different branches?");   
  
  bool get isLeaf => dataModel.isLeaf;
  
  bool get isBranch => dataModel.isBranch;
  
  bool get isModelRoot => dataModel.isRoot;
  
  int get clientWidth => _content.clientWidth;
  
  int get clientHeight => _content.clientHeight;
  
  DataModel get dataModel;
  
}

