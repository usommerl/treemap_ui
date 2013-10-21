part of treemap_ui.view;

class LayoutAid implements NodeContainer {

  final DivElement shell = new DivElement();
  final NodeContainer _parent;
  final Orientation orientation;
  final Percentage width;
  final Percentage height;

  LayoutAid._internal(this.width, this.height, this._parent, this.orientation) {
    shell.classes.add("${node.viewModel.styleNames[runtimeType.toString()]}");
    shell.style..width = width.toString()
                   ..height = height.toString();
    node.layoutAids.add(this);
    _parent.mount(this);
  }

  factory LayoutAid.expand(Percentage size, NodeContainer parent, Orientation orientation) {
    LayoutAid row;
    if (orientation.isHorizontal) {
      row = new LayoutAid._internal(Percentage.ONE_HUNDRED, size, parent, orientation);
      row.shell.style.float = "none";
    } else {
      row = new LayoutAid._internal(size, Percentage.ONE_HUNDRED, parent, orientation);
      row.shell.style.float = "left";
    }
    return row;
  }

  void add(Node child) {
    shell.append(child.shell);
    node.register(child);
  }
  
  void mount(LayoutAid aid) {
    shell.append(aid.shell);
  }
  
  Rectangle get client => shell.client;
  
  BranchNode get node => _parent.node;
  
}