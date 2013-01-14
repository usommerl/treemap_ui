part of treemap_layout;

class Squarified extends RowBasedLayoutAlgorithms {
  
  void layout(TreemapNode parent) {
    if (parent.model.isBranch) {
      List<DataModel> currentRow = [];
      final descendingSizes = ((a,b) => b.size.compareTo(a.size));
      Queue<DataModel> queue = new Queue.from(sortedCopy(parent.model.children, descendingSizes));
      while(!queue.isEmpty) {
        final model = queue.removeFirst();
        final previousRow = new List.from(currentRow);
        currentRow.add(model);
        final orientation = _determineOrientation(parent);
        final prevWorstAspectRatio = _worstAspectRatio(parent, previousRow, orientation);
        final currWorstAspectRatio = _worstAspectRatio(parent, currentRow, orientation);
        if (!previousRow.isEmpty && prevWorstAspectRatio < currWorstAspectRatio) {
          _layoutRow(parent, previousRow, orientation);
          currentRow.clear();
          queue.addFirst(model);
        } else if (queue.isEmpty) {
          _layoutRow(parent, currentRow, orientation);
        }
      }
    }
  }

  Orientation _determineOrientation(TreemapNode node) => 
      _availableWidth(node) > _availableHeight(node) ?
          Orientation.vertical :
          Orientation.horizontal;

  num _worstAspectRatio(TreemapNode parent, Collection<DataModel> dataModels, Orientation orientation) {
    final aspectRatios = _aspectRatios(parent, dataModels, orientation);
    return aspectRatios.reduce(0, (acc,ratio) => max(acc,ratio));
  }

  void _layoutRow(TreemapNode parent, List<DataModel> rowModels, Orientation orientation) {
    final availableWidthPercentage = _availableWidthPercentage(parent);
    final availableHeightPercentage = _availableHeightPercentage(parent);
    final num sumModels = rowModels.reduce(0, (acc,model) => acc + model.size);
    final num sumNotPlacedModels = _notPlacedModels(parent).reduce(0, (acc, model) => acc + model.size);
    final percentageRowItems = new Percentage.from(sumModels, sumNotPlacedModels);
    final row = orientation.isHorizontal() ?
        new LayoutHelper.rowSquarified(availableWidthPercentage, percentageRowItems.of(availableHeightPercentage), parent, orientation):
        new LayoutHelper.rowSquarified(percentageRowItems.of(availableWidthPercentage), availableHeightPercentage, parent, orientation);
    rowModels.forEach((model) {
      final node = _createNodeForRow(model, new Percentage.from(model.size, sumModels), orientation);
      row.add(node);
      if (model.isBranch) {
        layout(node);
      }
    });
  }
}
