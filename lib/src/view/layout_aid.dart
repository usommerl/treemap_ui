part of treemap_ui_view;

class LayoutAid implements NodeContainer {

  final DivElement container = new DivElement();
  final BranchNode _nodeContainerRoot;
  final Orientation orientation;
  final Percentage width;
  final Percentage height;
  final StreamController<Node> _onChildAddController = new StreamController();

  LayoutAid._internal(this.width, this.height, this._nodeContainerRoot, this.orientation) {
    container.classes.add("${_nodeContainerRoot.viewModel.styleNames[runtimeType.toString()]}");
    container.style..width = width.toString()
        ..height = height.toString();
    _nodeContainerRoot.addLayoutAid(this);
  }

  factory LayoutAid.expand(Percentage size, BranchNode parent, Orientation orientation) {
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

  factory LayoutAid.alwaysFloatLeft(Percentage width, Percentage height, BranchNode parent, Orientation orientation) {
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
  
  BranchNode get nodeContainerRoot => _nodeContainerRoot;
  
  Stream<Node> get onChildAdd => _onChildAddController.stream;

}