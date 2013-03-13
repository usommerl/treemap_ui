part of treemap.view;

class ViewModel {

  static const String VIEW_ROOT = "viewRoot";

  final Treemap _treemap;
  Node _viewRoot;
  Node _rootNode;
  Element _cachedHtmlParent;
  Element _cachedNextSibling;

  ViewModel(this._treemap);

  Map<String,String> get styleNames => _treemap.style._classNames;

  int get borderWidth => _treemap.style.borderWidth;

  int get branchPadding => _treemap.style.branchPadding;

  bool get automaticUpdatesEnabled => _treemap.automaticRepaints;

  bool get tooltipsEnabled => _treemap.showTooltips;

  bool get componentTraversable => _treemap.isTraversable;

  void branchClicked(BranchNode node) {
    if (_treemap.isTraversable) {
      if (node == _viewRoot && node != _rootNode ) {
        _recreatePristineHtmlHierarchy(node);
        node.parent.then((parent) {
          _setAsViewRoot(parent);
          node.rectifyAppearance();
        });
      } else if (node != _viewRoot) {
        node.parent.then((parent){
          if (parent == _viewRoot && parent != _rootNode) {
            _recreatePristineHtmlHierarchy(parent);
          }
          _setAsViewRoot(node);
          node.rectifyAppearance();
        });
      }
    }
  }

  void setViewRoot(Node rootNode) {
    _rootNode = rootNode;
    _viewRoot = _rootNode;
  }

  List<BranchNode> _findAllSubBranches(Node root) {
    if (root.isLeaf) {
      return [];
    } else {
      return (root as BranchNode).children.reduce([],(prev,child) {
        if (child.isBranch) {
          prev.add(child);
          prev.addAll(_findAllSubBranches(child));
        }
        return prev;
      });
    }
  }

  void _setAsViewRoot(BranchNode node) {
    _cachedHtmlParent = node.container.parent;
    _cachedNextSibling = node.container.nextElementSibling;
    node.container.classes.add("${styleNames[VIEW_ROOT]}");
    _viewRoot = node;
    _treemap.componentRoot.children.clear();
    _treemap.componentRoot.append(node.container);
  }

  void _recreatePristineHtmlHierarchy(BranchNode node) {
    node.container.classes.remove("${styleNames[VIEW_ROOT]}");
    if (_cachedNextSibling == null) {
      _cachedHtmlParent.append(node.container);
    } else {
      _cachedNextSibling.insertAdjacentElement('beforeBegin', node.container);
    }
  }
}
