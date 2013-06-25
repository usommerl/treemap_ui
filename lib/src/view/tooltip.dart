part of treemap_ui.view;

class Tooltip implements Attachable {

  static const String VISIBLE = 'visible';
  final List<StreamSubscription> _mouseSubscriptions = [];
  final DisplayArea _displayArea;
  StreamSubscription _dataModelSubscription;
  DivElement container = new DivElement();
  Timer _delayTimer = new Timer(const Duration(milliseconds: 0),(){});
  MouseEvent _lastMouseMoveEvent;

  Tooltip(DisplayArea this._displayArea);

  void registerSubscriptions(Node node) {
    node.mouseoverElements.forEach((mouseoverElement) {
      _mouseSubscriptions.addAll([
        mouseoverElement.onMouseMove.listen((MouseEvent event){
          _deactivateTooltip();
          _delayTimer = _createTimer(node);
        }),
        mouseoverElement.onMouseOut.listen((MouseEvent event){
          _deactivateTooltip();
        })
      ]);
    });
  }
  
  void reset() {
    _cancelSubscriptions();
    container.classes.clear();
    container.classes.add("${_displayArea.viewModel.styleNames[runtimeType.toString()]}");
  }
  
  Timer _createTimer(Node node) {
    return new Timer(const Duration(milliseconds: 1000),(){
      if (_displayArea.viewModel.tooltipsEnabled) {
        final mousePosition = _displayArea.mousePosition;
        final y = mousePosition.y;
        final x = mousePosition.x;
        num adjX, adjY = 0;
        _repaintTooltipContentFor(node);
        container.classes.add("${Tooltip.VISIBLE}");
        if (x < _displayArea.client.width - x) {
          adjX = x;
        } else {
          adjX = x - container.offset.width;
        }
        if (y < _displayArea.client.height - y) {
          adjY = y+18;
        } else {
          adjY = y - container.offset.height-5;
        }
        container.style..left = "${adjX}px"..top = "${adjY}px";
        _dataModelSubscription = node.dataModel.onVisiblePropertyChange.listen((_) => _repaintTooltipContentFor(node));
      }
    });
  }
  
  void _repaintTooltipContentFor(Node node) {
    container.children.clear();
    final tooltipContent = node.decorator.createTooltip(node.dataModel);
    if (tooltipContent != null) {
      container.append(tooltipContent);
    }
  }
  
  void _cancelSubscriptions() {
    _delayTimer.cancel();
    _cancelDataModelSubscription();
    _mouseSubscriptions.forEach((s) => s.cancel());
    _mouseSubscriptions.clear();
  }
  
  void _deactivateTooltip() {
    container.classes.remove("${Tooltip.VISIBLE}");
    _cancelDataModelSubscription();
    _delayTimer.cancel();
  }
  
  void _cancelDataModelSubscription() {
    if (_dataModelSubscription != null) {
      _dataModelSubscription.cancel();
    }
  }

}
