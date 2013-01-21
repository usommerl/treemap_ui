part of treemap;

class TreemapStyle {
  
  final String cssPrefix;
  final String branchColor;
  final String borderColor;
  final int borderSize; 
  final int branchPadding;
  final String borderStyle;
    
  TreemapStyle(
    {this.cssPrefix     : 'tm-',
     this.branchPadding : 2,
     this.branchColor   : "#999",
     this.borderColor   : "black",
     this.borderSize    : 1, 
     this.borderStyle   : "solid"
    }
  ){
    final inlineStyle = _inlineStyle;
    final styleOrLinkElements = document.head.children.filter((e) => e.runtimeType == StyleElement || e.runtimeType == LinkElement);
    if (styleOrLinkElements.isEmpty) {
      document.head.append(inlineStyle);
    } else {
      if (!styleOrLinkElements.some((e) => e.text == inlineStyle.text)) {
        styleOrLinkElements.first.insertAdjacentElement('beforeBegin', inlineStyle);        
      }
    }
   }  

  StyleElement get _inlineStyle {
    final String inlineStyleHtml = 
"""
<style type="text/css">
.${cssPrefix}${CssIdentifiers.LEAF}, 
.${cssPrefix}${CssIdentifiers.BRANCH}, 
.${cssPrefix}${CssIdentifiers.BRANCH_CONTENT}, 
.${cssPrefix}${CssIdentifiers.LAYOUT_HELPER} {
  margin: 0px;
  padding: 0px;
  box-sizing: border-box;
}
.${cssPrefix}${CssIdentifiers.LEAF}, 
.${cssPrefix}${CssIdentifiers.BRANCH} {
  position: relative;
  overflow: hidden;
  border-color: ${borderColor};
  border-style: ${borderStyle};
  border-width: ${borderSize}px;
}
.${cssPrefix}${CssIdentifiers.BRANCH} {
  background-color: ${branchColor};
}
.${cssPrefix}${CssIdentifiers.BRANCH_CONTENT} {
  position: absolute;
  top: ${branchPadding}px;
  right: ${branchPadding}px;
  bottom: ${branchPadding}px;
  left: ${branchPadding}px;
}
.${cssPrefix}${CssIdentifiers.MODEL_ROOT},
.${cssPrefix}${CssIdentifiers.LAYOUT_HELPER}, 
.${cssPrefix}${CssIdentifiers.MODEL_ROOT}.${cssPrefix}${CssIdentifiers.VIEW_ROOT} {
  border-width: 0px;
}
.${cssPrefix}${CssIdentifiers.MODEL_ROOT} > .${cssPrefix}${CssIdentifiers.BRANCH_CONTENT} {
  top: 0px;
  right: 0px;
  bottom: 0px;
  left: 0px;
}
.${cssPrefix}${CssIdentifiers.LEAF} {
  background-color: #DDD;
}
.${cssPrefix}${CssIdentifiers.NO_LEFT_BORDER}{
  border-left-width: 0px;
}
.${cssPrefix}${CssIdentifiers.NO_TOP_BORDER}{
  border-top-width: 0px;
}
.${cssPrefix}${CssIdentifiers.COLLAPSED_WIDTH}{
  border-left-width: 0px;
  border-right-width: 0px;
  background-color: ${borderColor};
}
.${cssPrefix}${CssIdentifiers.COLLAPSED_HEIGHT}{
  border-top-width: 0px;
  border-bottom-width: 0px;
  background-color: ${borderColor};
}
.${cssPrefix}${CssIdentifiers.COLLAPSED_WIDTH}.${cssPrefix}${CssIdentifiers.BRANCH},
.${cssPrefix}${CssIdentifiers.COLLAPSED_HEIGHT}.${cssPrefix}${CssIdentifiers.BRANCH} {
  background-color: ${branchColor};
}
.${cssPrefix}${CssIdentifiers.VIEW_ROOT}{
  border-width: ${borderSize}px;
}
.${cssPrefix}${Orientation.vertical.toString()}{
  float: none;
}
.${cssPrefix}${Orientation.horizontal.toString()}{
  float: left;
}
</style>
""";
    return new Element.html(inlineStyleHtml);
  }
}