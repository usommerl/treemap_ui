part of treemap.view;

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
    container.classes.add("${viewModel.styleNames[runtimeType.toString()]}");
    container.classes.add("${viewModel.styleNames[orientation.toString()]}");
    container.style..width = width.toString()
                   ..height = height.toString();
    _nodeLabel = new NodeLabel(this);
    _tooltip = new Tooltip(this);
    rectifyAppearance();
    _modelSubscription = dataModel.onPropertyChange.listen((_) {
      if (viewModel.automaticUpdatesEnabled) {
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

  void rectifyAppearance() {
    parent.then((BranchNode parent) {
      container.classes.remove("${viewModel.styleNames[NO_TOP_BORDER]}");
      container.classes.remove("${viewModel.styleNames[NO_LEFT_BORDER]}");
      container.classes.remove("${viewModel.styleNames[COLLAPSED_WIDTH]}");
      container.classes.remove("${viewModel.styleNames[COLLAPSED_HEIGHT]}");

      if (parent.children.any((other) => this._isPositionedBelow(other))) {
        container.classes.add("${viewModel.styleNames[NO_TOP_BORDER]}");
        if (container.offsetHeight <= viewModel.borderWidth) {
          container.classes.add("${viewModel.styleNames[COLLAPSED_HEIGHT]}");
        }
      } else if (container.offsetHeight <= 2 * viewModel.borderWidth) {
        container.classes.add("${viewModel.styleNames[COLLAPSED_HEIGHT]}");
      }

      if (parent.children.any((other) => this._isPositionedRightOf(other))) {
        container.classes.add("${viewModel.styleNames[NO_LEFT_BORDER]}");
        if (container.offsetWidth <= viewModel.borderWidth) {
          container.classes.add("${viewModel.styleNames[COLLAPSED_WIDTH]}");
        }
      } else if (container.offsetWidth <= 2 * viewModel.borderWidth) {
        container.classes.add("${viewModel.styleNames[COLLAPSED_WIDTH]}");
      }

      if (isBranch) {
        if (_nodeLabel.container.offsetHeight > viewModel.branchPadding ) {
          _content.style.top = "${_nodeLabel.container.offsetHeight}px";
        } else {
          _nodeLabel.container.style.height = "${viewModel.branchPadding}px";
        }
        final thisNode = this as BranchNode;
        thisNode.children.forEach((child) => child.rectifyAppearance());
      }
    });
  }

  bool _isPositionedBelow(Node other) =>
    this.container.offsetTop > other.container.offsetTop;

  bool _isPositionedRightOf(Node other) =>
    this.container.offsetLeft > other.container.offsetLeft;

  bool get isLeaf => dataModel.isLeaf;

  bool get isBranch => dataModel.isBranch;

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