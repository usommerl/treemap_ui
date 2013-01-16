part of treemap_view;

class BranchNode extends Node {
  
  final List<Node> children = [];
  final List<LayoutHelper> layoutHelpers = [];
  
  BranchNode(Branch model, width, height, orientation) :
    super._internal(model,width,height,orientation) {
      var padding;
      if (model.isRoot) {
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
      container.style.border = model.isRoot ? "0px" : _borderStyle;
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
  
  Branch get model => this._model;
}
