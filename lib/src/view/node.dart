part of treemap_view;

abstract class Node {

  static const String NO_LEFT_BORDER = 'noLeftBorder';
  static const String NO_TOP_BORDER = 'noTopBorder';
  static const String COLLAPSED_WIDTH = 'collapsedWidth';
  static const String COLLAPSED_HEIGHT = 'collapsedHeight';

  final DivElement container = new DivElement();
  final Orientation orientation;
  final Percentage width, height;
  final DataModel _dataModel;
  final ViewModel viewModel;
  BranchNode parent;
  DivElement _content;
  Element _nodeLabel;
  Tooltip tooltip;

  Node._internal(this._dataModel, this.viewModel, this.width, this.height, this.orientation) {
    container.classes.add("${viewModel.style._classNames[runtimeType.toString()]}");
    container.classes.add("${viewModel.style._classNames[orientation.toString()]}");
    container.style..width = width.toString()
                   ..height = height.toString();
  }
  
  factory Node(DataModel dataModel, ViewModel viewModel, Percentage width, Percentage height, Orientation orientation)
    => dataModel.isLeaf ?
        new LeafNode(dataModel,viewModel,width,height,orientation) :
        new BranchNode(dataModel,viewModel,width,height,orientation);

  factory Node.forRoot(DataModel dataModel, ViewModel viewModel) {
    assert(dataModel.isRoot);
    final rootNode = new Node(dataModel, viewModel, Percentage.x100, Percentage.x100, Orientation.vertical);
    rootNode.viewModel.treemapHtmlRoot.append(rootNode.container);
    rootNode.viewModel.currentViewRoot = rootNode;
    return rootNode;
  }
  
  DataModel get dataModel;

  bool get isLeaf => dataModel.isLeaf;

  bool get isBranch => dataModel.isBranch;

  bool get isModelRoot => dataModel.isRoot;

  int get clientWidth => _content.clientWidth;

  int get clientHeight => _content.clientHeight;

  bool isPositionedBelow(Node other) => this.parent == other.parent ?
    this.container.offsetTop > other.container.offsetTop :
    throw new RuntimeError("Can't tell. Are you comparing nodes from different branches?");

  bool isPositionedRightOf(Node other) => this.parent == other.parent ?
    this.container.offsetLeft > other.container.offsetLeft :
    throw new RuntimeError("Can't tell. Are you comparing nodes from different branches?");

  void _rectifyAppearance() {
    container.classes.remove("${viewModel.style._classNames[NO_TOP_BORDER]}");
    container.classes.remove("${viewModel.style._classNames[NO_LEFT_BORDER]}");
    container.classes.remove("${viewModel.style._classNames[COLLAPSED_WIDTH]}");
    container.classes.remove("${viewModel.style._classNames[COLLAPSED_HEIGHT]}");
    
    if (parent.children.any((other) => this.isPositionedBelow(other))) {
      container.classes.add("${viewModel.style._classNames[NO_TOP_BORDER]}");
      if (container.offsetHeight <= viewModel.style.borderWidth) {
        container.classes.add("${viewModel.style._classNames[COLLAPSED_HEIGHT]}");
      }
    } else if (container.offsetHeight <= 2 * viewModel.style.borderWidth) {
      container.classes.add("${viewModel.style._classNames[COLLAPSED_HEIGHT]}");
    }    
    
    if (parent.children.any((other) => this.isPositionedRightOf(other))) {
      container.classes.add("${viewModel.style._classNames[NO_LEFT_BORDER]}");
      if (container.offsetWidth <= viewModel.style.borderWidth) {
        container.classes.add("${viewModel.style._classNames[COLLAPSED_WIDTH]}");
      } 
    } else if (container.offsetWidth <= 2 * viewModel.style.borderWidth) {
      container.classes.add("${viewModel.style._classNames[COLLAPSED_WIDTH]}");
    }
    
    if (isBranch) {
      final node = this as BranchNode;
      node._content.style.top = "${node._nodeLabel.offsetHeight}px";
      node.children.forEach((child) => child._rectifyAppearance());
    }
  }

}

