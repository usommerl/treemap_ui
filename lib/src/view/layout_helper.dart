part of treemap_view;

class LayoutHelper {
  final DivElement _container = new DivElement();
  final BranchNode _parent;
  final Orientation _orientation;
  final Percentage _width;
  final Percentage _height;

  LayoutHelper._internal(this._width, this._height, this._parent, this._orientation) {
    _container.classes.add("${_parent.viewModel.style._classNames[runtimeType.toString()]}");
    _container.style..width = _width.toString()
        ..height = _height.toString();
    _parent.addHelper(this);
  }

  factory LayoutHelper.rowStrip(Percentage size, BranchNode parent, Orientation orientation) {
    LayoutHelper row;
    if (orientation.isHorizontal) {
      row = new LayoutHelper._internal(Percentage.x100, size, parent, orientation);
      row.container.style.float = "none";
    } else {
      row = new LayoutHelper._internal(size, Percentage.x100, parent, orientation);
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
    _container.append(child.container);
    _parent.register(child);
  }

  Orientation get orientation => this._orientation;

  Percentage get width => _width;

  Percentage get height => _height;

  Element get container => _container;

}