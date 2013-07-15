part of treemap_ui.view;

class DisplayArea {
  
  final DivElement _outerDiv;
  final Element _actualDisplayArea = new Element.html("<div style='position: relative; width: 100%; height: 100%; margin: 0px; padding: 0px; border: 0px'></div>");
  ViewModel _viewModel;
  MouseEvent _lastMouseMoveEvent;
  Tooltip _tooltip;
  
  DisplayArea(DivElement this._outerDiv) {
    if (_outerDiv.client.height <= 0) {
      throw new ArgumentError("The <div> element has to have a height greater than zero and must be attached to the document");
    }
    if (_outerDiv.children.length > 0) {
      throw new ArgumentError("Do not add any extra elements to the <div> element");
    }
    _outerDiv.append(_actualDisplayArea);
    _tooltip = new Tooltip(this);
    _actualDisplayArea.append(_tooltip.shell);
    _actualDisplayArea.onMouseMove.listen((MouseEvent e) => _lastMouseMoveEvent = e);
  }
  
  void clear() => _actualDisplayArea.children.removeWhere((Element e) => !identical(e,_tooltip.shell));
  
  void purgeAndSet(ViewModel viewModel) {
    _viewModel = viewModel;
    _tooltip.reset();
    clear();
  }
  
  html.Node append(Element newChild) => _actualDisplayArea.append(newChild);
  
  Rect get client => _actualDisplayArea.client;
  
  Point get mousePosition {
    final rect = _actualDisplayArea.getBoundingClientRect();
    final y = _lastMouseMoveEvent.client.y - rect.top;
    final x = _lastMouseMoveEvent.client.x - rect.left;
    return new Point(x,y);                      
  }
  
  Tooltip get tooltip => _tooltip;
  
  ViewModel get viewModel => _viewModel;
  
}