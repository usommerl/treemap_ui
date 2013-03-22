part of treemap_ui_view;

class BranchNode extends Node implements LayoutAid {

  static const String CONTENT = 'branch-content';
  static const String MODEL_ROOT = 'model-root';
  static const String NAVI_LEFT = "navi-left";
  static const String NAVI_RIGHT = "navi-right";
  static const String NAVI_BOTTOM = "navi-bottom";

  final List<Node> children = [];
  final List<InvisibleLayoutAid> layoutAids = [];
  final DivElement _naviLeft = new DivElement();
  final DivElement _naviRight = new DivElement();
  final DivElement _naviBottom = new DivElement();
  List<StreamSubscription> _subscriptions;

  BranchNode(dataModel, viewModel, width, height, orientation) :
    super._internal(dataModel, viewModel, width, height, orientation) {
      if (dataModel.isRoot) {
        container.classes.add("${viewModel.styleNames[MODEL_ROOT]}");
      }
      _content = new DivElement();
      _content.classes.add("${viewModel.styleNames[CONTENT]}");
      _naviLeft.classes.add("${viewModel.styleNames[NAVI_LEFT]}");
      _naviRight.classes.add("${viewModel.styleNames[NAVI_RIGHT]}");
      _naviBottom.classes.add("${viewModel.styleNames[NAVI_BOTTOM]}");
      container.append(_nodeLabel.container);
      container.append(_naviLeft);
      container.append(_naviRight);
      container.append(_naviBottom);
      container.append(_content);
      _tooltip = new Tooltip(this);
      _subscriptions = _registerSubscriptions([_nodeLabel.container, _naviLeft, _naviRight, _naviBottom]);
    }

  void add(Node child) {
    _content.append(child.container);
    _register(child);
  }

  void _register(Node child) {
    child.setParent(this);
    children.add(child);
    if (child.isLeaf) {
      (child as LeafNode).tooltip = _tooltip;      
    }
  }

  void addAid(InvisibleLayoutAid aid) {
    layoutAids.add(aid);
    _content.append(aid.container);
    _subscriptions.add(aid.onChildAdd.listen((node) => _register(node)));
  }

  AbstractBranch get dataModel => this._dataModel;
  
  BranchNode get aidRoot => this;

  Iterable<StreamSubscription> _registerSubscriptions(Iterable<Element> l) {
    final List<StreamSubscription> subscriptions = [];
    l.forEach((e) {
      subscriptions.addAll([
        e.onMouseOver.listen((MouseEvent event) {
          if (viewModel.componentTraversable) {
            e.classes.add(viewModel.styleNames[NAVIGATION_ELEMENT]);
          } else {
            e.classes.remove(viewModel.styleNames[NAVIGATION_ELEMENT]);
          }
        }),
        e.onMouseDown.listen((MouseEvent event) {
          viewModel.branchClicked(this);
        })
      ]);
    });
    return subscriptions;
  }

  void cancelSubscriptions() {
    super.cancelSubscriptions();
    _subscriptions.forEach((s) => s.cancel());
    _tooltip.cancelSubscriptions();
    children.forEach((c) => c.cancelSubscriptions());
  }
}
