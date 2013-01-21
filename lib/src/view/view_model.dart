part of treemap_view;


class ViewModel {
  
  Node currentViewRoot;
  Element cachedHtmlParent;
  Element cachedNextSibling;
  final DivElement treemapHtmlRoot;
  final Treemap treemap;
  final TreemapStyle style;
  
  ViewModel(this.treemap, this.treemapHtmlRoot, this.style) {
    assert(treemapHtmlRoot.clientHeight > 0);
    assert(treemapHtmlRoot.children.length == 0);
  }
    
  
}
