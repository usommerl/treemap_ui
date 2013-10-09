part of treemap_ui.view;

/**
 * An object which configures several visual ascpects of a [Treemap] instance.
 *
 * The [TreemapStyle] class features a simple event system, which is used to 
 * notify observers about property changes.
 */
class TreemapStyle {

  static int _instanceCounter = 1;
  static final _validBorderStyles = ["none","hidden","dotted","dashed","solid","double",
                                     "groove", "ridge", "inset", "outset", "inherit"];
  final StreamController _onChangeController = new StreamController.broadcast();
  String _prefix;
  Color _borderColor;
  int _borderWidth;
  int _branchPadding;
  String _borderStyle;
  Map<String,String> _styleNames;

  TreemapStyle({
     int branchPadding    : 2,
     Color borderColor    : Color.BLACK,
     int borderWidth      : 1,
     String borderStyle   : "solid"
  }){
     _branchPadding = branchPadding;
     _borderColor = borderColor;
     _borderWidth = borderWidth;
     _borderStyle = borderStyle;
     _prefix = "tm${_instanceCounter++}-";
  }

  /// Events which are triggered when a property of this instance is modified.
  Stream get onChange => _onChangeController.stream;
  
  /**
   * Size of the padding area around the content of a branch in px.
   *
   * Please note that the top padding is determined by the height of the branch label. 
   * Only if the label height is smaller than [branchPadding], then this value also
   * apllies to the top padding.
   */
  int get branchPadding => _branchPadding;

  set branchPadding(int branchPadding) {
    if (branchPadding == null || branchPadding < 0) {
      throw new ArgumentError("branchPadding has to be a positive value");
    }
    _branchPadding = branchPadding;
    _onChangeController.add(null);
  }

  /// Color of the border around leaf and branch nodes.
  Color get borderColor => _borderColor;

  set borderColor(Color borderColor) {
    if (borderColor == null) {
      throw nullError;
    }
    _borderColor = borderColor;
    _onChangeController.add(null);
  }

  /// Width of the border around leaf and branch nodes in px.
  int get borderWidth => _borderWidth;

  set borderWidth(int borderWidth) {
    if (borderWidth == null || borderWidth < 0) {
      throw new ArgumentError("borderWidth has to be a positive value");
    }
    _borderWidth = borderWidth;
    _onChangeController.add(null);
  }

  /// Style of the border around leaf and branch nodes.
  String get borderStyle => _borderStyle;

  set borderStyle(String borderStyle) {
    if (borderStyle == null || !_validBorderStyles.contains(borderStyle)) {
      throw new ArgumentError("Please pass a valid CSS border-style");
    }
    _borderStyle = borderStyle;
    _onChangeController.add(null);
  }

  /**
   * Prefix string which is used in CSS selectors.
   * 
   * The prefix is automatically generated during instantiation. You may change 
   * this value if a [TreemapStyle] CSS rule conflicts with one of your own.
   */
  String get prefix => _prefix;

  set prefix(String prefix) {
    if (prefix == null) {
      throw nullError;
    }
    _prefix = prefix;
    _onChangeController.add(null);
  }

