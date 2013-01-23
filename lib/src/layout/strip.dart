part of treemap_layout;

/**
 * Implementation of the strip layout algorithm. For further details see
 * 'Ordered and Quantum Treemaps: Making Effective Use of 2D Space to Display Hierarchies'
 * by Benjamin B. Bederson, Martin Wattenberg and Ben Shneiderman.
 * ACM Transactions on Graphics, Vol. 21, No. 4, pp. 833-854, October 2002.
 **/
class Strip extends RowBasedLayoutAlgorithms {

  Orientation _stripOrientation;

  Strip({this._stripOrientation});

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
    LayoutHelper row = new LayoutHelper.rowStrip(dimensionRow, parent, orientation);
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
      _stripOrientation = parent.clientWidth >= parent.clientHeight ?
          Orientation.horizontal :
          Orientation.vertical;
    }
    return _stripOrientation;
  }

  num _avgAspectRatio(BranchNode parent, Collection<DataModel> models, Orientation orientation) {
    final aspectRatios = _aspectRatios(parent, models, orientation);
    return aspectRatios.isEmpty ?
        0 : aspectRatios.reduce(0, (accum, ratio) => accum + ratio) / aspectRatios.length;
  }
}
