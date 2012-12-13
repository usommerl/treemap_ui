part of treemapLayout;

/**
 * Implementation of the strip algorithm. For further details see
 * 'Ordered and Quantum Treemaps: Making Effective Use of 2D Space to Display Hierarchies'
 * by Benjamin B. Bederson, Martin Wattenberg and Ben Shneiderman, pp. 7-9, 2001
 *
 **/
class Strip extends LayoutAlgorithm {

  Orientation _stripOrientation;
  
  Strip([this._stripOrientation]);

  void layout(ViewNode parent) {
    if (!parent.model.isLeaf()) {
      List<DataModel> currentStrip = [];
      Queue<DataModel> queue = new Queue.from(parent.model.children);
      var stripOrientation = _determineStripOrientation(parent);
      while (!queue.isEmpty) {
        var previousStrip = new List.from(currentStrip);
        var model = queue.removeFirst();
        currentStrip.add(model);
        var prevAvgAspectRatio = _avgAspectRatio(parent, previousStrip);
        var currAvgAspectRatio = _avgAspectRatio(parent, currentStrip);
        if (!previousStrip.isEmpty && currAvgAspectRatio > prevAvgAspectRatio) {
         _layoutRow(parent, previousStrip, stripOrientation);
         currentStrip.clear();
         queue.addFirst(model);
        } else if (queue.isEmpty) {
          _layoutRow(parent, currentStrip, stripOrientation);
        }
      }
    }
  }

  Orientation _determineStripOrientation(ViewNode parent) {
    if (_stripOrientation == null) {
      _stripOrientation = parent.clientWidth >= parent.clientHeight ? 
          Orientation.HORIZONTAL : 
          Orientation.VERTICAL;
    }
    return _stripOrientation;
  }

  num _avgAspectRatio(ViewNode parent, Collection<DataModel> dataModels) {
    var aspectRatios = _aspectRatios(parent, dataModels);
    return aspectRatios.isEmpty ? 0 :
          aspectRatios.reduce(0, (acc, e) => acc + e) / aspectRatios.length;
  }
}