  /**
   * Element which contains the style rules for a [Treemap].
   *
   * The [Treemap] instance calls this getter and inserts the result
   * into the [HeadElement] of your [document].
   */
  StyleElement get inlineStyle {
    this._styleNames = _initStyleNames(prefix);
    final styleElement = new StyleElement();
    final String styleRules =
"""
.${_styleNames["${LeafNode}"]},
.${_styleNames["${BranchNode}"]},
.${_styleNames["${LayoutAid}"]},
.${_styleNames[BranchNode.CONTENT]},
.${_styleNames[BranchNode.NAVI_LEFT]},
.${_styleNames[BranchNode.NAVI_RIGHT]},
.${_styleNames[BranchNode.NAVI_BOTTOM]} {
  margin: 0px;
  padding: 0px;
  box-sizing: border-box;
}
.${_styleNames["${LeafNode}"]},
.${_styleNames["${BranchNode}"]} {
  position: relative;
  overflow: hidden;
  border-color: ${_borderColor};
  border-style: ${_borderStyle};
  border-width: ${_borderWidth}px;
}
.${_styleNames[BranchNode.CONTENT]},
.${_styleNames[BranchNode.NAVI_LEFT]},
.${_styleNames[BranchNode.NAVI_RIGHT]},
.${_styleNames[BranchNode.NAVI_BOTTOM]}{
  position: absolute;
}
.${_styleNames[BranchNode.NAVI_LEFT]},
.${_styleNames[BranchNode.NAVI_RIGHT]},
.${_styleNames[BranchNode.NAVI_BOTTOM]}{
  z-index: 0;
}
.${_styleNames[BranchNode.CONTENT]} {
  top: ${_branchPadding}px;
  right: ${_branchPadding}px;
  bottom: ${_branchPadding}px;
  left: ${_branchPadding}px;
  z-index: 1;
}
.${_styleNames[BranchNode.NAVI_LEFT]} {
  width: ${_branchPadding}px;
  bottom: 0px;
  left: 0px;
}
.${_styleNames[BranchNode.NAVI_RIGHT]} {
  width: ${_branchPadding}px;
  bottom: 0px;
  right: 0px;
}
.${_styleNames[BranchNode.NAVI_BOTTOM]} {
  height: ${_branchPadding}px;
  bottom: 0px;
  left: 0px;
  right: 0px;
}
.${_styleNames[BranchNode.MODEL_ROOT]},
.${_styleNames["${LayoutAid}"]},
.${_styleNames[BranchNode.MODEL_ROOT]}.${_styleNames[ViewModel.VIEW_ROOT]} {
  border-width: 0px;
}
.${_styleNames[BranchNode.MODEL_ROOT]} > .${_styleNames[BranchNode.CONTENT]} {
  top: 0px;
  right: 0px;
  bottom: 0px;
  left: 0px;
}
.${_styleNames[BranchNode.MODEL_ROOT]} > .${_styleNames["${NodeLabel}"]} {
  display: none;
}
.${_styleNames["${LeafNode}"]} *:first-child {
  cursor: default;
}
.${_styleNames["${Tooltip}"]} {
  position: absolute;
  z-index: 2;
  display: none;
}
.${_styleNames["${Tooltip}"]}.${Tooltip.VISIBLE} {
  display: block;
}
.${_styleNames[Node.NO_LEFT_BORDER]}{
  border-left-width: 0px;
}
.${_styleNames[Node.NO_TOP_BORDER]}{
  border-top-width: 0px;
}
.${_styleNames[Node.COLLAPSED_WIDTH]}[style] {
  border-left-width: 0px;
  border-right-width: 0px;
  background-color: ${_borderColor} !important;
}
.${_styleNames[Node.COLLAPSED_HEIGHT]}[style] {
  border-top-width: 0px;
  border-bottom-width: 0px;
  background-color: ${_borderColor} !important;
}
.${_styleNames[ViewModel.VIEW_ROOT]}[style]{
  width: 100% !important;
  height: 100% !important;
}
.${_styleNames[ViewModel.VIEW_ROOT]}{
  border-width: ${_borderWidth}px;
}
.${_styleNames[Orientation.VERTICAL.toString()]}{
  float: none;
}
.${_styleNames[Orientation.HORIZONTAL.toString()]}{
  float: left;
}
.${_styleNames[NAVIGATION_ELEMENT]}{
  cursor: pointer;
}
""";
    styleElement.text = styleRules;
    return styleElement;
  }

  Map<String,String> _initStyleNames(String prefix) {
    final map = new Map<String,String>();
    map["${LeafNode}"] = "${prefix}leaf";
    map["${BranchNode}"] = "${prefix}branch";
    map["${LayoutAid}"] = "${prefix}layoutAid";
    map["${Tooltip}"] = "${prefix}tooltip";
    map["${NodeLabel}"] = "${prefix}label";
    map[BranchNode.CONTENT] = "${prefix}${BranchNode.CONTENT}";
    map[BranchNode.MODEL_ROOT] = "${prefix}${BranchNode.MODEL_ROOT}";
    map[BranchNode.NAVI_LEFT] = "${prefix}${BranchNode.NAVI_LEFT}";
    map[BranchNode.NAVI_RIGHT] = "${prefix}${BranchNode.NAVI_RIGHT}";
    map[BranchNode.NAVI_BOTTOM] = "${prefix}${BranchNode.NAVI_BOTTOM}";
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
}
