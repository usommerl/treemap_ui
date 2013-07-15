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
  final Element shell = new DivElement();
  final bool _isLeaf;
  StreamSubscription _modelSubscription;
  BranchNode _parent;
  DivElement _content;
  NodeLabel _nodeLabel;

  Node._internal(DataModel dataModel, this.viewModel, this.width, this.height, this.orientation)
            : _isLeaf = dataModel.isLeaf,
              _dataModel = dataModel
  {
    shell.classes.add("${viewModel.styleNames[runtimeType.toString()]}");
    shell.classes.add("${viewModel.styleNames[orientation.toString()]}");
    shell.style..width = width.toString()
               ..height = height.toString()
               ..backgroundColor = decorator.defineColor(dataModel).toString();
    _nodeLabel = new NodeLabel(this);
    rectifyAppearance();
    _modelSubscription = dataModel.onVisiblePropertyChange.listen((_) {
      if (viewModel.liveUpdatesEnabled) {
        repaint();
      }
    });
    // Order is important (nodeLabel/registerSubscriptions)
    viewModel.displayArea.tooltip.registerSubscriptions(this);
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
      new Future.value(_parent);

  void setParent(BranchNode parent) {
    if (_parent == null) {
      _parent = parent;
      _parentCompleter.complete(parent);
    } else {
      throw new UnsupportedError("Parent already set. You can set the parent only once.");
    }
  }

  void rectifyAppearance() {
    parent.then((BranchNode parent) {
      shell.classes.remove("${viewModel.styleNames[NO_TOP_BORDER]}");
      shell.classes.remove("${viewModel.styleNames[NO_LEFT_BORDER]}");
      shell.classes.remove("${viewModel.styleNames[COLLAPSED_WIDTH]}");
      shell.classes.remove("${viewModel.styleNames[COLLAPSED_HEIGHT]}");

      if (parent.children.any((other) => this._isPositionedBelow(other))) {
        shell.classes.add("${viewModel.styleNames[NO_TOP_BORDER]}");
        if (shell.offset.height <= viewModel.borderWidth) {
          shell.classes.add("${viewModel.styleNames[COLLAPSED_HEIGHT]}");
        }
      } else if (shell.offset.height <= 2 * viewModel.borderWidth) {
        shell.classes.add("${viewModel.styleNames[COLLAPSED_HEIGHT]}");
      }

      if (parent.children.any((other) => this._isPositionedRightOf(other))) {
        shell.classes.add("${viewModel.styleNames[NO_LEFT_BORDER]}");
        if (shell.offset.width <= viewModel.borderWidth) {
          shell.classes.add("${viewModel.styleNames[COLLAPSED_WIDTH]}");
        }
      } else if (shell.offset.width <= 2 * viewModel.borderWidth) {
        shell.classes.add("${viewModel.styleNames[COLLAPSED_WIDTH]}");
      }
    });
  }

  bool _isPositionedBelow(Node other) =>
    this.shell.offset.top > other.shell.offset.top;

  bool _isPositionedRightOf(Node other) =>
    this.shell.offset.left > other.shell.offset.left;

  bool get isLeaf => _isLeaf;

  bool get isBranch => !isLeaf;
  
  Rect get client => _content.client;
  
  Decorator get decorator;

  DataModel get dataModel;
  
  Iterable<Element> get mouseoverElements;

  void repaint() {
    _nodeLabel.repaintContent();
  }

  void cancelSubscriptions() {
    _modelSubscription.cancel();
  }
}