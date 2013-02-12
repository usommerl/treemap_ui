part of treemap_view;

class TreemapStyle {

  final String stylePrefix;
  final Color branchColor;
  final Color borderColor;
  final int borderWidth;
  final int branchPadding;
  final String borderStyle;
  Map<String,String> _classNames;

  TreemapStyle(
    {this.stylePrefix   : 'tm-',
     this.branchPadding : 2,
     this.branchColor   : Color.gray,
     this.borderColor   : Color.black,
     this.borderWidth   : 1,
     this.borderStyle   : "solid"
    }
  ){
    final inlineStyle = _inlineStyle();
    final styleOrLinkElements = document.head.children.where((e) => e.runtimeType == StyleElement || e.runtimeType == LinkElement);
    if (styleOrLinkElements.isEmpty) {
      document.head.append(inlineStyle);
    } else {
      if (!styleOrLinkElements.any((e) => e.text == inlineStyle.text)) {
        styleOrLinkElements.first.insertAdjacentElement('beforeBegin', inlineStyle);
      }
    }
   }

  Map<String,String> _initClassNames() {
    final map = new Map<String,String>();
    map["${LeafNode}"] = "${stylePrefix}leaf";
    map["${BranchNode}"] = "${stylePrefix}branch";
    map["${LayoutHelper}"] = "${stylePrefix}layoutHelper";
    map["${Tooltip}"] = "${stylePrefix}tooltip";
    map[BranchNode.CONTENT] = "${stylePrefix}${BranchNode.CONTENT}";
    map[BranchNode.MODEL_ROOT] = "${stylePrefix}${BranchNode.MODEL_ROOT}";
    map[BranchNode.VIEW_ROOT] = "${stylePrefix}${BranchNode.VIEW_ROOT}";
    map[Node.NO_LEFT_BORDER] = "${stylePrefix}${Node.NO_LEFT_BORDER}";
    map[Node.NO_TOP_BORDER] = "${stylePrefix}${Node.NO_TOP_BORDER}";
    map[Node.COLLAPSED_WIDTH] = "${stylePrefix}${Node.COLLAPSED_WIDTH}";
    map[Node.COLLAPSED_HEIGHT] = "${stylePrefix}${Node.COLLAPSED_HEIGHT}";
    map[Orientation.vertical.toString()] = "${stylePrefix}${Orientation.vertical.toString()}";
    map[Orientation.horizontal.toString()] = "${stylePrefix}${Orientation.horizontal.toString()}";

    return map;
  }

  StyleElement _inlineStyle() {
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
  border-color: ${borderColor};
  border-style: ${borderStyle};
  border-width: ${borderWidth}px;
}
.${_classNames["${BranchNode}"]}  {
  background-color: ${branchColor};
}
.${_classNames[BranchNode.CONTENT]} {
  position: absolute;
  top: ${branchPadding}px;
  right: ${branchPadding}px;
  bottom: ${branchPadding}px;
  left: ${branchPadding}px;
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
  background-color: ${borderColor} !important;
}
.${_classNames[Node.COLLAPSED_HEIGHT]}[style] {
  border-top-width: 0px;
  border-bottom-width: 0px;
  background-color: ${borderColor} !important;
}
.${_classNames[Node.COLLAPSED_WIDTH]}.${_classNames["${BranchNode}"]},
.${_classNames[Node.COLLAPSED_HEIGHT]}.${_classNames["${BranchNode}"]} {
  background-color: ${branchColor};
}
.${_classNames[BranchNode.VIEW_ROOT]}{
  border-width: ${borderWidth}px;
}
.${_classNames[Orientation.vertical.toString()]}{
  float: none;
}
.${_classNames[Orientation.horizontal.toString()]}{
  float: left;
}
</style>
""";
    return new Element.html(inlineStyleHtml);
  }
}