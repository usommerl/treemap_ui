part of treemap_ui_view;

class Tooltip implements Attachable {

  DivElement container = new DivElement();
  static const String VISIBLE = 'visible';
  Timer _delayTimer = new Timer(const Duration(milliseconds: 0),(){});
  final Node _node;
  List<StreamSubscription> _subscriptions = [];

  Tooltip(Node this._node) {
    container.classes.add("${_node.viewModel.styleNames[runtimeType.toString()]}");
    repaintContent();
    _node.parent.then((BranchNode parent) {
      if (_node.isLeaf) {
        parent._content.append(container);
        _subscriptions = _registerSubscriptions([_node.container], parent._content);
      } else {
        final node = _node as BranchNode;
        node.container.append(container);
        final hoverElements = [node._nodeLabel.container, node._naviLeft, node._naviRight, node._naviBottom];
        _subscriptions = _registerSubscriptions(hoverElements, _node.container);
      }
    });
  }

  Iterable<StreamSubscription> _registerSubscriptions(Iterable<Element> hoverElements, Element tooltipDomParent) {
    final List<StreamSubscription> subscriptions = [];
    hoverElements.forEach((hoverElement) {
      subscriptions.addAll([
        hoverElement.onMouseMove.listen((MouseEvent event){
          container.classes.remove("${Tooltip.VISIBLE}");
          _delayTimer.cancel();
          _delayTimer = new Timer(const Duration(milliseconds: 1000),(){
            if (_node.viewModel.tooltipsEnabled) {
              final y = event.offset.y+hoverElement.offset.top;
              final x = event.offset.x+hoverElement.offset.left;
              int adjX, adjY = 0;
              container.classes.add("${Tooltip.VISIBLE}");
              if (x < tooltipDomParent.client.width - x) {
                adjX = x;
              } else {
                adjX = x - container.offset.width;
              }
              if (y < tooltipDomParent.client.height - y) {
                adjY = y+18;
              } else {
                adjY = y - container.offset.height-5;
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
    });
    return subscriptions;
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
