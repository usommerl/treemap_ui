part of treemap_ui.view;

class BranchNode extends Node implements NodeContainer {

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
        shell.classes.add("${viewModel.styleNames[MODEL_ROOT]}");
      }
      _content = new DivElement();
      _content.classes.add("${viewModel.styleNames[CONTENT]}");
      _naviLeft.classes.add("${viewModel.styleNames[NAVI_LEFT]}");
      _naviRight.classes.add("${viewModel.styleNames[NAVI_RIGHT]}");
      _naviBottom.classes.add("${viewModel.styleNames[NAVI_BOTTOM]}");
      shell.append(_nodeLabel.shell);
      shell.append(_naviLeft);
      shell.append(_naviRight);
      shell.append(_naviBottom);
      shell.append(_content);
      _subscriptions = _registerSubscriptions([_nodeLabel.shell, _naviLeft, _naviRight, _naviBottom]);
    }

  void add(Node child) {
    _content.append(child.shell);
    register(child);
  }

  void register(Node child) {
    child.setParent(this);
    children.add(child);
  }

  void mount(LayoutAid aid) {
    _content.append(aid.shell);
  }

  BranchDecorator get decorator => viewModel.branchDecorator;
  
  Branch get dataModel => _dataModel;
  
  BranchNode get node => this;
  
  Rect get client => _content.client;
  
  Iterable<Element> get mouseoverElements => [_nodeLabel.shell, _naviLeft, _naviRight, _naviBottom];

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
  
  void rectifyAppearance() {
    super.rectifyAppearance();
    parent.then((_) {
      String topPosition;
      if (_nodeLabel.shell.offset.height > viewModel.branchPadding ) {
        topPosition = "${_nodeLabel.shell.offset.height}px";
        _content.style.top = topPosition;
      } else {
        topPosition = "${viewModel.branchPadding}px";
        _nodeLabel.shell.style.height = "${viewModel.branchPadding}px";
      }
      _naviLeft.style.top = topPosition;
      _naviRight.style.top = topPosition;
      children.forEach((child) => child.rectifyAppearance());
    });
  }

  void cancelSubscriptions() {
    super.cancelSubscriptions();
    _subscriptions.forEach((s) => s.cancel());
    children.forEach((c) => c.cancelSubscriptions());
  }
}
