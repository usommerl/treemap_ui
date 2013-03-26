part of treemap_ui.view;

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
  final bool _isLeaf;
  StreamSubscription _modelSubscription;
  BranchNode _parent;
  DivElement _content;
  NodeLabel _nodeLabel;
  Tooltip _tooltip;

  Node._internal(DataModel dataModel, this.viewModel, this.width, this.height, this.orientation)
            : _isLeaf = dataModel.isLeaf,
              _dataModel = dataModel
  {
    container.classes.add("${viewModel.styleNames[runtimeType.toString()]}");
    container.classes.add("${viewModel.styleNames[orientation.toString()]}");
    container.style..width = width.toString()
                   ..height = height.toString();
    _nodeLabel = new NodeLabel(this);
    rectifyAppearance();
    _modelSubscription = dataModel.onContentChange.listen((_) {
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
      _parent = parent;
      _parentCompleter.complete(parent);
    } else {
      throw new RuntimeError("Parent already set. You can set the parent only once.");
    }
  }

  void rectifyAppearance() {
    parent.then((BranchNode parent) {
      container.classes.remove("${viewModel.styleNames[NO_TOP_BORDER]}");
      container.classes.remove("${viewModel.styleNames[NO_LEFT_BORDER]}");
      container.classes.remove("${viewModel.styleNames[COLLAPSED_WIDTH]}");
      container.classes.remove("${viewModel.styleNames[COLLAPSED_HEIGHT]}");

      if (parent.children.any((other) => this._isPositionedBelow(other))) {
        container.classes.add("${viewModel.styleNames[NO_TOP_BORDER]}");
        if (container.offset.height <= viewModel.borderWidth) {
          container.classes.add("${viewModel.styleNames[COLLAPSED_HEIGHT]}");
        }
      } else if (container.offset.height <= 2 * viewModel.borderWidth) {
        container.classes.add("${viewModel.styleNames[COLLAPSED_HEIGHT]}");
      }

      if (parent.children.any((other) => this._isPositionedRightOf(other))) {
        container.classes.add("${viewModel.styleNames[NO_LEFT_BORDER]}");
        if (container.offset.width <= viewModel.borderWidth) {
          container.classes.add("${viewModel.styleNames[COLLAPSED_WIDTH]}");
        }
      } else if (container.offset.width <= 2 * viewModel.borderWidth) {
        container.classes.add("${viewModel.styleNames[COLLAPSED_WIDTH]}");
      }
    });
  }

  bool _isPositionedBelow(Node other) =>
    this.container.offset.top > other.container.offset.top;

  bool _isPositionedRightOf(Node other) =>
    this.container.offset.left > other.container.offset.left;

  bool get isLeaf => _isLeaf;

  bool get isBranch => !isLeaf;
  
  Rect get client => _content.client;

  DataModel get dataModel;

  void repaintContent() {
    _nodeLabel.repaintContent();
  }

  void cancelSubscriptions() {
    _modelSubscription.cancel();
  }
}