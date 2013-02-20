part of treemap_view;

class TreemapStyle {

  static int _instantiationCounter = 1;
  final StreamController _styleChangeController = new StreamController.broadcast();
  final String _stylePrefix = "tm${_instantiationCounter++}-";
  Color _branchColor;
  Color _borderColor;
  int _borderWidth;
  int _branchPadding;
  String _borderStyle;
  Map<String,String> _classNames;
  Stream onStyleChange;

  TreemapStyle(
    {Color this._branchColor    : Color.GRAY,
     int this._branchPadding    : 2,
     Color this._borderColor    : Color.BLACK,
     int this._borderWidth      : 1,
     String this._borderStyle   : "solid"
    }
  ){
   onStyleChange = _styleChangeController.stream; 
  }

  Map<String,String> _initClassNames() {
    final map = new Map<String,String>();
    map["${LeafNode}"] = "${_stylePrefix}leaf";
    map["${BranchNode}"] = "${_stylePrefix}branch";
    map["${LayoutHelper}"] = "${_stylePrefix}layoutHelper";
    map["${Tooltip}"] = "${_stylePrefix}tooltip";
    map["${NodeLabel}"] = "${_stylePrefix}label";
    map[BranchNode.CONTENT] = "${_stylePrefix}${BranchNode.CONTENT}";
    map[BranchNode.MODEL_ROOT] = "${_stylePrefix}${BranchNode.MODEL_ROOT}";
    map[BranchNode.VIEW_ROOT] = "${_stylePrefix}${BranchNode.VIEW_ROOT}";
    map[Node.NO_LEFT_BORDER] = "${_stylePrefix}${Node.NO_LEFT_BORDER}";
    map[Node.NO_TOP_BORDER] = "${_stylePrefix}${Node.NO_TOP_BORDER}";
    map[Node.COLLAPSED_WIDTH] = "${_stylePrefix}${Node.COLLAPSED_WIDTH}";
    map[Node.COLLAPSED_HEIGHT] = "${_stylePrefix}${Node.COLLAPSED_HEIGHT}";
    map[Orientation.VERTICAL.toString()] = "${_stylePrefix}${Orientation.VERTICAL.toString()}";
    map[Orientation.HORIZONTAL.toString()] = "${_stylePrefix}${Orientation.HORIZONTAL.toString()}";
    return map;
  }

  StyleElement get inlineStyle {
    this._classNames = _initClassNames();
    final String inlineStyleHtml =
"""
<style type="text/css">
.${_classNames["${LeafNode}"]},
.${_classNames["${BranchNode}"]},
.${_classNames["${LayoutHelper}"]},
.${_classNames[BranchNode.CONTENT]} {
  margin: 0px;
  padding: 0px;
  box-sizing: border-box;
}
.${_classNames["${LeafNode}"]},
.${_classNames["${BranchNode}"]} {
  position: relative;
  overflow: hidden;
  border-color: ${_borderColor};
  border-style: ${_borderStyle};
  border-width: ${_borderWidth}px;
}
.${_classNames["${BranchNode}"]}  {
  background-color: ${_branchColor};
}
.${_classNames[BranchNode.CONTENT]} {
  position: absolute;
  top: ${_branchPadding}px;
  right: ${_branchPadding}px;
  bottom: ${_branchPadding}px;
  left: ${_branchPadding}px;
}
.${_classNames[BranchNode.MODEL_ROOT]},
.${_classNames["${LayoutHelper}"]},
.${_classNames[BranchNode.MODEL_ROOT]}.${_classNames[BranchNode.VIEW_ROOT]} {
  border-width: 0px;
}
.${_classNames[BranchNode.MODEL_ROOT]} > .${_classNames[BranchNode.CONTENT]} {
  top: 0px;
  right: 0px;
  bottom: 0px;
  left: 0px;
}
.${_classNames["${LeafNode}"]} *:first-child {
  cursor: default;
}
.${_classNames["${Tooltip}"]} {
  position: absolute;
  z-index: 1;
  display: none;
}
.${_classNames["${Tooltip}"]}.${Tooltip.VISIBLE} {
  display: block;
}
.${_classNames[Node.NO_LEFT_BORDER]}{
  border-left-width: 0px;
}
.${_classNames[Node.NO_TOP_BORDER]}{
  border-top-width: 0px;
}
.${_classNames[Node.COLLAPSED_WIDTH]}[style] {
  border-left-width: 0px;
  border-right-width: 0px;
  background-color: ${_borderColor} !important;
}
.${_classNames[Node.COLLAPSED_HEIGHT]}[style] {
  border-top-width: 0px;
  border-bottom-width: 0px;
  background-color: ${_borderColor} !important;
}
.${_classNames[Node.COLLAPSED_WIDTH]}.${_classNames["${BranchNode}"]},
.${_classNames[Node.COLLAPSED_HEIGHT]}.${_classNames["${BranchNode}"]} {
  background-color: ${_branchColor};
}
.${_classNames[BranchNode.VIEW_ROOT]}{
  border-width: ${_borderWidth}px;
}
.${_classNames[Orientation.VERTICAL.toString()]}{
  float: none;
}
.${_classNames[Orientation.HORIZONTAL.toString()]}{
  float: left;
}
</style>
""";
    return new Element.html(inlineStyleHtml);
  }
  
  Color get branchColor => _branchColor;
  
  set branchColor(Color color) {
    _branchColor = color;
    _styleChangeController.add(null);
  }
  
  int get branchPadding => _branchPadding;
  
  set branchPadding(int branchPadding) {
    _branchPadding = branchPadding;
    _styleChangeController.add(null);
  }
  
  Color get borderColor => _borderColor;
  
  set borderColor(Color borderColor) {
    _borderColor = borderColor;
    _styleChangeController.add(null);
  }
  
  int get borderWidth => _borderWidth;
  
  set borderWidth(int borderWidth) {
    _borderWidth = borderWidth;
    _styleChangeController.add(null);
  }
  
  String get borderStyle => _borderStyle;
  
  set borderStyle(String borderStyle) {
    _borderStyle = borderStyle;
    _styleChangeController.add(null);
  }
}
