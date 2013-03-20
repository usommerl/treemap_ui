part of treemap_ui_view;

class BranchNode extends Node {

  static const String CONTENT = 'branch-content';
  static const String MODEL_ROOT = 'model-root';
  static const String NAVI_LEFT = "navi-left";
  static const String NAVI_RIGHT = "navi-right";
  static const String NAVI_BOTTOM = "navi-bottom";

  final List<Node> children = [];
  final List<LayoutAid> layoutAids = [];
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
      _subscriptions = _registerSubscriptions([_nodeLabel.container, _naviLeft, _naviRight, _naviBottom]);
    }

  void add(Node child) {
    _content.append(child.container);
    register(child);
  }

  void register(Node child) {
    child.setParent(this);
    children.add(child);
  }

  void addAid(LayoutAid aid) {
    layoutAids.add(aid);
    _content.append(aid.container);
    _subscriptions.add(aid.onChildAdd.listen((node) => register(node)));
  }

  AbstractBranch get dataModel => this._dataModel;

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
    children.forEach((c) => c.cancelSubscriptions());
  }
}
