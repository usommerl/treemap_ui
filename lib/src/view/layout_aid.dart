part of treemap_ui_view;

abstract class LayoutAid extends Attachable{
  
  void add(Node child);
  
  void addAid(LayoutAid aid);
  
  BranchNode get aidRoot;

}

class InvisibleLayoutAid implements LayoutAid {

  final DivElement container = new DivElement();
  final BranchNode _aidRoot;
  final Orientation orientation;
  final Percentage width;
  final Percentage height;
  final StreamController<Node> _onChildAddController = new StreamController();

  InvisibleLayoutAid._internal(this.width, this.height, this._aidRoot, this.orientation) {
    container.classes.add("${_aidRoot.viewModel.styleNames[runtimeType.toString()]}");
    container.style..width = width.toString()
        ..height = height.toString();
    _aidRoot.addAid(this);
  }

  factory InvisibleLayoutAid.expand(Percentage size, BranchNode parent, Orientation orientation) {
    InvisibleLayoutAid row;
    if (orientation.isHorizontal) {
      row = new InvisibleLayoutAid._internal(Percentage.ONE_HUNDRED, size, parent, orientation);
      row.container.style.float = "none";
    } else {
      row = new InvisibleLayoutAid._internal(size, Percentage.ONE_HUNDRED, parent, orientation);
      row.container.style.float = "left";
    }
    return row;
  }

  factory InvisibleLayoutAid.alwaysFloatLeft(Percentage width, Percentage height, BranchNode parent, Orientation orientation) {
    var row = new InvisibleLayoutAid._internal(width, height, parent, orientation);
    row.container.style.float = "left";
    return row;
  }

  void add(Node child) {
    container.append(child.container);
    _onChildAddController.add(child);
  }
  
  void addAid(InvisibleLayoutAid aid) {
    container.append(aid.container);
  }
  
  BranchNode get aidRoot => _aidRoot;
  
  Stream<Node> get onChildAdd => _onChildAddController.stream;

}