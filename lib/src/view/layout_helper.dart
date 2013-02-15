part of treemap_view;

class LayoutHelper implements Attachable {
  
  final DivElement container = new DivElement();
  final BranchNode _parent;
  final Orientation orientation;
  final Percentage width;
  final Percentage height;

  LayoutHelper._internal(this.width, this.height, this._parent, this.orientation) {
    container.classes.add("${_parent.viewModel.style._classNames[runtimeType.toString()]}");
    container.style..width = width.toString()
        ..height = height.toString();
    _parent.addHelper(this);
  }

  factory LayoutHelper.rowStrip(Percentage size, BranchNode parent, Orientation orientation) {
    LayoutHelper row;
    if (orientation.isHorizontal) {
      row = new LayoutHelper._internal(Percentage.ONE_HUNDRED, size, parent, orientation);
      row.container.style.float = "none";
    } else {
      row = new LayoutHelper._internal(size, Percentage.ONE_HUNDRED, parent, orientation);
      row.container.style.float = "left";
    }
    return row;
  }

  factory LayoutHelper.rowSquarified(Percentage width, Percentage height, BranchNode parent, Orientation orientation) {
    var row = new LayoutHelper._internal(width, height, parent, orientation);
    row.container.style.float = "left";
    return row;
  }

  void add(Node child) {
    container.append(child.container);
    _parent.register(child);
  }

}