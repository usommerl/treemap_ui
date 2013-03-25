part of treemap_ui_layout;

/**
 * Implementation of the strip layout algorithm. For further details see
 * 'Ordered and Quantum Treemaps: Making Effective Use of 2D Space to Display Hierarchies'
 * by Benjamin B. Bederson, Martin Wattenberg and Ben Shneiderman.
 * ACM Transactions on Graphics, Vol. 21, No. 4, pp. 833-854, October 2002.
 **/
class Strip extends LayoutAlgorithm with LayoutUtils {

  Orientation _stripOrientation;

  Strip([this._stripOrientation]);

  void layout(BranchNode parent) {
    List<DataModel> currentStrip = [];
    Queue<DataModel> queue = new Queue.from(parent.dataModel.children);
    final stripOrientation = _determineOrientation(parent);
    while (!queue.isEmpty) {
      final previousStrip = new List.from(currentStrip);
      final model = queue.removeFirst();
      currentStrip.add(model);
      final prevAvgAspectRatio = _avgAspectRatio(parent, previousStrip, stripOrientation);
      final currAvgAspectRatio = _avgAspectRatio(parent, currentStrip, stripOrientation);
      if (!previousStrip.isEmpty && currAvgAspectRatio > prevAvgAspectRatio) {
       _layoutRow(parent, previousStrip, stripOrientation);
       currentStrip.clear();
       queue.addFirst(model);
      } else if (queue.isEmpty) {
        _layoutRow(parent, currentStrip, stripOrientation);
      }
    }
  }

  void _layoutRow(BranchNode parent, List<DataModel> rowModels, Orientation orientation) {
    final sumModelSizes = rowModels.reduce(0, (acc,model) => acc + model.size);
    final dimensionRow = new Percentage.from(sumModelSizes, rowModels.first.parent.size);
    LayoutAid row = new LayoutAid.expand(dimensionRow, parent, orientation);
    rowModels.forEach((model) {
      final node = _createNodeForRow(model, parent.viewModel, new Percentage.from(model.size, sumModelSizes), orientation);
      row.add(node);
      if (node.isBranch) {
        layout(node);
      }
    });
  }

  Orientation _determineOrientation(BranchNode parent) {
    if (_stripOrientation == null) {
      _stripOrientation = parent.client.width >= parent.client.height ?
          Orientation.HORIZONTAL :
          Orientation.VERTICAL;
    }
    return _stripOrientation;
  }

  num _avgAspectRatio(BranchNode parent, Collection<DataModel> models, Orientation orientation) {
    final aspectRatios = _aspectRatios(parent, models, orientation);
    return aspectRatios.isEmpty ?
        0 : aspectRatios.reduce(0, (accum, ratio) => accum + ratio) / aspectRatios.length;
  }
  
  num _availableWidth(BranchNode node) =>
      _availableWidthPercentage(node).percentageValue(node.client.width);

  num _availableHeight(BranchNode node) =>
      _availableHeightPercentage(node).percentageValue(node.client.height);

  Percentage _availableWidthPercentage(BranchNode node) {
    final verticalRows = node.layoutAids.where((row) => row.orientation.isVertical);
    return Percentage.ONE_HUNDRED - verticalRows.reduce(Percentage.ZERO, (sum,elem) => sum + elem.width);
  }

  Percentage _availableHeightPercentage (BranchNode node) {
    final horizontalRows = node.layoutAids.where((row) => row.orientation.isHorizontal);
    return Percentage.ONE_HUNDRED - horizontalRows.reduce(Percentage.ZERO, (sum,elem) => sum + elem.height);
  }
}
