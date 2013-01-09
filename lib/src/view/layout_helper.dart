part of treemap_view;

class LayoutHelper {
  final DivElement _container = new DivElement();
  final TreemapNode _parent;
  final Orientation _orientation;
  final Percentage _width;
  final Percentage _height;

  LayoutHelper._internal(this._width, this._height, this._parent, this._orientation) {
    _container.style..margin = "0px"
        ..boxSizing = "border-box"
        ..padding = "0px"
        ..width = _width.toString()
        ..height = _height.toString();
    _container.classes.add(this.runtimeType.toString());
    _container.classes.add(_orientation.toString());
    _parent.addHelper(this);
  }

  factory LayoutHelper.rowStrip(Percentage size, TreemapNode parent, Orientation orientation) {
    LayoutHelper row;
    if (orientation.isHorizontal()) {
      row = new LayoutHelper._internal(Percentage.x100, size, parent, orientation);
      row.container.style.float = "none";
    } else {
      row = new LayoutHelper._internal(size, Percentage.x100, parent, orientation);
      row.container.style.float = "left";
    }
    return row;
  }

  factory LayoutHelper.rowSquarified(Percentage width, Percentage height, TreemapNode parent, Orientation orientation) {
    var row = new LayoutHelper._internal(width, height, parent, orientation);
    row.container.style.float = "left";
    return row;
  }

  void add(TreemapNode child) {
    _container.append(child.container);
    _parent.register(child);
  }
  
  Orientation get orientation => this._orientation;
  
  Percentage get width => this._width;
  
  Percentage get height => this._height;
  
  Element get container => this._container;
  
}