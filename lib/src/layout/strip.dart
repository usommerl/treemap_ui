part of treemap_layout;

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

  /**
   * Calculates the aspect ratios for every element of [childrenSubset] as if
   * all of them are placed inside the [parent] [ViewNode].
   *
   **/
  List<num> _aspectRatios(ViewNode parent, Collection<DataModel> childrenSubset) {
    assert(parent.clientWidth > 0 && parent.clientHeight > 0);
    if (childrenSubset.isEmpty) {
      return [];
    } else {
      assert(childrenSubset.every((child) {return parent.model.children.contains(child);}));
      List<num> aspectRatios = new List();
      final num sumChildrenSizes = childrenSubset.reduce(0, (acc,model) => acc + model.size);
      final x = new Percentage.from(sumChildrenSizes, parent.model.size).percentageValue(parent.clientHeight);
      childrenSubset.forEach((child) {
        final y = new Percentage.from(child.size, sumChildrenSizes).percentageValue(parent.clientWidth);
        aspectRatios.add(_aspectRatio(x, y));
      });
      return aspectRatios;
    }
  }

  /**
   *  Creates [ViewNode] instances for the provided [dataModels] and places them
   *  inside [parent] along a invisible row.
   *
   *  The parameter [orientation] determines the layout direction of the row.
   */
  void _layoutRow(ViewNode parent, List<DataModel> dataModels, Orientation orientation) {
    final sumModelSizes = dataModels.reduce(0, (acc,model) => acc + model.size);
    final dimensionRow = new Percentage.from(sumModelSizes, dataModels.first.parent.size);
    Row row = new Row.forStripLayout(dimensionRow, orientation, parent);
    dataModels.forEach((model) {
      final dimensionNode = new Percentage.from(model.size, sumModelSizes);
      final height = orientation.isHorizontal() ? Percentage.p100 : dimensionNode;
      final width = orientation.isHorizontal() ? dimensionNode : Percentage.p100;
      final node = new ViewNode(model, width, height, orientation);
      row.add(node);
      if (!model.isLeaf()) {
        layout(node);
      }
    });
  }
}
