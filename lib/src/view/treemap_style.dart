part of treemap.view;

class TreemapStyle {

  static int _instanceCounter = 1;
  static final _validBorderStyles = ["none","hidden","dotted","dashed","solid","double", 
                                     "groove", "ridge", "inset", "outset", "inherit"];
  
  final StreamController _styleChangeController = new StreamController.broadcast();
  String _prefix;
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
   _prefix = "tm${_instanceCounter++}-";
  }

  Map<String,String> _initClassNames(String prefix) {
    final map = new Map<String,String>();
    map["${LeafNode}"] = "${prefix}leaf";
    map["${BranchNode}"] = "${prefix}branch";
    map["${LayoutHelper}"] = "${prefix}layoutHelper";
    map["${Tooltip}"] = "${prefix}tooltip";
    map["${NodeLabel}"] = "${prefix}label";
    map[BranchNode.CONTENT] = "${prefix}${BranchNode.CONTENT}";
    map[BranchNode.MODEL_ROOT] = "${prefix}${BranchNode.MODEL_ROOT}";
    map[ViewModel.VIEW_ROOT] = "${prefix}${ViewModel.VIEW_ROOT}";
    map[Node.NO_LEFT_BORDER] = "${prefix}${Node.NO_LEFT_BORDER}";
    map[Node.NO_TOP_BORDER] = "${prefix}${Node.NO_TOP_BORDER}";
    map[Node.COLLAPSED_WIDTH] = "${prefix}${Node.COLLAPSED_WIDTH}";
    map[Node.COLLAPSED_HEIGHT] = "${prefix}${Node.COLLAPSED_HEIGHT}";
    map[Orientation.VERTICAL.toString()] = "${prefix}${Orientation.VERTICAL.toString()}";
    map[Orientation.HORIZONTAL.toString()] = "${prefix}${Orientation.HORIZONTAL.toString()}";
    map[NAVIGATION_ELEMENT] = "${prefix}${NAVIGATION_ELEMENT}";
    return map;
  }

  StyleElement get inlineStyle {
    this._classNames = _initClassNames(prefix);
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
.${_classNames[BranchNode.MODEL_ROOT]}.${_classNames[ViewModel.VIEW_ROOT]} {
  border-width: 0px;
}
.${_classNames[BranchNode.MODEL_ROOT]} > .${_classNames[BranchNode.CONTENT]} {
  top: 0px;
  right: 0px;
  bottom: 0px;
  left: 0px;
}
.${_classNames[BranchNode.MODEL_ROOT]} > .${_classNames["${NodeLabel}"]} {
  display: none;
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
.${_classNames[ViewModel.VIEW_ROOT]}[style]{
  width: 100% !important;
  height: 100% !important;
}
.${_classNames[ViewModel.VIEW_ROOT]}{
  border-width: ${_borderWidth}px;
}
.${_classNames[Orientation.VERTICAL.toString()]}{
  float: none;
}
.${_classNames[Orientation.HORIZONTAL.toString()]}{
  float: left;
}
.${_classNames[NAVIGATION_ELEMENT]}{
  cursor: pointer;
}
</style>
""";
    return new Element.html(inlineStyleHtml);
  }

  Color get branchColor => _branchColor;

  set branchColor(Color color) {
    if (color == null) {
      throw Treemap.nullError;
    }
    _branchColor = color;
    _styleChangeController.add(null);
  }

  int get branchPadding => _branchPadding;

  set branchPadding(int branchPadding) {
    if (branchPadding == null || branchPadding < 0) {
      throw new ArgumentError("branchPadding has to be a positive value");
    }
    _branchPadding = branchPadding;
    _styleChangeController.add(null);
  }

  Color get borderColor => _borderColor;

  set borderColor(Color borderColor) {
    if (borderColor == null) {
      throw Treemap.nullError;
    }
    _borderColor = borderColor;
    _styleChangeController.add(null);
  }

  int get borderWidth => _borderWidth;

  set borderWidth(int borderWidth) {
    if (borderWidth == null || borderWidth < 0) {
      throw new ArgumentError("borderWidth has to be a positive value");
    }
    _borderWidth = borderWidth;
    _styleChangeController.add(null);
  }

  String get borderStyle => _borderStyle;

  set borderStyle(String borderStyle) {
    if (borderStyle == null || !_validBorderStyles.contains(borderStyle)) {
      throw new ArgumentError("Please pass a valid CSS border-style");
    }
    _borderStyle = borderStyle;
    _styleChangeController.add(null);
  }
  
  String get prefix => _prefix;
  
  set prefix(String prefix) {
    if (prefix == null) {
      throw Treemap.nullError;
    }
    _prefix = prefix;
    _styleChangeController.add(null);
  }
}
