part of treemap.view;

class Tooltip implements Attachable {

  DivElement container = new DivElement();
  static const String VISIBLE = 'visible';
  Timer _delayTimer = new Timer(const Duration(milliseconds: 0),(){});
  final Node _node;
  final List<StreamSubscription> _subscriptions = [];

  Tooltip(Node this._node) {
    container.classes.add("${_node.viewModel.styleNames[runtimeType.toString()]}");
    repaintContent();
    _node.parent.then((BranchNode parent) {
      if (_node.isLeaf) {
        _establishDomHierarchyAndSubscriptions(_node.container, parent._content);
      } else {
        _establishDomHierarchyAndSubscriptions(_node._nodeLabel.container, _node.container);
      }
    });
  }

  void _establishDomHierarchyAndSubscriptions(Element hoverElement, Element tooltipDomParent) {
    tooltipDomParent.append(container);
    _subscriptions.addAll([
      hoverElement.onMouseMove.listen((MouseEvent event){
        container.classes.remove("${Tooltip.VISIBLE}");
        _delayTimer.cancel();
        _delayTimer = new Timer(const Duration(milliseconds: 1000),(){
          if (_node.viewModel.tooltipsEnabled) {
            final y = event.offsetY+hoverElement.offsetTop;
            final x = event.offsetX+hoverElement.offsetLeft;
            int adjX, adjY = 0;
            container.classes.add("${Tooltip.VISIBLE}");
            if (x < tooltipDomParent.clientWidth - x) {
              adjX = x;
            } else {
              adjX = x - container.offsetWidth;
            }
            if (y < tooltipDomParent.clientHeight - y) {
              adjY = y+18;
            } else {
              adjY = y - container.offsetHeight-5;
            }
            container.style..left = "${adjX}px"
                           ..top = "${adjY}px";
          }
        });
      }),
      hoverElement.onMouseOut.listen((MouseEvent event){
        container.classes.remove("${Tooltip.VISIBLE}");
        _delayTimer.cancel();
      })
    ]);
  }

  void repaintContent() {
    container.children.clear();
    final tooltipContent = _node.dataModel.provideTooltip();
    if (tooltipContent != null) {
      container.append(tooltipContent);
    }
  }

  void cancelSubscriptions() {
    _delayTimer.cancel();
    _subscriptions.forEach((s) => s.cancel());
  }

}
