part of treemap_view;

class BranchNode extends Node {
  
  final List<Node> children = [];
  final List<LayoutHelper> layoutHelpers = [];
  
  BranchNode(Branch dataModel, width, height, orientation) :
    super._internal(dataModel,width,height,orientation) {
      var padding;
      if (isModelRoot) {
        padding = 0;
        _nodeLabel.style.display = "none";
      } else {
        padding = 2;
      }
      _nodeLabel.attributes["align"] = "center";
      container.style.backgroundColor = "#999";
      _content = new DivElement();
      _content.style
          ..margin = "0px"
          ..padding = "0px"
          ..position = "absolute"
          ..left = "${padding}px"
          ..right = "${padding}px"
          ..bottom = "${padding}px"
          ..top = "${padding}px";
      container.append(_nodeLabel);
      container.append(_content);
      if (isModelRoot) {
        _initialBorderString = "0px";
        container.style.border = _initialBorderString;
      }
      registerListeners();
    }
  
  void register(Node child) {
    child.parent = this;
    child.viewModel = this.viewModel;
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
    viewModel.cachedBorder = node.container.style.border;
    viewModel.cachedBorderWidth = node.container.style.borderWidth;
    node.container.style.width = Percentage.x100.toString();
    node.container.style.height = Percentage.x100.toString();
    node.container.style.border = node._initialBorderString;
    viewModel.currentViewRoot = node;
    viewModel.treemapHtmlRoot.children.clear();
    viewModel.treemapHtmlRoot.append(node.container);
  }
  
  void _recreateInitialHtmlHierarchy(BranchNode node) {
    node.container.style.width = node.width.toString();
    node.container.style.height = node.height.toString();
    node.container.style.border = viewModel.cachedBorder;
    node.container.style.borderWidth = viewModel.cachedBorderWidth;
    if (viewModel.cachedNextSibling == null) {
      viewModel.cachedHtmlParent.append(node.container);      
    } else {
      viewModel.cachedNextSibling.insertAdjacentElement('beforeBegin', node.container);
    }
  }
}
