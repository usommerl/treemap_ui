part of treemap_ui_view;

class Tooltip implements Attachable {

  DivElement container = new DivElement();
  static const String VISIBLE = 'visible';
  Timer _delayTimer = new Timer(const Duration(milliseconds: 0),(){});
  final BranchNode _branchNode;
  final List<StreamSubscription> _subscriptions = [];

  Tooltip(BranchNode this._branchNode) {
    container.classes.add("${_branchNode.viewModel.styleNames[runtimeType.toString()]}");
    _branchNode.container.append(container);
    final hoverElements = [_branchNode._nodeLabel.container, _branchNode._naviLeft, _branchNode._naviRight, _branchNode._naviBottom];
    registerSubscriptions(hoverElements, _branchNode.dataModel);
  }

  void registerSubscriptions(Iterable<Element> hoverElements, DataModel dataModel) {
    hoverElements.forEach((hoverElement) {
      _subscriptions.addAll([
        hoverElement.onMouseMove.listen((MouseEvent event){
          container.classes.remove("${Tooltip.VISIBLE}");
          _delayTimer.cancel();
          _delayTimer = _createTimer(event, hoverElement, dataModel);
        }),
        hoverElement.onMouseOut.listen((MouseEvent event){
          container.classes.remove("${Tooltip.VISIBLE}");
          _delayTimer.cancel();
        })
      ]);
    });
  }

  void cancelSubscriptions() {
    _delayTimer.cancel();
    _subscriptions.forEach((s) => s.cancel());
  }
  
  Timer _createTimer(MouseEvent event, Element hoverElement, DataModel dataModel) {
    return new Timer(const Duration(milliseconds: 1000),(){
      if (_branchNode.viewModel.tooltipsEnabled) {
        final y = dataModel.isLeaf && !dataModel.parent.isRoot ? 
            event.offset.y + _branchNode.viewModel.branchPadding + hoverElement.offset.top :
            event.offset.y + hoverElement.offset.top;
        final x = dataModel.isLeaf && !dataModel.parent.isRoot ? 
            event.offset.x + _branchNode.viewModel.branchPadding + hoverElement.offset.left :
            event.offset.x + hoverElement.offset.left;
        int adjX, adjY = 0;
        _repaintContent(dataModel);
        container.classes.add("${Tooltip.VISIBLE}");
        if (x < _branchNode.container.client.width - x) {
          adjX = x;
        } else {
          adjX = x - container.offset.width;
        }
        if (y < _branchNode.container.client.height - y) {
          adjY = y+18;
        } else {
          adjY = y - container.offset.height-5;
        }
        container.style..left = "${adjX}px"..top = "${adjY}px";
      }
    });
  }

  void _repaintContent(DataModel dataModel) {
    container.children.clear();
    final tooltipContent = dataModel.provideTooltip();
    if (tooltipContent != null) {
      container.append(tooltipContent);
    }
  }

}
