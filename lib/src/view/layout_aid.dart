part of treemap_ui.view;

class LayoutAid implements NodeContainer {

  final DivElement container = new DivElement();
  final NodeContainer _parent;
  final Orientation orientation;
  final Percentage width;
  final Percentage height;
  final StreamController<Node> _onChildAddController = new StreamController();

  LayoutAid._internal(this.width, this.height, this._parent, this.orientation) {
    container.classes.add("${nodeContainerRoot.viewModel.styleNames[runtimeType.toString()]}");
    container.style..width = width.toString()
        ..height = height.toString();
    nodeContainerRoot.addLayoutAid(this);
    if (_parent is LayoutAid) {
      _parent.addLayoutAid(this);
    }
  }

  factory LayoutAid.expand(Percentage size, NodeContainer parent, Orientation orientation) {
    LayoutAid row;
    if (orientation.isHorizontal) {
      row = new LayoutAid._internal(Percentage.ONE_HUNDRED, size, parent, orientation);
      row.container.style.float = "none";
    } else {
      row = new LayoutAid._internal(size, Percentage.ONE_HUNDRED, parent, orientation);
      row.container.style.float = "left";
    }
    return row;
  }

  // TODO: First implementation of Squarified algorithm needs this. Remove?
  factory LayoutAid.alwaysFloatLeft(Percentage width, Percentage height, NodeContainer parent, Orientation orientation) {
    var row = new LayoutAid._internal(width, height, parent, orientation);
    row.container.style.float = "left";
    return row;
  }

  void add(Node child) {
    container.append(child.container);
    _onChildAddController.add(child);
  }
  
  void addLayoutAid(LayoutAid aid) {
    container.append(aid.container);
  }
  
  Rect get client => container.client;
  
  BranchNode get nodeContainerRoot => _parent.nodeContainerRoot;
  
  Stream<Node> get onChildAdd => _onChildAddController.stream;

}