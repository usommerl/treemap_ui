part of treemap.view;

class BranchNode extends Node {

  static const String CONTENT = 'branch-content';
  static const String MODEL_ROOT = 'model-root';

  final List<Node> children = [];
  final List<LayoutHelper> layoutHelpers = [];
  List<StreamSubscription> _subscriptions;

  BranchNode(dataModel, viewModel, width, height, orientation) :
    super._internal(dataModel, viewModel, width, height, orientation) {
      if (dataModel.isRoot) {
        container.classes.add("${viewModel.styleNames[MODEL_ROOT]}");
      }
      _content = new DivElement();
      _content.classes.add("${viewModel.styleNames[CONTENT]}");
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

  List<StreamSubscription> _registerSubscriptions() {
    final List<StreamSubscription> subscriptions = [];
    subscriptions.addAll([
        _nodeLabel.container.onMouseOver.listen((MouseEvent event) {
          if (viewModel.componentTraversable) {
            _nodeLabel.container.classes.add(viewModel.styleNames[NAVIGATION_ELEMENT]);
          } else {
            _nodeLabel.container.classes.remove(viewModel.styleNames[NAVIGATION_ELEMENT]);
          }
        }),
        _nodeLabel.container.onMouseDown.listen((MouseEvent event) {
          viewModel.branchClicked(this);
        })
      ]);
    return subscriptions;
  }
  
  void cancelSubscriptions() {
    super.cancelSubscriptions();
    _subscriptions.forEach((s) => s.cancel());
    children.forEach((c) => c.cancelSubscriptions());
  }
}
