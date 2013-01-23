part of treemap_view;

class BranchNode extends Node {
  
  static const String CONTENT = 'branch-content';
  static const String MODEL_ROOT = 'model-root';
  static const String VIEW_ROOT = "viewRoot";

  final List<Node> children = [];
  final List<LayoutHelper> layoutHelpers = [];

  BranchNode(Branch dModel, vModel, width, height, orientation) :
    super._internal(dModel, vModel, width, height, orientation) {
      if (isModelRoot) {
        container.classes.add("${viewModel.style._classNames[MODEL_ROOT]}");
        _nodeLabel.style.display = "none";
      }
      _nodeLabel.attributes["align"] = "center";
      _content = new DivElement();
      _content.classes.add("${viewModel.style._classNames[CONTENT]}");
      container.append(_nodeLabel);
      container.append(_content);
      registerListeners();
    }

  void register(Node child) {
    child.parent = this;
    children.add(child);
    child._fixBorders();
    if (child.isBranch) {
      child._content.style.top = "${child._nodeLabel.offsetHeight}px";
    }
  }

  void add(Node child) {
    _content.append(child.container);
    register(child);
  }

  void addHelper(LayoutHelper helper) {
    _content.append(helper.container);
    layoutHelpers.add(helper);
  }

  Branch get dataModel => this._dataModel;

  bool get isViewRoot => viewModel.currentViewRoot == this;

  void registerListeners() {
    _nodeLabel.on.mouseOver.add((MouseEvent event) {
      if (viewModel.treemap.isNavigatable) {
        _nodeLabel.style.cursor = "pointer";
      } else {
        _nodeLabel.style.cursor = "auto";
      }
    });
    _nodeLabel.on.mouseDown.add((MouseEvent event) {
      if (viewModel.treemap.isNavigatable) {
        if (viewModel.currentViewRoot == this) {
          if (!isModelRoot) {
            _recreateInitialHtmlHierarchy(this);
            _setAsViewRoot(parent);
          }
        } else {
          if (parent.isViewRoot && !parent.isModelRoot) {
            _recreateInitialHtmlHierarchy(parent);
          }
          _setAsViewRoot(this);
        }
      }
    });
  }

  void _setAsViewRoot(BranchNode node) {
    viewModel.cachedHtmlParent = node.container.parent;
    viewModel.cachedNextSibling = node.container.nextElementSibling;
    node.container.style.width = Percentage.x100.toString();
    node.container.style.height = Percentage.x100.toString();
    node.container.classes.add("${viewModel.style._classNames[VIEW_ROOT]}");
    viewModel.currentViewRoot = node;
    viewModel.treemapHtmlRoot.children.clear();
    viewModel.treemapHtmlRoot.append(node.container);
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
}
