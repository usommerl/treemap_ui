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
      Queue<DataModel> queue = new Queue.from(parent.model.children);
      List<DataModel> currentStrip = new List();
      var stripOrientation = _determineStripOrientation(parent);
      while (!queue.isEmpty) {
        var previousStrip = new List.from(currentStrip);
        var model = queue.removeFirst();
        currentStrip.add(model);
        var prevAvgAspectRatio = _avgAspectRatio(parent.clientWidth, parent.clientHeight,previousStrip);
        var currAvgAspectRatio = _avgAspectRatio(parent.clientWidth, parent.clientHeight,currentStrip);
        if (!previousStrip.isEmpty && currAvgAspectRatio > prevAvgAspectRatio) {
         _layoutRow(parent, previousStrip, stripOrientation);
         currentStrip.clear();
         queue.addFirst(model);
        } else if (!currentStrip.isEmpty && queue.isEmpty) {
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

  void _layoutRow(ViewNode parent, List<DataModel> dataModels, Orientation orientation) {
    final num sumOfAllModels = dataModels.reduce(0, (acc,model) => acc + model.size);
    var dimensionRow = _percentValue(dataModels.first.parent.size, sumOfAllModels);
    Row row = new Row(dimensionRow, orientation, parent);
    dataModels.forEach((model) {
      var dimensionNode = _percentValue(sumOfAllModels, model.size);
      var height = orientation.isHorizontal() ? 100 : dimensionNode;
      var width = orientation.isHorizontal() ? dimensionNode : 100;
      var node = new ViewNode(model, width, height, orientation);
      row.add(node);
      if (!model.isLeaf()) {
        layout(node);
      }
    });
  }

  num _avgAspectRatio(int availableWidth, int avilableHeight, List<DataModel> dataModels) {
    if (dataModels.isEmpty) {
      return 0;
    } else {
      final num sumOfAllModels = dataModels.reduce(0, (acc,model) => acc + model.size);
      List<num> aspectRatios = new List();
      var dimensionXPercentage = _percentValue(dataModels.first.parent.size, sumOfAllModels );
      var dimensionX = (avilableHeight / 100) * dimensionXPercentage;
      dataModels.forEach((model) {
        var dimensionYPercentage = _percentValue(sumOfAllModels, model.size);
        var dimensionY = (availableWidth / 100) * dimensionYPercentage;
        aspectRatios.add(_aspectRatio(dimensionX, dimensionY));
      });
      return aspectRatios.reduce(0, (acc, e) => acc + e) / aspectRatios.length;
    }
  }
}
