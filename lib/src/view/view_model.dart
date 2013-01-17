part of treemap_view;


class ViewModel {
  
  Node currentViewRoot;
  Element cachedHtmlParent;
  Element cachedNextSibling;
  String cachedBorder;
  String cachedBorderWidth;
  final DivElement treemapHtmlRoot;
  final TreeMap treemap;
  
  ViewModel(this.treemap, this.treemapHtmlRoot) {
    assert(treemapHtmlRoot.clientHeight > 0);
    assert(treemapHtmlRoot.children.length == 0);
  }
    
  
}
