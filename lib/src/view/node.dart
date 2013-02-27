part of treemap_view;

abstract class Node implements Attachable {

  static const String NO_LEFT_BORDER = 'noLeftBorder';
  static const String NO_TOP_BORDER = 'noTopBorder';
  static const String COLLAPSED_WIDTH = 'collapsedWidth';
  static const String COLLAPSED_HEIGHT = 'collapsedHeight';

  final Orientation orientation;
  final Percentage width, height;
  final ViewModel viewModel;
  final Completer<BranchNode> _parentCompleter = new Completer();
  final DataModel _dataModel;
  final Element container = new DivElement();
  StreamSubscription _modelSubscription;
  BranchNode _parent;
  DivElement _content;
  NodeLabel _nodeLabel;
  Tooltip _tooltip;

  Node._internal(this._dataModel, this.viewModel, this.width, this.height, this.orientation) {
    container.classes.add("${viewModel.style._classNames[runtimeType.toString()]}");
    container.classes.add("${viewModel.style._classNames[orientation.toString()]}");
    container.style..width = width.toString()
                   ..height = height.toString();
    _nodeLabel = new NodeLabel(this);
    _tooltip = new Tooltip(this);
    _rectifyAppearance();
    _modelSubscription = dataModel.onPropertyChange.listen((_) {
      if (viewModel.treemap.automaticUpdates) {
        repaintContent();
      }
    });
  }

  factory Node(DataModel dataModel, ViewModel viewModel, Percentage width, Percentage height, Orientation orientation)
    => dataModel.isLeaf ?
        new LeafNode(dataModel,viewModel,width,height,orientation) :
        new BranchNode(dataModel,viewModel,width,height,orientation);

  factory Node.forRoot(DataModel dataModel, ViewModel viewModel) {
    assert(dataModel.isRoot);
    final rootNode = new Node(dataModel, viewModel, Percentage.ONE_HUNDRED, Percentage.ONE_HUNDRED, Orientation.VERTICAL);
    rootNode.viewModel.treemapHtmlRoot.append(rootNode.container);
    rootNode.viewModel.currentViewRoot = rootNode;
    rootNode._nodeLabel.container.style.display = "none";
    return rootNode;
  }

  Future<BranchNode> get parent => _parent == null ?
      _parentCompleter.future :
      new Future.immediate(_parent);

  void setParent(BranchNode parent) {
    if (_parent == null) {
      _parentCompleter.complete(parent);
    }
    _parent = parent;
  }

  void _rectifyAppearance() {
    parent.then((BranchNode parent) {
      container.classes.remove("${viewModel.style._classNames[NO_TOP_BORDER]}");
      container.classes.remove("${viewModel.style._classNames[NO_LEFT_BORDER]}");
      container.classes.remove("${viewModel.style._classNames[COLLAPSED_WIDTH]}");
      container.classes.remove("${viewModel.style._classNames[COLLAPSED_HEIGHT]}");

      if (parent.children.any((other) => this._isPositionedBelow(other))) {
        container.classes.add("${viewModel.style._classNames[NO_TOP_BORDER]}");
        if (container.offsetHeight <= viewModel.style._borderWidth) {
          container.classes.add("${viewModel.style._classNames[COLLAPSED_HEIGHT]}");
        }
      } else if (container.offsetHeight <= 2 * viewModel.style._borderWidth) {
        container.classes.add("${viewModel.style._classNames[COLLAPSED_HEIGHT]}");
      }

      if (parent.children.any((other) => this._isPositionedRightOf(other))) {
        container.classes.add("${viewModel.style._classNames[NO_LEFT_BORDER]}");
        if (container.offsetWidth <= viewModel.style._borderWidth) {
          container.classes.add("${viewModel.style._classNames[COLLAPSED_WIDTH]}");
        }
      } else if (container.offsetWidth <= 2 * viewModel.style._borderWidth) {
        container.classes.add("${viewModel.style._classNames[COLLAPSED_WIDTH]}");
      }

      if (isBranch) {
        if (_nodeLabel.container.offsetHeight > viewModel.style._branchPadding ) {
          _content.style.top = "${_nodeLabel.container.offsetHeight}px";
        } else {
          _nodeLabel.container.style.height = "${viewModel.style._branchPadding}px";
        }
        final thisNode = this as BranchNode;
        thisNode.children.forEach((child) => child._rectifyAppearance());
      }
    });
  }

  bool _isPositionedBelow(Node other) =>
    this.container.offsetTop > other.container.offsetTop;

  bool _isPositionedRightOf(Node other) =>
    this.container.offsetLeft > other.container.offsetLeft;

  bool get isLeaf => dataModel.isLeaf;

  bool get isBranch => dataModel.isBranch;

  bool get isModelRoot => dataModel.isRoot;

  int get clientWidth => _content.clientWidth;

  int get clientHeight => _content.clientHeight;

  DataModel get dataModel;

  void repaintContent() {
    _nodeLabel.repaintContent();
    _tooltip.repaintContent();
  }
  
  void cancelSubscriptions() {
    _modelSubscription.cancel();
    _tooltip.cancelSubscriptions();
  }
}