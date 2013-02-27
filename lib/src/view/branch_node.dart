part of treemap_view;

class BranchNode extends Node {

  static const String CONTENT = 'branch-content';
  static const String MODEL_ROOT = 'model-root';
  static const String VIEW_ROOT = "viewRoot";

  final List<Node> children = [];
  final List<LayoutHelper> layoutHelpers = [];
  List<StreamSubscription> _subscriptions;

  BranchNode(dataModel, viewModel, width, height, orientation) :
    super._internal(dataModel, viewModel, width, height, orientation) {
      if (isModelRoot) {
        container.classes.add("${viewModel.style._classNames[MODEL_ROOT]}");
      }
      _content = new DivElement();
      _content.classes.add("${viewModel.style._classNames[CONTENT]}");
      container.append(_nodeLabel.container);
      container.append(_content);
      _subscriptions = _registerSubscriptions();
    }

  void add(Node child) {
    _content.append(child.container);
    register(child);
  }

  void register(Node child) {
    child.setParent(this);
    children.add(child);
  }

  void addHelper(LayoutHelper helper) {
    _content.append(helper.container);
    layoutHelpers.add(helper);
  }

  AbstractBranch get dataModel => this._dataModel;

  bool get isViewRoot => viewModel.currentViewRoot == this;

  List<StreamSubscription> _registerSubscriptions() {
    final List<StreamSubscription> subscriptions = [];
    subscriptions.addAll([
        _nodeLabel.container.onMouseOver.listen((MouseEvent event) {
          if (viewModel.treemap.isNavigatable) {
            _nodeLabel.container.style.cursor = "pointer";
          } else {
            _nodeLabel.container.style.cursor = "auto";
          }
        }),
        _nodeLabel.container.onMouseDown.listen((MouseEvent event) {
          if (viewModel.treemap.isNavigatable) {
            if (viewModel.currentViewRoot == this) {
              if (!isModelRoot) {
                _recreateInitialHtmlHierarchy(this);
                _setAsViewRoot(_parent);
              }
            } else {
              if (_parent.isViewRoot && !_parent.isModelRoot) {
                _recreateInitialHtmlHierarchy(_parent);
              }
              _setAsViewRoot(this);
            }
          }
        })
      ]);
    return subscriptions;
  }

  void _setAsViewRoot(BranchNode node) {
    viewModel.cachedHtmlParent = node.container.parent;
    viewModel.cachedNextSibling = node.container.nextElementSibling;
    node.container.style.width = Percentage.ONE_HUNDRED.toString();
    node.container.style.height = Percentage.ONE_HUNDRED.toString();
    node.container.classes.add("${viewModel.style._classNames[VIEW_ROOT]}");
    viewModel.currentViewRoot = node;
    viewModel.treemapHtmlRoot.children.clear();
    viewModel.treemapHtmlRoot.append(node.container);
    _rectifyAppearance();
  }

  void _recreateInitialHtmlHierarchy(BranchNode node) {
    node.container.style.width = node.width.toString();
    node.container.style.height = node.height.toString();
    node.container.classes.remove("${viewModel.style._classNames[VIEW_ROOT]}");
    if (viewModel.cachedNextSibling == null) {
      viewModel.cachedHtmlParent.append(node.container);
    } else {
      viewModel.cachedNextSibling.insertAdjacentElement('beforeBegin', node.container);
    }
  }
  
  void cancelSubscriptions() {
    super.cancelSubscriptions();
    _subscriptions.forEach((s) => s.cancel());
    children.forEach((c) => c.cancelSubscriptions());
  }
}
