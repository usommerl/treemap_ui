part of treemap_view;

class Tooltip {
  
  static const String VISIBLE = 'visible';
  final DivElement container = new DivElement();
  Timer _delayTimer = new Timer(0,(timer){});
  final Node node;
  
  Tooltip(Node this.node) {  
    container.classes.add("${node.viewModel.style._classNames[runtimeType.toString()]}");
    container.append(node.dataModel.ancillaryData.provideTooltip());
    if (node.isLeaf) {
      _register(node.container, node.parent._content);
    } else {
      _register(node._nodeLabel, node.container);
    }
  }
  
  void _register(Element hoverElement, Element tooltipDomParent) {
    tooltipDomParent.append(container);
    hoverElement.onMouseMove.listen((MouseEvent event){
      container.classes.remove("${Tooltip.VISIBLE}");
      _delayTimer.cancel();
      _delayTimer = new Timer(1000,(timer){
        if (node.viewModel.treemap.showTooltips) {
          final y = event.offsetY+hoverElement.offsetTop;
          final x = event.offsetX+hoverElement.offsetLeft;
          int adjX, adjY = 0;
          container.classes.add("${Tooltip.VISIBLE}");
          if (x < tooltipDomParent.clientWidth - x) {
            adjX = x;
          } else {
            adjX = x - container.clientWidth;
          }
          if (y < tooltipDomParent.clientHeight - y) {
            adjY = y+18;
          } else {
            adjY = y - container.clientHeight-5;
          }
          container.style..left = "${adjX}px"
                         ..top = "${adjY}px";
        }
      });
    });
    hoverElement.onMouseOut.listen((MouseEvent event){
      container.classes.remove("${Tooltip.VISIBLE}");
      _delayTimer.cancel();
    });
  }
  
  
}
